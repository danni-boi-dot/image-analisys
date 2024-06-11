% Definir el alfabeto y su mapeo
alfabeto = 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ ';
mapeo = containers.Map({'A','B','C','D','E','F','G','H','I','J','K','L','M','N','Ñ','O','P','Q','R','S','T','U','V','W','X','Y','Z',' '}, 1:28);

% Entrada
entrada = 'Abraham Daniel';

% Convertir la entrada a mayúsculas y mapear a valores
entrada = upper(entrada);
valores = arrayfun(@(x) mapeo(x), entrada);

% Calcular histograma
histograma = histcounts(valores, 1:29);

% Calcular probabilidades
probabilidades = histograma / numel(valores);

% Crear una matriz con los valores de los caracteres y sus probabilidades
nodes = [probabilidades' (1:28)'];

% Ordenar la matriz por probabilidades de mayor a menor
nodes = sortrows(nodes, -1);

% Generar y mostrar el histograma de la entrada
figure;
histogram(valores, 1:29, 'Normalization', 'probability');
xticks(1:28);
xticklabels(alfabeto);
title('Histograma de la entrada');
xlabel('Caracteres');
ylabel('Probabilidad');

% Guardar las probabilidades ordenadas en un archivo txt
fid = fopen('parte3.txt', 'w');
for i = 1:28
    % Calcular el número de bits necesarios para representar el carácter
    bits = ceil(log2(i));
    fprintf(fid, 'Caracter: %s, Probabilidad: %f, Bits: %d\n', alfabeto(nodes(i, 2)), nodes(i, 1), bits);
end

% Mostrar las probabilidades iniciales
disp('Probabilidades ordenadas:');
disp(nodes(:, 1)');

% Calcular el número total de símbolos en la fuente de información
n = numel(valores);

% Calcular el porcentaje de agrupamiento
porcentaje_agrupamiento = (2/n) * (n - 1) * 100;

disp(['Porcentaje de agrupamiento aproximado: ', num2str(porcentaje_agrupamiento), '%']);

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
        % Calcular el número de bits necesarios para representar el carácter
        bits = ceil(log2(nodes(i, 2)));
        fprintf(fid, 'Caracter: %d, Probabilidad: %f, Bits: %d\n', nodes(i, 2), nodes(i, 1), bits);
    end
    
    % Mostrar las probabilidades restantes
    disp('Probabilidades restantes:');
    disp(nodes(:, 1)');
end

fclose(fid);

disp('Probabilidades ordenadas guardadas en ".txt"');

% Calcular la entropía de la fuente de información
entropia = -sum(probabilidades(probabilidades > 0) .* log2(probabilidades(probabilidades > 0)));

% Calcular la longitud media de los códigos de Huffman
longitud_media = sum(probabilidades(probabilidades > 0) .* ceil(log2(1 ./ probabilidades(probabilidades > 0))));

% Calcular la eficiencia del código de Huffman
eficiencia = entropia / longitud_media;

% Convertir la eficiencia a porcentaje
eficiencia_porcentaje = eficiencia * 100;

disp(['Eficiencia del código de Huffman: ', num2str(eficiencia_porcentaje), '%']);
