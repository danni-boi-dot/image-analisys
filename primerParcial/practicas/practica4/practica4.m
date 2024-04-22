% Leer la imagen 'objeto.jpg'
a = imread('objeto.jpg');

% Convertir la imagen a escala de grises
a_gray = rgb2gray(a); 

% Determinar el umbral para la binarización usando el método de Otsu
umbral = graythresh(a_gray);

% Convertir la imagen a binaria usando el umbral determinado
i_bin = im2bw(a_gray, umbral);

% Invertir la imagen binaria (los objetos serán blancos y el fondo será negro)
i_bin = ~i_bin;

% Inicializar una matriz del mismo tamaño que la imagen binaria para el etiquetado
etiquetado = zeros(size(i_bin));

% Inicializar la etiqueta
etiqueta = 0;

% Recorrer cada píxel de la imagen binaria
for x=1:size(i_bin, 1)
    for y=1:size(i_bin, 2)
        % Si el píxel es blanco y no ha sido etiquetado
        if i_bin(x,y) == 1
           if etiquetado(x,y)==0
              % Incrementar la etiqueta
              etiqueta = etiqueta + 1;
              
              % Etiquetar la figura en la imagen binaria
              etiquetado = etiquetarFigura(i_bin, etiquetado, x, y, etiqueta);
           end
        end
    end
end

% Mostrar el número de objetos encontrados
disp(['Número de objetos encontrados: ', num2str(etiqueta)]);

% Mostrar la imagen original y la imagen etiquetada
figure(1);
subplot(1,2,1)
imshow(a);
title('Original')
subplot(1,2,2)
imshow(label2rgb(etiquetado));
title('Etiquetado')

% Función para etiquetar una figura en la imagen binaria
function etiquetado = etiquetarFigura(i_bin, etiquetado, x, y, etiqueta)

    % Inicializar la cola con la posición del píxel actual
    cola = [x,y];
    
    % Mientras la cola no esté vacía
    while ~isempty(cola)

        % Tomar el primer píxel de la cola
        pixel = cola(1, :);
        
        % Eliminar el primer píxel de la cola
        cola(1, :) = [];
        
        px = pixel(1);
        py = pixel(2);

        % Si el píxel es blanco y no ha sido etiquetado
        if i_bin(px, py) == 1 && etiquetado(px, py) == 0
            % Etiquetar el píxel
            etiquetado(px, py) = etiqueta;

            % Agregar los vecinos del píxel a la cola
            for nx = max(px-1, 1): min(px+1, size(i_bin, 1))
                for ny = max(py-1, 1): min(py+1, size(i_bin,2))
                    if i_bin(nx, ny) == 1 && etiquetado(nx, ny) == 0
                        cola = [cola; nx ny];
                    end
                end
            end
        end
    end
end
