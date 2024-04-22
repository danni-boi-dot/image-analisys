% Carga las imágenes
a = imread('city.jpg');
b = imread('dinamarca.jpg');

% Convierte las imágenes a escala de grises
a_gray = rgb2gray(a);
b_gray = rgb2gray(b);

% Ecualización de histograma para la imagen a
a_eq = ecualizar_histograma(a_gray);
b_eq = ecualizar_histograma(b_gray);

% Transferencia de histograma de la imagen b con referencia a la imagen a ecualizada
b_trans = transferir_histograma(b_gray, a_eq);

% Visualización de imágenes
figure;
subplot(2,3,1);
imshow(a_eq);
title('Imagen A');
subplot(2,3,3);
imshow(b_eq);
title('Imagen B');
subplot(2,3,2);
imshow(b_trans);
title('Imagen');

subplot(2,3,4);
imhist(a_eq);
title('Histograma A');
subplot(2,3,6);
imhist(b_eq);
title('Histograma B');
subplot(2,3,5);
imhist(b_trans);
title('Histograma');

% Función para ecualizar el histograma
function img_eq = ecualizar_histograma(img)
    % Calcular el histograma de la imagen
    h_img = imhist(img);
    
    % Calcular el histograma acumulativo normalizado de la imagen
    cdf_img = cumsum(h_img) / numel(img);
    
    % Crear un mapeo de los valores de intensidad de la imagen
    mapeo = cdf_img;
    
    % Aplicar el mapeo a la imagen
    img_eq = mapeo(img+1);
end

% Función para transferir el histograma
function img_trans = transferir_histograma(img, img_ref)
    % Calcular el histograma de la imagen de referencia
    h_ref = imhist(img_ref);
    
    % Calcular el histograma acumulativo normalizado de la imagen de referencia
    cdf_ref = cumsum(h_ref) / numel(img_ref);
    
    % Crear un mapeo de los valores de intensidad de la imagen a los de la imagen de referencia
    mapeo = zeros(256,1);
    for idx = 1 : 256
        [~,ind] = min(abs(cdf_ref - (idx-1)/255));
        mapeo(idx) = ind-1;
    end
    
    % Aplicar el mapeo a la imagen
    img_trans = mapeo(img+1);
    
    % Normalizar los valores de la imagen resultante para que estén en el rango de 0 a 255
    img_trans = uint8(round(double(img_trans) / max(img_trans(:)) * 255));
end
