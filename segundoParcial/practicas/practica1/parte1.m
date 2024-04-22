% Pedir al usuario el número de bits deseado para la compresión
compression_bits = input('Por favor, ingrese el número de bits deseado para la compresión: ');

% Verificar si la entrada del usuario es válida
if compression_bits <= 0
    error('El número de bits para la compresión debe ser mayor que cero.');
end

% Leer la imagen
imagen = imread('casita.jpg');

% Convertir la imagen a escala de grises si es necesario
if size(imagen, 3) == 3
    imagen = rgb2gray(imagen);
end

% Definir la función para calcular la matriz de error cuantificada
quantized_error_matrix = @(image, bits) round(double(image) / (2^(8-bits))) * (2^(8-bits)) - double(image);

% Calcular la matriz de error cuantificada de la imagen original
error_matrix_original = quantized_error_matrix(imagen, compression_bits);

% Calcular la MEQ de recuperación de la imagen original utilizando los mismos bits de compresión
recovery_meq = @(error_matrix, bits) round(sum(error_matrix(:)) / (numel(error_matrix) * (2^(8-bits)))) * (2^(8-bits));

% Aplicar la MEQ de recuperación a la matriz de error original
meq_original = recovery_meq(error_matrix_original, compression_bits);

% Calcular la imagen comprimida original
compressed_image = uint8(double(imagen) + error_matrix_original);

% Calcular la matriz de error cuantificada y la MEQ de recuperación de la imagen comprimida
error_matrix_compressed = quantized_error_matrix(compressed_image, compression_bits);
meq_compressed = recovery_meq(error_matrix_compressed, compression_bits);

% Aplicar la MEQ a la imagen comprimida
recovered_compressed_image = uint8(double(compressed_image) + meq_compressed);

% Calcular la relación señal/ruido (SNR)
signal_power = mean(recovered_compressed_image(:).^2);
noise_power = mean((double(imagen(:)) - double(recovered_compressed_image(:))).^2);
SNR = 10 * log10(signal_power / noise_power);

% Mostrar la imagen original y la imagen comprimida en un subplot
figure;

% Subplot para la imagen original
subplot(1, 2, 1);
imshow(imagen);
title('Imagen original');

% Subplot para la imagen comprimida recuperada mediante MEQ
subplot(1, 2, 2);
imshow(recovered_compressed_image);
title(['Imagen recuperada (', num2str(compression_bits), ' bits)']);

% Mostrar la relación señal/ruido (SNR)
disp(['La relación señal/ruido (SNR) de la imagen recuperada es: ', num2str(SNR), ' dB']);
