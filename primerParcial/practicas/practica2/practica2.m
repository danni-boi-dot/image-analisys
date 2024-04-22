% Carga la imagen 'peppers.png'
a = imread('city.jpg');

% Extracción de canales RGB
R = a(:,:,1);
G = a(:,:,2);
B = a(:,:,3);

% Cálculo de mínimo y máximo por canal
minimo_R = min(min(R));
maximo_R = max(max(R));
minimo_G = min(min(G));
maximo_G = max(max(G));
minimo_B = min(min(B));
maximo_B = max(max(B));

% Bucle para repetir el proceso
while true
    % Pedir intervalo
    intervalo_min = input('Dame el valor min del intervalo...= ');
    intervalo_max = input('Dame el valor max del intervalo...= ');

    % Cálculo de factor de escala
    dato1 = (intervalo_max - intervalo_min);
    dato2 = (maximo_R-minimo_R);
    dato3 = (double(dato1) / double(dato2));

    % Procesamiento de cada canal
    % procesada_R: Canal rojo procesado
    % procesada_G: Canal verde procesado
    % procesada_B: Canal azul procesado
    for i=1:size(R,1)
        for j=1:size(R,2)
            procesada_R(i,j) = dato3 * (R(i,j) - minimo_R) + intervalo_min;
            procesada_G(i,j) = dato3 * (G(i,j) - minimo_G) + intervalo_min;
            procesada_B(i,j) = dato3 * (B(i,j) - minimo_B) + intervalo_min;
        end
    end

    % Conversión a uint8 y recombinación de canales
    % procesada: Imagen RGB procesada
    procesada_R = uint8(procesada_R);
    procesada_G = uint8(procesada_G);
    procesada_B = uint8(procesada_B);
    procesada(:,:,1) = procesada_R;
    procesada(:,:,2) = procesada_G;
    procesada(:,:,3) = procesada_B;

    % Visualización de histogramas e imágenes
    figure(1)

    % Histograma Rojo Original
    subplot(2,4,1)
    histogram(R)
    title('Histograma Rojo Original')

    % Imagen Original
    subplot(2,4,4)
    imshow(a)
    title('Imagen Original')

    % Histograma Rojo Procesado
    subplot(2,4,5)
    histogram(procesada_R)
    title('Histograma Rojo Procesado')

    % Histograma Verde Original
    subplot(2,4,2)
    histogram(G)
    title('Histograma Verde Original')

    % Histograma Verde Procesado
    subplot(2,4,6)
    histogram(procesada_G)
    title('Histograma Verde Procesado')

    % Histograma Azul Original
    subplot(2,4,3)
    histogram(B)
    title('Histograma Azul Original')

    % Histograma Azul Procesado
    subplot(2,4,7)
    histogram(procesada_B)
    title('Histograma Azul Procesado')

    % Imagen Procesada
    subplot(2,4,8)
    imshow(procesada)
    title('Imagen Procesada')

    % Preguntar si desea continuar procesando la imagen
    pregunta = input('¿Desea continuar procesando la imagen? (s/n): ', 's');
    if strcmp(pregunta, 'n')
        break;
    end
end
