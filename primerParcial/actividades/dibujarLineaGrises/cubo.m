clc;
clear all;
close all;
warning off all;

% GRAFICANDO LOS DIFERENTES MODELOS DEL CUBO
figure(1)

plot3(1, 0, 0, 'ro','MarkerSize',20,'MarkerFaceColor','r')
hold on
grid on
plot3(0, 1, 0, 'go','MarkerSize',20,'MarkerFaceColor','g')
plot3(0, 0, 1, 'bo','MarkerSize',20,'MarkerFaceColor','b')
plot3(0, 0, 0, 'ko','MarkerSize',20,'MarkerFaceColor','k')
plot3(1, 1, 1, 'wo','MarkerSize',20,'MarkerFaceColor','w')
plot3(0, 1, 1, 'co','MarkerSize',20,'MarkerFaceColor','c')
plot3(1, 0, 1, 'mo','MarkerSize',20,'MarkerFaceColor','m')
plot3(1, 1, 0, 'yo','MarkerSize',20,'MarkerFaceColor','y')
plot3(50:200, 50:200, 50:200, 'k--','LineWidth',2)

legend('red','green','blue','black','white','cyan','magenta','yellow','gray')

figure(2)
plot3(50:200, 50:200, 50:200, 'k--','LineWidth',2)

legend('gray')


disp("fin del proceso")
