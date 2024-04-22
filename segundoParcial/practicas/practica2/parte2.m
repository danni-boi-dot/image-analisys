% Cargar la imagen
imagen = imread('casita.jpg');

% Convertir la imagen a escala de grises si es necesario
if size(imagen, 3) == 3
    imagen_gris = rgb2gray(imagen);
else
    imagen_gris = imagen;
end

% Calcular la DCT de la imagen
dct_imagen = dct2(double(imagen_gris)); % Convertir imagen a tipo double para evitar saturación

% Pedir al usuario el número de bits deseado para la compresión
compression_bits = input('Por favor, ingrese el número de bits deseado para la compresión: ');

% Definir la función para calcular la matriz de error cuantificada
quantized_error_matrix = @(image, bits) round(double(image) / (2^(8-bits))) * (2^(8-bits)) - double(image);

% Calcular la matriz de error cuantificada de la DCT de la imagen
error_matrix_original = quantized_error_matrix(dct_imagen, compression_bits);

% Calcular la MEQ de recuperación de la DCT de la imagen utilizando los mismos bits de compresión
recovery_meq = @(error_matrix, bits) round(sum(error_matrix(:)) / (numel(error_matrix) * (2^(8-bits)))) * (2^(8-bits));

% Aplicar la MEQ de recuperación a la matriz de error original
meq_original = recovery_meq(error_matrix_original, compression_bits);

% Calcular la DCT comprimida original
compressed_dct = double(dct_imagen) + error_matrix_original;

% Calcular la matriz de error cuantificada y la MEQ de recuperación de la DCT comprimida
error_matrix_compressed = quantized_error_matrix(compressed_dct, compression_bits);
meq_compressed = recovery_meq(error_matrix_compressed, compression_bits);

% Aplicar la MEQ a la DCT comprimida
recovered_compressed_dct = compressed_dct + meq_compressed;

% Reconstruir la imagen utilizando solo los coeficientes seleccionados
imagen_reconstruida = idct2(recovered_compressed_dct);

% Convertir la imagen reconstruida a uint8
imagen_reconstruida = uint8(imagen_reconstruida);

% Calcular la potencia de la señal en el dominio de la DCT
signal_power_dct = mean(dct_imagen(:).^2);

% Calcular la DCT de la imagen reconstruida
dct_imagen_reconstruida = dct2(double(imagen_reconstruida));

% Calcular la diferencia entre los coeficientes de la DCT original y la DCT reconstruida (ruido)
dct_noise = dct_imagen - dct_imagen_reconstruida;

% Calcular la potencia del ruido en el dominio de la DCT
noise_power_dct = mean(dct_noise(:).^2);

% Calcular la relación señal/ruido (SNR) en el dominio de la DCT
SNR_dct = 10 * log10(signal_power_dct / noise_power_dct);

% Mostrar la imagen original, la imagen DCT y la imagen reconstruida
subplot(1,3,1);
imshow(imagen_gris);
title('Imagen Original');

subplot(1,3,2);
imshow(dct_imagen); % Convertir la DCT de nuevo a uint8 para visualizarla correctamente
title('Imagen DCT');

subplot(1,3,3);
imshow(imagen_reconstruida);
title('Imagen Reconstruida');

% Mostrar la relación señal/ruido (SNR) en el dominio de la DCT
disp(['La relación señal/ruido (SNR) en el dominio de la DCT es: ', num2str(SNR_dct), ' dB']);

% Mostrar la relación señal/ruido (SNR) de la imagen reconstruida en el dominio de los píxeles
signal_power_image_pixels = mean(imagen_gris(:).^2);
noise_power_image_pixels = mean((double(imagen_gris(:)) - double(imagen_reconstruida(:))).^2);
SNR_image_pixels = 10 * log10(signal_power_image_pixels / noise_power_image_pixels);

% Mostrar la relación señal/ruido (SNR) de la imagen reconstruida en el dominio de los píxeles
disp(['La relación señal/ruido (SNR) de la imagen reconstruida en el dominio de los píxeles es: ', num2str(SNR_image_pixels), ' dB']);
