%%data in wind frame x, y
%%body frame x', y'
clear;
clc;
close all;
setPlotParameters;
savepng=1
%%
fileformat={...
    'Re400_k2_Ap5/R1_vcore%d.dat','Re1000_k2_Ap5/R1_vcore%d.dat','Re10k_k2_Ap5/R1_vcore%d.dat', ...
    'Re400_k2_Ap1/R1_vcore%d.dat','Re1000_k2_Ap1/R1_vcore%d.dat','Re10k_k2_Ap1/R1_vcore%d.dat'...
    'Re400_k3_Ap1/R1_vcore%d.dat','Re1000_k3_Ap1/R1_vcore%d.dat','Re10k_k3_Ap1/R1_vcore%d.dat'};
ncases = length(fileformat);
nfile=[109 122; 36, 49; 36 49;
        40  50; 39, 50;  5 29;
        40  50; 40  49; 22 34];
thresratio = [0.5, 0.5, 0.8, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5];
limitzmin = [5., 5., 5., 4., 5., 5., 5., 5., 5.];
filenstart = [105, 32, 32, 32, 32, 0, 32, 32, 16];
reducefreq = [2, 2, 2, 2, 2, 2, 3, 3, 3];
deltaT = 0.0625;
nvar = 10;
skip=1;
aoa = 15/180.*pi;
clear endpoint wavel radius gamma;
mode = 0;
% figure;
for nn=1:1:9
%     if mode>0
%         figure;
%     end
    ns=nfile(nn,1);
    ne=nfile(nn,2);
    thresh = 1.;
    zmin = 2.5;
    clear tmpvortexheight tmpwavel tmpend tmpgamma tmpradius tmpstreamx tmpheight
    for ii=ne:-1:ns
        filename = sprintf(fileformat{nn}, ii);
        file = loaddata(filename, skip, nvar);
        [la, secamp, zmin, loc, file] = cleanvortexcore(file, aoa, 5., zmin,thresh, mode);
        zmin = min(zmin, limitzmin(nn));
        thresh = thresratio(nn) * secamp;
        tmpwavel(ii-ns+1) = la;
        tmpend(ii-ns+1, 1) = loc(1);
        tmpend(ii-ns+1, 2) = loc(2);
        [r, g, ph, x, h] = processvortexcore(file, aoa, mode);
        tmpgamma(ii-ns+1) = g;
        tmpradius(ii-ns+1) = r;
        tmpstreamx(ii-ns+1) = x;
        tmpheight(ii-ns+1) = h - 0*naca0012(x);
        tmpvortexheight(ii-ns+1) = ph - 0*naca0012(x);
    end
    tT = ([ns:1:ne]'-filenstart(nn))*deltaT*pi/reducefreq(nn);
    time{nn} = tT;
    endpoint{nn} = tmpend;
    gamma{nn} = tmpgamma';
    radius{nn} = tmpradius';
    wavel{nn} = tmpwavel';
    streamx{nn} = tmpstreamx';
    height{nn} = tmpheight';
    vortexheight{nn} = tmpvortexheight';
end
%%
symbol = {'og-', 'sb-', 'vk-',  'og--', 'sb--', 'vk--', 'og-.', 'sb-.', 'vk-.'};
legendlabel = {'Re 400, k 2, A/c 0.5', '1000, 2, 0.5', '10k, 2, 0.5',...
               '400, 2, 0.1', '1000, 2, 0.1', '10k, 2, 0.1',...
               '400, 3, 0.1', '1000, 3, 0.1', '10k, 3, 0.1'};
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
for ii=1:1:ncases
    plot(0,0, symbol{ii})
    hold on;
end
plot(0,0, '^k-')
legend({legendlabel{:} '10k, 0.5, exp'}, 'Location', 'SouthWest')
if savepng>0
    saveas(gcf, 'plunging/legend.png')
end
figure;
for ii=1:1:ncases
    plot(endpoint{ii}(:,1), endpoint{ii}(:,2), symbol{ii})
    hold on;
end
plot(5-exploc(:,2),exploc(:,1), '^k-')
hold off
% axis([3.5 5.5 0 0.8])
set(gca, 'XDir', 'reverse');
set(gca, 'YDir', 'reverse');
xlabel('z/c')
ylabel('x/c')
% legend({legendlabel{:} '10k, 0.5, exp'}, 'Location', 'SouthWest')
title('LEV leg')
if savepng>0
    saveas(gcf, 'plunging/vortexleg.png')
end
%% vortex trajectory
chord=[0:0.01:1];
airfoil=naca0012(chord);
figure
for ii=1:1:ncases
    plot(streamx{ii}, height{ii}, symbol{ii})
    hold on;
end
axis([0 1.5 -0.3 0.3])
% legend(legendlabel, 'Location', 'Best')
plot(cos(aoa)*chord+sin(aoa)*airfoil, -sin(aoa)*chord+cos(aoa)*airfoil, 'k-')
plot(cos(aoa)*chord-sin(aoa)*airfoil, -sin(aoa)*chord-cos(aoa)*airfoil, 'k-')
xlabel('x/c')
ylabel('h/c')
title('vortex trajectory')
if savepng>0
    saveas(gcf, 'plunging/trajectory.png')
end
%% vortex streamwise location body frame
figure;
for ii=1:1:ncases
    plot(time{ii}, cos(aoa)*streamx{ii} - sin(aoa)*height{ii}, symbol{ii})
    hold on;
end
axis([0 2 0 1])
ylabel("x'/c")
xlabel('tU/c')
% legend(legendlabel, 'Location', 'SouthEast')
title('x location body frame')
if savepng>0
    saveas(gcf, 'plunging/bodyxlocation.png')
end
%% vortex streamwise location
figure
for ii=1:1:ncases
    plot(time{ii}, streamx{ii}, symbol{ii})
    hold on;
end
axis([0 2 0 1])
% legend(legendlabel, 'Location', 'Best')
xlabel('tU/c')
ylabel('x/c')
title('x location')
if savepng>0
    saveas(gcf, 'plunging/windxlocation.png')
end
%% vortex y location
figure;
for ii=1:1:ncases
    plot(time{ii}, height{ii}, symbol{ii})
    hold on;
end
hold off
axis([0 2 -0.1 0.3])
ylabel('y/c')
xlabel('tU/c')
% legend(legendlabel, 'Location', 'NorthWest')
title('y location')
if savepng>0
    saveas(gcf, 'plunging/windylocation.png')
end
%% vortex y location in body frame
figure
for ii=1:1:ncases
    plot(time{ii}, sin(aoa)*streamx{ii} + cos(aoa)*height{ii}, symbol{ii})
    hold on;
end
axis([0 2 0 0.4])
% legend(legendlabel, 'Location', 'Best')
xlabel('tU/c')
ylabel("y'/c")
title('y location body frame')
if savepng>0
    saveas(gcf, 'plunging/bodyylocation.png')
end
%% circulation
figure;
for ii=1:1:ncases
    plot(time{ii}, gamma{ii}, symbol{ii})
    hold on;
end
hold off
axis([0 2 0 2.5])
ylabel('\Gamma/Uc')
xlabel('tU/c')
title('circulation')
% legend(legendlabel, 'Location', 'Best')
if savepng>0
    saveas(gcf, 'plunging/circulation.png')
end
%% radius
figure;
for ii=1:1:ncases
    plot(time{ii}, 1.58 * radius{ii}, symbol{ii})
    hold on;
end
hold off
xlabel('tU/c')
ylabel('r/c')
title('radius')
axis([0 2 0 0.18])
% legend(legendlabel, 'Location', 'Best')
if savepng>0
    saveas(gcf, 'plunging/radius.png')
end
%%  wavelength
figure
for ii=1:1:ncases
    plot(time{ii}, wavel{ii}, symbol{ii})
    hold on;
end
axis([0 2 0 2])
% legend(legendlabel, 'Location', 'NorthWest')
xlabel('tU/c')
ylabel('\lambda/c')
title('wavelength')
if savepng>0
    saveas(gcf, 'plunging/wavelength.png')
end
%% vortex height
figure
for ii=1:1:ncases
    plot(time{ii}, vortexheight{ii}, symbol{ii})
    hold on;
end
axis([0 2 0 0.5])
% legend(legendlabel, 'Location', 'Best')
xlabel('tU/c')
ylabel('y/c')
title('peak y location')
if savepng>0
    saveas(gcf, 'plunging/waveheight.png')
end