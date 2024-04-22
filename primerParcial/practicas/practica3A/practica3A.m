% Carga la imagen 'peppers.png'
a = imread('city.jpg');

% Extracción de canales RGB
R = a(:,:,1);
G = a(:,:,2);
B = a(:,:,3);

% Ecualización de histograma para cada canal
R_eq = ecualizar_histograma(R);
G_eq = ecualizar_histograma(G);
B_eq = ecualizar_histograma(B);

% Recombinación de canales
a_eq = cat(3, R_eq, G_eq, B_eq);

% Visualización de imágenes
figure;
subplot(1,2,1);
imshow(a);
title('Imagen Original');
subplot(1,2,2);
imshow(a_eq);
title('Imagen Ecualizada');

% Función para ecualizar el histograma
function img_eq = ecualizar_histograma(img)
    % Calcular el histograma
    h = imhist(img);
    
    % Calcular el histograma acumulativo normalizado
    cdf = cumsum(h) / numel(img);
    
    % Mapear los valores de la imagen original a los del histograma acumulativo
    img_eq = cdf(img+1);
    
    % Ajustar el rango de la imagen al rango [0, 255]
    img_eq = uint8(255 * img_eq);
end