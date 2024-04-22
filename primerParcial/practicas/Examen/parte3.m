% Leer la imagen
img = imread('dinamarca.jpg');

% Obtener las dimensiones de la imagen
[rows, cols, ~] = size(img);

% Crear una nueva imagen con el doble de tamaño
new_img = zeros(rows*2, cols*2, 3, 'uint8');

% Convertir la imagen a escala de grises y colocarla en el cuadrante superior izquierdo
new_img(1:rows, 1:cols, :) = repmat(rgb2gray(img), [1, 1, 3]);

% Extraer el canal verde y colocarlo en el cuadrante superior derecho
new_img(1:rows, cols+1:end, 2) = img(:,:,2);

% Extraer el canal rojo y colocarlo en el cuadrante inferior izquierdo
new_img(rows+1:end, 1:cols, 1) = img(:,:,1);

% Convertir la imagen a binario y colocarla en el cuadrante inferior derecho
new_img(rows+1:end, cols+1:end, :) = repmat(imbinarize(rgb2gray(img)), [1, 1, 3]);

% Mostrar la nueva imagen
imshow(new_img);



% Convertir la imagen a escala de grises
img_gray = rgb2gray(img);

% Seleccionar una ventana local de 100 elementos en total
window_size = 10; % Raíz cuadrada de 100
start_row = 1; % Cambia esto para mover la ventana
start_col = 1; % Cambia esto para mover la ventana
local_window = img_gray(start_row:start_row+window_size-1, start_col:start_col+window_size-1);

% Calcular el histograma de la ventana local
histogram_values = calculate_histogram(local_window);

% Mostrar el histograma utilizando bar
figure;
subplot(2, 1, 1);
bar(0:255, histogram_values);
title('Histograma');
xlabel('Nivel de gris');
ylabel('Frecuencia');

% Mostrar la imagen
subplot(2, 1, 2);
imshow(local_window);
title('Imagen');

% Preguntar al usuario los valores mínimo y máximo para la compresión
intervalo_min = input('Dame el valor min del intervalo...= ');
intervalo_max = input('Dame el valor max del intervalo...= ');

% Calcular el mínimo y el máximo de la imagen
minimo = double(min(local_window(:)));
maximo = double(max(local_window(:)));

% Calcular el factor de escala
dato1 = (intervalo_max - intervalo_min);
dato2 = (maximo - minimo);
dato3 = (double(dato1) / double(dato2));

% Comprimir la imagen
img_comprimida = uint8(dato3 * (double(local_window) - minimo) + intervalo_min);

% Descomprimir la imagen
img_descomprimida = uint8(((double(img_comprimida) - intervalo_min) / dato3) + minimo);

% Calcular los histogramas de las imágenes comprimida y descomprimida
histogram_comprimida = calculate_histogram(img_comprimida);
histogram_descomprimida = calculate_histogram(img_descomprimida);

% Mostrar los histogramas y las imágenes
figure;
subplot(2, 2, 1);
bar(0:255, histogram_comprimida);
title('Histograma de la imagen comprimida');
xlabel('Nivel de gris');
ylabel('Frecuencia');
subplot(2, 2, 2);
imshow(img_comprimida);
title('Imagen comprimida');
subplot(2, 2, 3);
bar(0:255, histogram_descomprimida);
title('Histograma de la imagen descomprimida');
xlabel('Nivel de gris');
ylabel('Frecuencia');
subplot(2, 2, 4);
imshow(img_descomprimida);
title('Imagen descomprimida');

% Función para calcular el histograma de una imagen
function histogram_values = calculate_histogram(image)
    histogram_values = zeros(1, 256);
    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            gray_level = image(i, j) + 1;
            histogram_values(gray_level) = histogram_values(gray_level) + 1;
        end
    end
end