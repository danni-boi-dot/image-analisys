% Leer la imagen
imagen = imread('peppers.png');

% Obtener las dimensiones de la imagen
[filas, columnas, ~] = size(imagen);

% Crear una copia de la imagen
img = imagen;
parteVertical = round(columnas / 2);
parteHorizontal = round(parteVertical / 2);

% --------------------DIVISIÓN VERTICAL--------------------%
% Crear imágenes para cada mitad
mitad1 = img(:, 1:parteVertical, :);
mitad2 = img(:, (parteVertical+1):columnas, :);

% Separar la mitad 1 en rojo y verde
rojo_mitad1 = mitad1;
rojo_mitad1(:, :, 2:3) = 0;

verde_mitad1 = mitad1;
verde_mitad1(:, :, [1,3]) = 0;

% Separar la mitad 2 en rojo y verde
rojo_mitad2 = mitad2;
rojo_mitad2(:, :, 2:3) = 0;

verde_mitad2 = mitad2;
verde_mitad2(:, :, [1,3]) = 0;

% Concatenar las imágenes de rojo y verde
division_vertical_rojo_verde = cat(2, rojo_mitad1, verde_mitad2);

%------------------- DIVISIÓN HORIZONTAL ------------------%
% Crear imágenes para cada tercio
rojo_horizontal = img(1:parteHorizontal, :, :);       
verde_horizontal = img((parteHorizontal+1):(2*parteHorizontal), :, :);  
azul_horizontal = img((2*parteHorizontal+1):filas, :, :);       

% Establecer cero en los canales que no corresponden
rojo_horizontal(:, :, 2:3) = 0;   
verde_horizontal(:, :, [1,3]) = 0; 
azul_horizontal(:, :, 1:2) = 0;    

% Concatenar las imágenes a lo largo del eje vertical
division_horizontal = cat(1, rojo_horizontal, verde_horizontal, azul_horizontal);

% Muestra la imagen original y las imágenes divididas en una sola ventana
figure;

% Muestra las divisiones verticales y horizontales
imshow(division_vertical_rojo_verde);
title('División Vertical Rojo y Verde');


disp('Fin del proceso...')
