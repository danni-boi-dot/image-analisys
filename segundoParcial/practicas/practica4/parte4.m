% Cargar la imagen
imagen = imread('imagenes\city.jpg');

% Convertir la imagen a escala de grises si es necesario
if size(imagen, 3) == 3
    imagen_gris = rgb2gray(imagen);
else
    imagen_gris = imagen;
end

% Convertir la imagen a tipo double
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

% Matriz de cuantificación JPEG estándar (calidad 50)
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

% Visualizar la imagen original y la imagen cuantificada
subplot(1, 2, 1);
imshow(uint8(imagen_gris));
title('Imagen Original');

subplot(1, 2, 2);
imshow(uint8(coeficientes_dct_cuantificados));
title('Imagen Cuantificada (DCT JPEG)');

% Llamar a la función de escaneo zigzag para la matriz de coeficientes cuantificados
coeficientes_escaneados = zigzag_escaneo(coeficientes_dct_cuantificados);

% Mostrar los coeficientes cuantificados escaneados
disp('Coeficientes cuantificados escaneados en orden zigzag');

% Crear una función para el escaneo zigzag
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