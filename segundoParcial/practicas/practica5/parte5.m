function contorno()
    % Leer la imagen
    imgc = imread('imagenes/gatito.jpg');
    
    % Convertir a binario si no lo es
    if numel(size(imgc)) > 2
        img = rgb2gray(imgc);
    end
    img = imbinarize(img);
    
    % Preguntar al usuario qué opción quiere
    disp('Elija una opción:');
    disp('1. 4 vecinos');
    disp('2. 8 vecinos');
    disp('3. 4 esquinas');
    disp('4. Círculo');
    disp('5. Cuadrado');
    disp('6. Octágono');
    opcion = input('Introduzca el número de opción: ');
    
    % Crear el elemento estructural según la opción
    switch opcion
        case 1
            se = [0 1 0; 1 1 1; 0 1 0]; % 4 vecinos
        case 2
            se = ones(3); % 8 vecinos
        case 3
            se = [1 0 1; 0 1 0; 1 0 1]; % 4 esquinas
        case 4
            radius = 1; % Radio del círculo
            se = strel('disk', radius).Neighborhood; % Elemento estructural circular
        case 5
            width = 3; % Tamaño del lado del cuadrado
            se = strel('square', width).Neighborhood; % Elemento estructural cuadrado
        case 6
            radius = 3; % Radio del octágono
            se = strel('octagon', radius).Neighborhood; % Elemento estructural octagonal
        otherwise
            disp('Opción no válida');
            return;
    end
    
    % Aplicar la operación de dilatación y erosión
    img_dilatada = dilatacion(img, se);
    img_erodida = erosion(img, se);
    
    % Obtener los bordes
    bordes = img_dilatada & ~img_erodida;
    bordes = ~bordes;
    
    % Calcular la inversa de la versión erosionada
    img_ero_inversa = ~img_erodida;
    
    % Realizar la operación lógica AND entre la imagen original y la inversa de la versión erosionada
    img_and = img & img_ero_inversa;
    
    % Mostrar la imagen original, los bordes y la operación AND en subplots separados
    subplot(1, 3, 1);
    imshow(imgc);
    title('Imagen original');
    
    subplot(1, 3, 2);
    imshow(bordes);
    title('Bordes');
    
    subplot(1, 3, 3);
    imshow(img_and);
    title('img original & img inversa');
end

function img_dilatada = dilatacion(img, se)
    img_dilatada = img;
    [h, w] = size(img);
    [m, n] = size(se);
    for i = 1:h
        for j = 1:w
            if img(i, j) == 1
                for k = 1:m
                    for l = 1:n
                        if se(k, l) == 1
                            x = i + k - ceil(m/2);
                            y = j + l - ceil(n/2);
                            if x > 0 && x <= h && y > 0 && y <= w
                                img_dilatada(x, y) = 1;
                            end
                        end
                    end
                end
            end
        end
    end
end

function img_erodida = erosion(img, se)
    img_erodida = img;
    [h, w] = size(img);
    [m, n] = size(se);
    for i = 1:h
        for j = 1:w
            if img(i, j) == 1
                for k = 1:m
                    for l = 1:n
                        if se(k, l) == 1
                            x = i + k - ceil(m/2);
                            y = j + l - ceil(n/2);
                            if x > 0 && x <= h && y > 0 && y <= w
                                if img(x, y) == 0
                                    img_erodida(i, j) = 0;
                                end
                            else
                                img_erodida(i, j) = 0;
                            end
                        end
                    end
                end
            end
        end
    end
end
