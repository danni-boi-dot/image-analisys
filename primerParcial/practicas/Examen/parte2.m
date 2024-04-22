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

