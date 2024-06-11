function contorno()

img = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
       0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
       0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0;
       0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0;
       0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0;
       0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0;
       0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0;
       0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0;
       0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0;
       0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;];

    disp(img);
    disp(size(img));

    % Preguntar al usuario qué opción quiere
    disp('Elija una opción:');
    disp('1. 4 vecinos');
    disp('2. 8 vecinos');
    disp('3. 4 esquinas');
    disp('4. Octagono');
    opcion = input('Opcion: ');
    
    switch opcion
        case 1
            se = [0, 0, 0, 0, 0;
                  0, 0, 1, 0, 0;
                  0, 1, 1, 1, 0;
                  0, 0, 1, 0, 0;
                  0, 0, 0, 0, 0;];
        case 2
            se = [0, 0, 0, 0, 0;
                  0, 1, 1, 1, 0;
                  0, 1, 1, 1, 0;
                  0, 1, 1, 1, 0;
                  0, 0, 0, 0, 0;];
        case 3
            se = [0, 1, 1, 1, 0;
                  1, 1, 1, 1, 1;
                  1, 1, 1, 1, 1;
                  1, 1, 1, 1, 1;
                  0, 1, 1, 1, 0;];
        case 4
            radius = 1; % Radio del octágono
            se = strel('disk', radius).Neighborhood; % Elemento estructural octagonal
        otherwise
            disp('Opción no válida');
            return;
    end
    
    % Aplicar la operación de dilatación y erosión
    img_dilatada = dilatacion(img, se);
    img_erosionada = erosion(img, se);
    
    % Obtener los bordes
    bordes = img_dilatada & ~img_erosionada;
    bordes = ~bordes;
    
    % Calcular la inversa de la versión erosionada
    img_ero_inversa = ~img_erosionada;
    
    % Realizar la operación lógica AND entre la imagen original y la inversa de la versión erosionada
    img_and = img & img_ero_inversa;
    
    % Mostrar la imagen original, los bordes y la operación AND en subplots separados
    subplot(1, 3, 1);
    imshow(img);
    title('Original');
    
    subplot(1, 2, 2);
    imshow(bordes);
    title('Bordes');
    
    subplot(1, 2, 3);
    imshow(img_and);
    title('Original & Inversa');
end


function img_dilatada = dilatacion(img, se)
    if isa(se, 'strel')
        img_dilatada = imdilate(img, se);
    else
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
end

function img_erosionada = erosion(img, se)
    if isa(se, 'strel')
        img_erosionada = imerode(img, se);
    else
        img_erosionada = img;
        [h, w] = size(img);
        [m, n] = size(se);
        for i = 1:h
            for j = 1:w
                if img(i, j) == 1
                    erosion_val = true;
                    for k = 1:m
                        for l = 1:n
                            if se(k, l) == 1
                                x = i + k - ceil(m/2);
                                y = j + l - ceil(n/2);
                                if x > 0 && x <= h && y > 0 && y <= w
                                    if img(x, y) == 0
                                        erosion_val = false;
                                    end
                                else
                                    erosion_val = false;
                                end
                            end
                        end
                    end
                    if ~erosion_val
                        img_erosionada(i, j) = 0;
                    end
                end
            end
        end
    end
end
