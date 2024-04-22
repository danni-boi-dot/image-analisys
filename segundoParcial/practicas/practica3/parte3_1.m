% Leer la imagen
img = imread('city.jpg');

% Convertir la imagen a escala de grises si es necesario
if size(img, 3) == 3
    img = rgb2gray(img);
end

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

% Mostrar las probabilidades iniciales
disp('Probabilidades ordenadas:');
disp(nodes(:, 1)');

% Mostrar el histograma inicial
figure;
bar(nodes(:, 2), nodes(:, 1));
title('Histograma de la imagen original');

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
    
    % Mostrar las probabilidades restantes
    disp('Probabilidades restantes:');
    disp(nodes(:, 1)');
    
end

disp('Probabilidades ordenadas guardadas en "probabilidades_ordenadas.txt"');
