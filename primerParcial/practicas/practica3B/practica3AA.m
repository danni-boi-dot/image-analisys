% Carga la imagen 'peppers.png'
a = imread('dinamarca.jpg');

% Extracción de canales RGB
R = a(:,:,1);
G = a(:,:,2);
B = a(:,:,3);

% Cálculo de mínimo y máximo por canal
minimo_R = min(min(R));
maximo_R = max(max(R));
minimo_G = min(min(G));
maximo_G = max(max(G));
minimo_B = min(min(B));
maximo_B = max(max(B));

% Pedir intervalo
intervalo_min = input('Dame el valor min del intervalo...= ');
intervalo_max = input('Dame el valor max del intervalo...= ');

% Cálculo de factor de escala para cada canal
dato1 = (intervalo_max - intervalo_min);
dato3_R = (double(dato1) / double(maximo_R-minimo_R));
dato3_G = (double(dato1) / double(maximo_G-minimo_G));
dato3_B = (double(dato1) / double(maximo_B-minimo_B));

% Procesamiento de cada canal
for i=1:size(R,1)
    for j=1:size(R,2)
        procesada_R(i,j) = dato3_R * (R(i,j) - minimo_R) + intervalo_min;
        procesada_G(i,j) = dato3_G * (G(i,j) - minimo_G) + intervalo_min;
        procesada_B(i,j) = dato3_B * (B(i,j) - minimo_B) + intervalo_min;
    end
end

% Conversión a uint8 y recombinación de canales
% procesada: Imagen RGB procesada
procesada_R = uint8(procesada_R);
procesada_G = uint8(procesada_G);
procesada_B = uint8(procesada_B);
procesada(:,:,1) = procesada_R;
procesada(:,:,2) = procesada_G;
procesada(:,:,3) = procesada_B;

% Ecualización de histograma para cada canal
R_eq = ecualizar_histograma(procesada_R);
G_eq = ecualizar_histograma(procesada_G);
B_eq = ecualizar_histograma(procesada_B);

% Recombinación de canales
a_eq = cat(3, R_eq, G_eq, B_eq);

% Visualización de imágenes
figure;
subplot(1,2,1);
imshow(procesada);
title('Imagen Procesada');
subplot(1,2,2);
imshow(a_eq);
title('Imagen Ecualizada');

% Función para ecualizar el histograma
function img_eq = ecualizar_histograma(img)
    % Calcular el histograma
    h = imhist(img);
    
    % Calcular el histograma acumulativo normalizado
    acum = cumsum(h) / numel(img);
    
    % Mapear los valores de la imagen original a los del histograma acumulativo
    img_eq = acum(img+1);
    
    % Ajustar el rango de la imagen al rango [0, 255]
    img_eq = uint8(255 * img_eq);
end