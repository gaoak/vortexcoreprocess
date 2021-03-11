
%%
% clear;
clc;
close all;
setPlotParameters;
%%
fileformat={'Re400_k2_Ap5/R1_vcore%d.dat', 'Re1000_k2_Ap5/R1_vcore%d.dat',...
    'Re10k_k2_Ap5/R1_vcore%d.dat'};
nfile=[109 122; 36, 49; 36 49];
nvar = 10;
skip=1;
aoa = 15/180.*pi;
tT = 0.25 + [0:1:13]'*0.0625;
clear endpoint wavel radius gamma;
mode = 4;
% figure;
for nn=3:1:1
    if mode>0
        figure;
    end
    ns=nfile(nn,1);
    ne=nfile(nn,2);
    thresh = 1.;
    zmin = 2.5;
    for ii=ne:-1:ns
        filename = sprintf(fileformat{nn}, ii);
        file = loaddata(filename, skip, nvar);
        [la, secamp, zmin, file] = cleanvortexcore(file, aoa, 5., zmin,thresh);
        zmin
        thresh = 0.8 * secamp;
        [r, g, l, ph,x,h,loc] = processvortexcore(file, aoa, mode);
%         title(num2str(ne))
        gamma(ii-ns+1, nn) = g;
        radius(ii-ns+1, nn) = r;
        wavel(ii-ns+1, nn) = la;
        streamx(ii-ns+1, nn) = x;
        height(ii-ns+1, nn) = h - naca0012(x);
        vortexheight(ii-ns+1, nn) = ph - naca0012(x);
        endpoint(ii-ns+1, 1, nn) = loc(1);
        endpoint(ii-ns+1, 2, nn) = loc(2);
    end
end
%%
symbol = {'og-', 'sb--', 'vk-.'};
exploc=[0.078137458	0.267899856
0.110030298	0.373146229
0.153085632	0.475203317
0.186573114	0.629883591
0.121192792	0.849944188
0.12757136	1.047679796
0.27108914	1.156115452
0.416201563	1.215117206
0.524637219	1.25019933
0.591612183	1.293254664
0.717588901	1.349067134
1.012597672	1.360229628];
figure;
plot(endpoint(:,1,1), endpoint(:,2,1), 'og')
hold on;
plot(endpoint(:,1,2), endpoint(:,2,2), 's--b')
plot(endpoint(:,1,3), endpoint(:,2,3), 'v-.k')
plot(5-exploc(:,2),exploc(:,1), '^k-.')
hold off
axis([3.5 5 0 0.8])
set(gca, 'XDir', 'reverse');
set(gca, 'YDir', 'reverse');
xlabel('z/c')
ylabel('x/c')
legend('Re 400', 'Re 1000', 'Re 10k', 'exp Re10k', 'Location', 'Best')
%% vortex streamwise location
figure;
plot(tT, streamx(:,1), 'o-g')
hold on;
plot(tT, streamx(:,2), 's--b')
plot(tT, streamx(:,3), 'v-.k')
hold off
axis([0 1.25 0 0.8])
ylabel('x/c')
xlabel('t/T')
legend('Re 400', 'Re 1000', 'Re 10k', 'Location', 'Best')
%% vortex height
figure;
plot(tT, height(:,1), 'o-g')
hold on;
plot(tT, height(:,2), 's--b')
plot(tT, height(:,3), 'v-.k')
hold off
axis([0 1.25 0 0.5])
ylabel('h/c')
xlabel('t/T')
legend('Re 400', 'Re 1000', 'Re 10k', 'Location', 'Best')
%%
figure;
plot(tT, gamma(:,1), 'o-g')
hold on;
plot(tT, gamma(:,2), 's--b')
plot(tT, gamma(:,3), 'v-.k')
hold off
axis([0 1.25 0 2.5])
ylabel('\Gamma/Uc')
xlabel('t/T')
legend('Re 400', 'Re 1000', 'Re 10k', 'Location', 'Best')
%%
figure;
plot(tT, 1.58 * radius(:,1), 'o-g')
hold on;
plot(tT, 1.58 * radius(:,2), 's--b')
plot(tT, 1.58 * radius(:,3), 'v-.k')
hold off
xlabel('t/T')
ylabel('r/c')
axis([0 1.25 0 0.15])
legend('Re 400', 'Re 1000', 'Re 10k', 'Location', 'Best')
%%  wavelength
figure
for ii=1:1:3
    plot(tT, -2. * wavel(:,ii), symbol{ii})
    hold on;
end
axis([0 1.25 0 2])
legend('Re 400', 'Re 1000', 'Re 10k', 'Location', 'Best')
xlabel('t/T')
ylabel('\lambda/c')
title('wavelength')
%% vortex height
figure
for ii=1:1:3
    plot(tT, vortexheight(:,ii)./height(:,ii), symbol{ii})
    hold on;
end
axis([0 1.25 0.8 1.8])
legend('Re 400', 'Re 1000', 'Re 10k', 'Location', 'Best')
xlabel('t/T')
ylabel('\Lambda/h')
title('crest height')