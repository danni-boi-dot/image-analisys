% Leer la imagen
img = imread('city.jpg');

% Convertir la imagen a escala de grises si es necesario
if size(img, 3) == 3
    img = rgb2gray(img);
end

% Generar y mostrar el histograma de la imagen original
figure;
histogram(img, 256, 'Normalization', 'probability');
title('Histograma de la imagen original');
xlabel('Niveles de Gris');
ylabel('Probabilidad');

% Aplanar la imagen en un vector
img = img(:);

% Calcular histograma
histograma = histcounts(double(img), 0:256);

% Calcular probabilidades
probabilidades = histograma / numel(img);

% Crear una matriz con los valores de los píxeles y sus probabilidades
nodes = [probabilidades' (0:255)'];

% Ordenar la matriz por probabilidades de mayor a menor
nodes = sortrows(nodes, -1);

% Guardar las probabilidades ordenadas en un archivo txt
fid = fopen('pro.txt', 'w');
for i = 1:256
    fprintf(fid, 'Pixel: %d, Probabilidad: %f\n', nodes(i, 2), nodes(i, 1));
end

% Mostrar las probabilidades iniciales
disp('Probabilidades ordenadas:');
disp(nodes(:, 1)');

% Sumar las dos últimas probabilidades hasta que solo queden dos
while size(nodes, 1) > 2
    % Sumar las dos últimas probabilidades y crear un nuevo nodo
    nueva_probabilidad = sum(nodes(end-1:end, 1));
    
    % Mostrar las probabilidades que se están sumando
    disp(['Sumando probabilidades: ', num2str(nodes(end, 1)), ' y ', num2str(nodes(end-1, 1)), ' (Nueva probabilidad: ', num2str(nueva_probabilidad), ')']);
    
    % Eliminar los dos últimos nodos y agregar el nuevo nodo
    nodes = nodes(1:end-2, :);
    nodes = [nodes; nueva_probabilidad, -1];
    
    % Volver a ordenar la matriz
    nodes = sortrows(nodes, -1);
    
    % Guardar las probabilidades ordenadas en un archivo txt después de cada suma
    fprintf(fid, '\nDespués de sumar, las probabilidades ordenadas son:\n');
    for i = 1:size(nodes, 1)
        fprintf(fid, 'Pixel: %d, Probabilidad: %f\n', nodes(i, 2), nodes(i, 1));
    end
    
    % Mostrar las probabilidades restantes
    disp('Probabilidades restantes:');
    disp(nodes(:, 1)');
end

fclose(fid);

disp('Probabilidades ordenadas guardadas en "pro.txt"');
