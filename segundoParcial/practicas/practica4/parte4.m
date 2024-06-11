% Leer la imagen
imagen = imread('imagenes\dinamarca.jpg');

% Obtener las dimensiones de la imagen
[filas, columnas] = size(imagen);

% Pedir al usuario el número de bloque
bloque_num = input(['Ingrese el número de bloque 8x8 (entre 1 y ' num2str(filas/8 * columnas/8) '): ']);

% Calcular las coordenadas del bloque en la imagen original
bloque_fila = mod(bloque_num - 1, filas/8) * 8 + 1;
bloque_columna = floor((bloque_num - 1) / (filas/8)) * 8 + 1;

% Obtener el bloque 8x8 de la imagen
bloque = imagen(bloque_fila:bloque_fila+7, bloque_columna:bloque_columna+7)

% Mostrar el bloque original
imshow(bloque);
title(['Bloquesito: ' num2str(bloque_num)]);

% Aplicar la DCT al bloque
dct_bloque = dct2(double(bloque));

% Cuantificar los coeficientes de la DCT
Q = [16 11 10 16 24 40 51 61;
     12 12 14 19 26 58 60 55;
     14 13 16 24 40 57 69 56;
     14 17 22 29 51 87 80 62;
     18 22 37 56 68 109 103 77;
     24 35 55 64 81 104 113 92;
     49 64 78 87 103 121 120 101;
     72 92 95 98 112 100 103 99];

dct_quantizado = round(dct_bloque ./ Q);

% Función en zigzag
indices_zigzag = [1 2 6 7 15 16 28 29;
                  3 5 8 14 17 27 30 43;
                  4 9 13 18 26 31 42 44;
                  10 12 19 25 32 41 45 54;
                  11 20 24 33 40 46 53 55;
                  21 23 34 39 47 52 56 61;
                  22 35 38 48 51 57 60 62;
                  36 37 49 50 58 59 63 64];

zigzag_vector = dct_quantizado(indices_zigzag);

% Crear una tabla HTML con los resultados en zigzag
html = '<html><head><title>Resultados en zigzag</title><style>';
html = strcat(html, 'table {width: 50%; border-collapse: collapse;}');
html = strcat(html, 'th, td {border: 1px solid black; padding: 8px; text-align: center;}');
html = strcat(html, 'th {background-color: #f2f2f2;}');
html = strcat(html, '</style></head><body><table><tr><th>Índice:Valor</th></tr>');

for i = 1:8
    html = strcat(html, '<tr>');
    for j = 1:8
        indice = indices_zigzag((i-1)*8 + j);
        valor = zigzag_vector((i-1)*8 + j);
        html = strcat(html, '<td>', num2str(indice), ': ', num2str(valor), '</td>');
    end
    html = strcat(html, '</tr>');
end

html = strcat(html, '</table></body></html>');

% Guardar la tabla HTML en un archivo
fid = fopen('resultados_zigzag.html', 'w');
fprintf(fid, '%s', html);
fclose(fid);

disp(['Bloque ' num2str(bloque_num) ' procesado. Puedes ver los resultados en el archivo "resultados_zigzag.html".']);

% Crear una tabla HTML con los valores diferentes de 0 y sus complementos a 2
html = '<html><head><title>Valores en zigzag y complemento a 2</title><style>';
html = strcat(html, 'table {width: 50%; border-collapse: collapse;}');
html = strcat(html, 'th, td {border: 1px solid black; padding: 8px; text-align: center;}');
html = strcat(html, 'th {background-color: #f2f2f2;}');
html = strcat(html, '</style></head><body><table><tr><th>Índice</th><th>Valor</th><th>Complemento a 2</th></tr>');

% Almacenar los valores en una matriz temporal para su ordenación
valores = [];

for i = 1:numel(indices_zigzag)
    indice = indices_zigzag(i);
    valor = zigzag_vector(i);
    
    if valor ~= 0
        binario = dec2bin(abs(valor), 8);
        
        if valor < 0
            complemento2 = bin2dec(binario);
            complemento2 = 2^8 - complemento2;
            complemento2 = dec2bin(complemento2, 8);
        else
            complemento2 = binario;
        end
        
        % Añadir a la matriz de valores
        valores = [valores; indice, valor, bin2dec(complemento2)];
    end
end

% Ordenar la matriz por la primera columna (índice)
valores = sortrows(valores, 1);

% Crear las filas HTML con los valores ordenados
for i = 1:size(valores, 1)
    html = strcat(html, '<tr><td>', num2str(valores(i, 1)), '</td><td>', num2str(valores(i, 2)), '</td><td>', dec2bin(valores(i, 3), 8), '</td></tr>');
end

% Añadir EOB (End of Block) y 1010 al final
html = strcat(html, '<tr><td>Bloque Final</td><td>1010</td><td></td></tr>');

html = strcat(html, '</table></body></html>');

% Guardar la tabla HTML en un archivo
fid = fopen('valores_complemento2.html', 'w');
fprintf(fid, '%s', html);
fclose(fid);

disp(['Bloque ' num2str(bloque_num) ' procesado. Puedes ver los resultados en el archivo "valores_complemento2.html".']);
