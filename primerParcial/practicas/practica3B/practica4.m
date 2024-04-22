% Leer la imagen
img = imread('dinamarca.jpg');

% Agregar ruido gaussiano a la imagen
img_ruido = imnoise(img,'gaussian');

% Aplicar filtro de moda
img_moda = moda_imagen(img_ruido);

% Aplicar filtro de mediana
img_mediana = mediana_imagen(img_ruido);

% Aplicar filtro de máximo y mínimo
img_fmax = zeros(size(img));
img_fmin = zeros(size(img));
for k = 1:3
    img_fmax(:,:,k) = ordfilt2(img_ruido(:,:,k), 9, ones(3,3)); % Filtro máximo
    img_fmin(:,:,k) = ordfilt2(img_ruido(:,:,k), 1, ones(3,3)); % Filtro mínimo
end
img_fmax = uint8(img_fmax);
img_fmin = uint8(img_fmin);

% Mostrar las imágenes en un solo subplot
figure;
subplot(2,3,1), imshow(img), title('Imagen original');
subplot(2,3,2), imshow(img_ruido), title('Imagen con ruido');
subplot(2,3,3), imshow(img_moda), title('Imagen con filtro de moda');
subplot(2,3,4), imshow(img_mediana), title('Imagen con filtro de mediana');
subplot(2,3,5), imshow(img_fmax), title('Imagen con filtro máximo');
subplot(2,3,6), imshow(img_fmin), title('Imagen con filtro mínimo');

% Función para calcular la moda de una imagen
function img_moda = moda_imagen(img)
    [M, N, ~] = size(img);
    img_moda = zeros(M, N, 3);
    for i = 2:M-1
        for j = 2:N-1
            for k = 1:3
                vecindario = img(i-1:i+1, j-1:j+1, k);
                img_moda(i,j,k) = mode(vecindario(:));
            end
        end
    end
    img_moda = uint8(img_moda);
end

% Función para calcular la mediana de una imagen
function img_mediana = mediana_imagen(img)
    [M, N, ~] = size(img);
    img_mediana = zeros(M, N, 3);
    for i = 2:M-1
        for j = 2:N-1
            for k = 1:3
                vecindario = img(i-1:i+1, j-1:j+1, k);
                img_mediana(i,j,k) = median(vecindario(:));
            end
        end
    end
    img_mediana = uint8(img_mediana);
end
