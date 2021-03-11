clc;
close all;
setPlotParameters;
%%plunging motion t/T=0.5
P_wavelen = -2. * [-0.668089999999999,-0.357440000000000,-0.465740000000000];
P_radius = 1.58*[0.0785261167643576,0.0606046077116198,0.0535262206544916];
P_height = [0.252986398843040,0.235220083846041,0.217711358078854];
P_gamma = [2.01746407911052,2.01891396585299,1.96476713116201];
%%L-vortex
L_radius =   1.58 * [0.05, 0.05, 0.05, 0.05, 0.06, 0.08, 0.05, 0.05];
L_height =   [0.2,  0.2,  0.2,  0.2,  0.2,  0.2,  0.2,  0.2];
L_gamma =    [2.,   2.,   1.,   1.,   1.,   1.,   1.,   1.];
L_wavelen = [0.331729361901420,0.434888632847010,0.280637566586170,0.456339220231820,0.401434006901360,0.516874014752370,0.465652265542680,0.465652265542680];
%%model 3
I_wavelen = 2. * [0.198738742000000,0.216020371999999,0.299548250000000,0.449334126000000,0.500238860000000];
I_radius =   1.58 * [0.05, 0.05, 0.08, 0.05,0.05];
I_height =   [0.2,  0.2,  0.2,  0.4, 0.2];
I_gamma =    [1.,   1.,   1.,   1., 1.];
%% plot
figure;
plot(P_radius./P_height, P_wavelen./P_height, 'ob')
hold on;
index1 = [1:1:6]
plot(L_radius(index1)./L_height(index1), L_wavelen(index1)./L_height(index1), '^r')
index1 = [7 8]'
plot(L_radius(index1)./L_height(index1), L_wavelen(index1)./L_height(index1), '*b')
plot(I_radius./I_height, I_wavelen./I_height, '+k')
xlabel('a/h (a=r=1.58\sigma)')
ylabel('\lambda/h')
axis([0 1.2 0 7])
legend('plunging at t/T=0.5', 'model 1, t\Gamma h^-^2=10', 'model 2, t\Gamma h^-^2=10', 'model 3, t\Gamma h^-^2=10', 'Location', 'Best')
%%
figure;
plot(P_radius./P_height, P_wavelen./P_radius, 'ob')
hold on;
index1 = [1:1:6]
plot(L_radius(index1)./L_height(index1), L_wavelen(index1)./L_radius(index1), '^r')
index1 = [7 8]'
plot(L_radius(index1)./L_height(index1), L_wavelen(index1)./L_radius(index1), '*b')
plot(I_radius./I_height, I_wavelen./I_radius, '+k')
xlabel('a/h (a=r=1.58\sigma)')
ylabel('\lambda/a')
legend('plunging at t/T=0.5', 'model 1, t\Gamma h^-^2=10', 'model 2, t\Gamma h^-^2=10', 'model 3, t\Gamma h^-^2=10', 'Location', 'Best')
axis([0 1.2 0 14])