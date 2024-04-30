% Leer la imagen
imagen = imread("imagenes\city.jpg");

% Convertir la imagen a escala de grises si es necesario
if size(imagen, 3) == 3
    imagen = rgb2gray(imagen);
end

% Solicitar al usuario que elija el tipo de elemento estructural
disp('Seleccione el tipo de elemento estructural:');
disp('1. 4 vecinos');
disp('2. 8 vecinos');
disp('3. 4 esquinas');

opcion = input('Ingrese el número correspondiente al tipo de elemento estructural: ');

% Definir el elemento estructural según la opción seleccionada por el usuario
switch opcion
    case 1
        elementoEstructural = [
            0, 1, 0;
            1, 1, 1;
            0, 1, 0
        ];
    case 2
        elementoEstructural = ones(3, 3);
    case 3
        elementoEstructural = [
            1, 0, 1;
            0, 1, 0;
            1, 0, 1
        ];
    otherwise
        error('Opción no válida. Por favor, seleccione 1, 2 o 3.');
end

% Llamar a la función para encontrar bordes
bordes = encontrarBordes(imagen, elementoEstructural);

% Mostrar la imagen de los bordes
imshow(bordes);

function bordes = encontrarBordes(imagen, elementoEstructural)

    % Normalizar la imagen para que los valores estén en el rango [0, 1]
    imagen = double(imagen) ./ 255;

    % Aplicar erosión con el elemento estructural especificado
    erosionada = erosion(imagen, elementoEstructural);

    % Inversa de la imagen erosionada
    inversaErosionada = 1 - erosionada;

    % Aplicar operación AND entre la imagen original y la inversa de la imagen erosionada
    bordes = imagen & inversaErosionada;
end

function resultado = erosion(imagen, elementoEstructural)
    % Obtener el tamaño de la imagen
    [filas, columnas] = size(imagen);

    % Obtener el tamaño del elemento estructural
    [tamX, tamY] = size(elementoEstructural);

    % Calcular el offset para centrar el elemento estructural
    offsetX = floor(tamX / 2);
    offsetY = floor(tamY / 2);

    % Inicializar la imagen resultante con unos
    resultado = ones(filas, columnas);

    % Realizar la erosión
    for i = 1 + offsetX : filas - offsetX
        for j = 1 + offsetY : columnas - offsetY
            % Extraer la región de interés de la imagen
            region = imagen(i - offsetX : i + offsetX, j - offsetY : j + offsetY);

            % Aplicar la operación AND entre la región de interés y el elemento estructural
            resultado(i, j) = min(min(region & elementoEstructural));
        end
    end
end
