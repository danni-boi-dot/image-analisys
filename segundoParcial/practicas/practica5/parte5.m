function contorno()
    % Leer la imagen
    imgc = imread('imagenes/contorno.png');
    
    % Convertir a binario si no lo es
    if numel(size(imgc))>2
        img = rgb2gray(imgc);
    end
    img = imbinarize(img);
    
    % Preguntar al usuario qué opción quiere
    disp('Elija una opción:');
    disp('1. 4 vecinos');
    disp('2. 8 vecinos');
    disp('3. 4 esquinas');
    opcion = input('Introduzca el número de opción: ');
    
    % Crear el elemento estructural según la opción
    switch opcion
        case 1
            se = [0 1 0; 1 1 1; 0 1 0]; % 4 vecinos
        case 2
            se = ones(3); % 8 vecinos
        case 3
            se = [1 0 1; 0 1 0; 1 0 1]; % 4 esquinas
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
    
    % Mostrar la imagen original y los bordes
    subplot(1, 2, 1);
    imshow(imgc);
    title('Imagen original');
    
    subplot(1, 2, 2);
    imshow(bordes);
    title('Bordes');
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
