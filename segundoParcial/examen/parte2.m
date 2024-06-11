% Definir la imagen
img = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
       0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0; 
       0 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 0 0; 
       0 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 0 0;
       0 1 1 1 1 1 1 1 1 0 0 0 1 1 1 1 0 0; 
       0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0 0; 
       0 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 0 0; 
       0 0 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1 0; 
       0 0 0 1 1 0 0 0 0 0 0 0 0 1 1 1 0 0;
       0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
       0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

% Solicitar al usuario seleccionar la opción de conectividad
opcion = input('Seleccione la opción de conectividad (1 para 8 vecinos, 2 para 4 esquinas): ');

% Crear el elemento estructural según la opción
switch opcion
    case 1
        se = ones(3); % 8 vecinos
    case 2
        se = [1 0 1; 0 1 0; 1 0 1]; % 4 esquinas
    otherwise
        disp('Opción no válida');
        return;
end

% Aplicar la operación de etiquetado
etiquetado = bwlabel(img, 8); % Cambia a 4 si eliges la opción 4 esquinas

% Mostrar las imágenes en un subplot
figure;

% Subplot de la imagen original
subplot(1, 3, 1);
imshow(img, 'InitialMagnification', 'fit');
title('Imagen Original');

% Subplot de la imagen etiquetada con colores específicos
num_etiquetas = max(etiquetado(:)); % Obtener el número total de etiquetas
etiquetas_colores = prism(num_etiquetas); % Generar colores específicos para cada etiqueta
etiquetado_rgb = label2rgb(etiquetado, etiquetas_colores); % Convertir etiquetado a imagen RGB
subplot(1, 3, 2);
imshow(etiquetado_rgb);
title('Imagen Etiquetada con Colores Específicos');

% Aplicar dilatación y erosión
img_dilatada = dilatacion(etiquetado, se);
img_erodida = erosion(etiquetado, se);

% Subplot de la imagen dilatada
subplot(1, 3, 3);
imshow(img_dilatada);
title('Imagen Dilatada');

% Subplot de la imagen erodida
figure;
imshow(img_erodida);
title('Imagen Erodida');
