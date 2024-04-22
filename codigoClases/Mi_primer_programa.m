clc % limpia pantalla
clear all % limpia todo
close all % cierra todo

% LEYENDO Y DESPLEGANDO UNA IMAGEN
a=imread('peppers.png'); % imread lee una imagen
imshow(a)
[m,n]=size(a)

% extrayendo las componentes de color de cada imagen
roja=a;
roja(:,:,1)
roja(:,:,2)=0;
roja(:,:,3)=0;
subplot(3,3,1)
imshow(roja)
title('rojo')

verde=a;
verde(:,:,1)=0;
verde(:,:,2);
verde(:,:,3)=0;
subplot(3,3,2)
imshow(verde)
title('verde')

azul=a;
azul(:,:,1)=0;
azul(:,:,2)=0;
azul(:,:,3);
subplot(3,3,3)
imshow(azul)
title('azul')

grises=rgb2gray(a);
subplot(3,3,5)
imshow(grises)
title('grises')

roja_g=roja(:,:,1);
subplot(3,3,7)
imshow(roja_g)
title('comp_gris_roja')

verde_g=verde(:,:,2);
subplot(3,3,8)
imshow(verde_g)
title('comp_gris_verde')

azul_g=azul(:,:,3);
subplot(3,3,9)
imshow(azul_g)
title('comp_gris_azul')

figure(2)
binaria=im2bw(a)
imshow(binaria)

figure(3)

arreglo=[verde,roja; azul,a];
imshow(arreglo)
    










disp(' fin de proceso...')