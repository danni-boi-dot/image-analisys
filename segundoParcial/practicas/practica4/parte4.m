% Cargar la imagen
disp('Cargando la imagen...');
img = imread('imagenes\gatito.jpg');

% Guardar el tamaño del archivo original
info_original = dir('imagenes\gatito.jpg');
tamano_original = info_original.bytes;

% Convertir la imagen a escala de grises si es necesario
disp('Convirtiendo la imagen a escala de grises si es necesario...');
if size(img, 3) == 3
    imagen_gris = rgb2gray(img);
else
    imagen_gris = img;
end

% Convertir la imagen a tipo double
disp('Convirtiendo la imagen a tipo double...');
imagen_gris = double(imagen_gris);

% Tamaño del bloque para la DCT
bloque_tamano = 8;

% Tamaño de la imagen
[filas, columnas] = size(imagen_gris);

% Calcular el número de bloques en filas y columnas
num_filas_bloques = floor(filas / bloque_tamano);
num_columnas_bloques = floor(columnas / bloque_tamano);

% Preasignar matriz para almacenar los coeficientes de la DCT cuantificados
coeficientes_dct_cuantificados = zeros(filas, columnas);

% Matriz de cuantificación JPEG estándar
matriz_cuantificacion = [
    16,  11,  10,  16,  24,  40,  51,  61;
    12,  12,  14,  19,  26,  58,  60,  55;
    14,  13,  16,  24,  40,  57,  69,  56;
    14,  17,  22,  29,  51,  87,  80,  62;
    18,  22,  37,  56,  68, 109, 103,  77;
    24,  35,  55,  64,  81, 104, 113,  92;
    49,  64,  78,  87, 103, 121, 120, 101;
    72,  92,  95,  98, 112, 100, 103,  99
];

% Iterar sobre cada bloque en la imagen
disp('Aplicando la DCT y cuantificando los bloques...');
for i = 1:num_filas_bloques
    for j = 1:num_columnas_bloques
        % Obtener el bloque actual
        bloque = imagen_gris((i-1)*bloque_tamano+1:i*bloque_tamano, (j-1)*bloque_tamano+1:j*bloque_tamano);
        
        % Aplicar la Transformada Discreta del Coseno (DCT)
        dct_bloque = dct2(bloque);
        
        % Cuantificar el bloque utilizando la matriz de cuantificación JPEG
        dct_bloque_cuantificado = round(dct_bloque ./ matriz_cuantificacion);
        
        % Almacenar los coeficientes cuantificados en la matriz de salida
        coeficientes_dct_cuantificados((i-1)*bloque_tamano+1:i*bloque_tamano, (j-1)*bloque_tamano+1:j*bloque_tamano) = dct_bloque_cuantificado;
    end
end

% Llamar a la función de escaneo zigzag para la matriz de cuantificados
disp('Realizando el escaneo zigzag...');
coeficientes_escaneados = zigzag_escaneo(coeficientes_dct_cuantificados);

% Llamar a la función de codificación de Huffman
disp('Codificando los coeficientes escaneados con Huffman...');
codigos_huffman = huffman_codificacion(coeficientes_escaneados);

% Decodificación de Huffman y reconstrucción de la matriz de coeficientes
disp('Decodificando los coeficientes Huffman...');
coeficientes_decodificados = huffman_decodificacion(codigos_huffman, [num_filas_bloques, num_columnas_bloques]);

% Reconstrucción de la matriz de coeficientes
coeficientes_reconstruidos = zigzag_inverso(coeficientes_decodificados, [filas, columnas]);

% Escritura del Archivo JPEG
disp('Escribiendo el archivo JPEG...');
escribir_archivo_JPEG(codigos_huffman);

% Guardar el tamaño del archivo comprimido
info_comprimido = dir('imagen_codificada.bin');
tamano_comprimido = info_comprimido.bytes;

% Comparar los tamaños de los archivos
disp(['Tamaño del archivo original: ', num2str(tamano_original), ' bytes']);
disp(['Tamaño del archivo comprimido: ', num2str(tamano_comprimido), ' bytes']);
if tamano_comprimido < tamano_original
    disp('La imagen se comprimióctamente.');
else
    disp('La imagen no se comprimió correctamente.');
end

% Verificar la imagen después del proceso de compresión
disp('Verificando la imagen después del proceso de compresión...');
imagen_despues_compresion = imread('imagen_codificada.bin');
subplot(1,2,1);
imshow(img);
title('Imagen Original');

subplot(1,2,2);
imshow(imagen_despues_compresion); % Convertir la DCT de nuevo a uint8 para visualizarla correctamente
title('Imagen JPEG');

% Aplicación de la IDCT a cada bloque
disp('Aplicando la IDCT a los bloques...');
imagen_reconstruida = zeros(filas, columnas);
for i = 1:num_filas_bloques
    for j = 1:num_columnas_bloques
        % Obtener el bloque actual
        bloque_coeficientes = coeficientes_reconstruidos{i, j};
        
        % Aplicar la IDCT al bloque de coeficientes
        bloque_reconstruido = idct2(bloque_coeficientes);
        
        % Almacenar el bloque reconstruido en la imagen final
        imagen_reconstruida((i-1)*bloque_tamano+1:i*bloque_tamano, (j-1)*bloque_tamano+1:j*bloque_tamano) = bloque_reconstruido;
    end
end

% Ajustar los valores reconstruidos para que estén en el rango correcto
imagen_reconstruida(imagen_reconstruida < 0) = 0;
imagen_reconstruida(imagen_reconstruida > 255) = 255;

% Convertir la imagen reconstruida a tipo uint8
imagen_reconstruida = uint8(imagen_reconstruida);

% Guardar la imagen reconstruida
imwrite(imagen_reconstruida, 'imagen_reconstruida.jpg');

% Verificar la imagen reconstruida
figure;
imshow(imagen_reconstruida);
title('Imagen Reconstruida');

% Añadir la función IDCT
function salida = idct2(entrada)
    salida = idct(idct(entrada')')';
end

function coeficientes_decodificados = huffman_decodificacion(codigos_huffman, dimensiones)
    % Inicializar la matriz de coeficientes decodificados
    coeficientes_decodificados = cell(dimensiones(1), dimensiones(2));
    
    % Recorrer los códigos Huffman y decodificarlos
    idx = 1;
    for i = 1:dimensiones(1)
        for j = 1:dimensiones(2)
            % Verificar si idx excede la longitud de codigos_huffman
            if idx > length(codigos_huffman)
                break; % Salir del bucle si idx excede la longitud de codigos_huffman
            end
            
            coeficientes_decodificados{i, j} = codigos_huffman{idx};
            idx = idx + 1;
        end
    end
end

function matriz_reconstruida = zigzag_inverso(coeficientes_escaneados, dimensiones)
    % Inicializar la matriz reconstruida
    matriz_reconstruida = zeros(dimensiones);
    
    % Dimensiones de la matriz original
    filas = dimensiones(1);
    columnas = dimensiones(2);
    
    % Inicializar índice
    idx = 1;
    
    % Recorrer los coeficientes escaneados y reconstruir la matriz original
    for i = 1:filas
        for j = 1:columnas
            % Verificar si idx excede la longitud de coeficientes_escaneados
            if idx > numel(coeficientes_escaneados)
                break; % Salir del bucle si idx excede la longitud de coeficientes_escaneados
            end
            
            % Asignar el coeficiente escaneado a la matriz reconstruida
            matriz_reconstruida(i, j) = coeficientes_escaneados{idx};
            idx = idx + 1;
        end
    end
end

% Función para escribir el archivo JPEG
function escribir_archivo_JPEG(codigos_huffman)
    % Abrir el archivo para escritura
    fid = fopen('imagen_codificada.bin', 'w');
    
    % Escribir cada código Huffman en el archivo
    for i = 1:length(codigos_huffman)
        % Convertir el código Huffman a binario
        codigo_binario = dec2bin(codigos_huffman{i});
        
        % Escribir el código binario en el archivo
        fwrite(fid, codigo_binario, 'ubit1');
    end
    
    % Cerrar el archivo
    fclose(fid);
end

% Función para el escaneo zigzag
function salida = zigzag_escaneo(entrada)
    [filas, columnas] = size(entrada);
    salida = zeros(1, filas * columnas);
    % Inicializar índices
    idx = 1;
    i = 1;
    j = 1;
    % Bandera para indicar dirección de escaneo
    ascendente = true;
    while idx <= filas * columnas
        salida(idx) = entrada(i, j);
        idx = idx + 1;
        if ascendente
            if j == columnas
                i = i + 1;
                ascendente = false;
            elseif i == 1
                j = j + 1;
                ascendente = false;
            else
                i = i - 1;
                j = j + 1;
            end
        else
            if i == filas
                j = j + 1;
                ascendente = true;
            elseif j == 1
                i = i + 1;
                ascendente = true;
            else
                i = i + 1;
                j = j - 1;
            end
        end
    end
end

% Función para la codificación de Huffman
function codificacion_huffman = huffman_codificacion(simbolos)
    % Calcular la frecuencia de cada símbolo
    frecuencia = histcounts(simbolos, 0:255);
    
    % Crear la estructura de datos para los nodos del árbol de Huffman
    nodos = struct('simbolo', {}, 'frecuencia', {}, 'codigo', {}, 'izquierda', {}, 'derecha', {});
    for i = 1:length(frecuencia)
        nodos(i).simbolo = i-1;
        nodos(i).frecuencia = frecuencia(i);
        nodos(i).codigo = '';
    end
    
    % Construir el árbol de Huffman
    while length(nodos) > 1
        % Ordenar los nodos por frecuencia
        [~, idx] = sort([nodos.frecuencia]);
        nodos = nodos(idx);
        
        % Tomar los dos nodos con menor frecuencia
        nodo1 = nodos(1);
        nodo2 = nodos(2);
        
        % Asignar códigos binarios a los nodos
        nodos(1).codigo = ['0', nodos(1).codigo];
        nodos(2).codigo = ['1', nodos(2).codigo];
        
        % Crear un nuevo nodo con la suma de las frecuencias y asignarle hijos
        nuevo_nodo.simbolo = -1;
        nuevo_nodo.frecuencia = nodo1.frecuencia + nodo2.frecuencia;
        nuevo_nodo.codigo = '';
        nuevo_nodo.izquierda = nodo1;
        nuevo_nodo.derecha = nodo2;
        
        % Eliminar los dos nodos tomados
        nodos = nodos(3:end);
        
        % Agregar el nuevo nodo al final del vector
        nodos(end+1) = nuevo_nodo;
    end
    
    % Obtener las codificaciones de Huffman para cada símbolo
    codificacion_huffman = cell(256, 1);
    for i = 1:length(nodos)
        % Asegurarse de que el índice sea positivo antes de usarlo
        indice = max(1, nodos(i).simbolo + 1);
        codificacion_huffman{indice} = nodos(i).codigo;
    end
end
