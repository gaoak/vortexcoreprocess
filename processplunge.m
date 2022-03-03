%%data in wind frame x, y
%%body frame x', y'
% clear;
clc;
close all;
setPlotParameters;
savepng=1;
%%
fileformat={...
    'Re400_k2_Ap5/R1_vcore%d.dat','Re1000_k2_Ap5/R1_vcore%d.dat','Re10k_k2_Ap5/R1_vcore%d.dat', ...
    'Re400_k2_Ap1/R1_vcore%d.dat','Re1000_k2_Ap1/R1_vcore%d.dat','Re10k_k2_Ap1/R1_vcore%d.dat', ...
    'Re400_k3_Ap1/R1_vcore%d.dat','Re1000_k3_Ap1/R1_vcore%d.dat','Re10k_k3_Ap1/R1_vcore%d.dat', ...
    'Re10k_k2_Ap5_exp/R1_vcore%d.dat','Re10k_k2_Ap5_start/R1_vcore%d.dat'};
ncases = length(fileformat);
nfile=[109 122; 36, 49; 36 49;
        40  50; 39, 50;  5 18;
        40  50; 40  49; 22 34;
         2   9;  4   18;];

thresratio = [0.5, 0.5, 0.8, 0.5, 0.5, 0.5, 0.5, 0.5, 0.9, 0.5, 0.4];
limitzmin = [5., 5., 5., 4., 4., 5., 5., 5., 2.5, 5., 5.];
filenstart = [105, 32, 32, 32, 32, 0, 32, 32, 16, 0, 0];
reducefreq = [2, 2, 2, 2, 2, 2, 3, 3, 3, 2, 2];
deltaT = [0.0625 0.0625 0.0625   0.0625 0.0625 0.0625   0.0625 0.0625 0.0625  0.125 0.0625];
nvar = 10;
skip=1;
aoa = 15/180.*pi;
clear endpoint wavel radius gamma time;
mode = 4;
% figure;
for nn=[1 2 3]
%     if mode>0
%         figure;
%     end
    ns=nfile(nn,1);
    ne=nfile(nn,2);
    thresh = 1.;
    zmin = 2.5;
    clear tmpvortexheight tmpwavel tmpend tmpgamma tmpradius tmpstreamx tmpheight tT
    for ii=ne:-1:ns
        filename = sprintf(fileformat{nn}, ii);
        file = loaddata(filename, skip, nvar);
        % var = 0, use x-z for wavelength
        % var = 1, use y-z for vortex leg
        var = 0
        [la, ph, secamp, zmin, loc, file] = cleanvortexcore(file, aoa, 5., zmin,thresh, var, mode);
        zmin = min(zmin, limitzmin(nn));
        thresh = thresratio(nn) * secamp;
        tmpwavel(ii-ns+1) = la;
        tmpend(ii-ns+1, 1) = loc(1);
        tmpend(ii-ns+1, 2) = loc(2);
        tmpend(ii-ns+1, 3) = loc(3);
        tmpvortexheight(ii-ns+1) = ph;
        [r, g, x, h, ca] = processvortexcore(file, aoa, mode);
        tmpgamma(ii-ns+1) = g;
        tmpradius(ii-ns+1) = 1.58 * r;
        tmpstreamx(ii-ns+1) = x;
        tmpheight(ii-ns+1) = h;
    end
    tT = ([ns:1:ne]'-filenstart(nn))*deltaT(nn)*pi/reducefreq(nn);
    time{nn} = tT;
    endpoint{nn} = tmpend;
    gamma{nn} = tmpgamma';
    radius{nn} = tmpradius';
    wavel{nn} = tmpwavel';
    streamx{nn} = tmpstreamx';
    height{nn} = tmpheight';
    vortexheight{nn} = tmpvortexheight';
end
%% show data
ii = nn;
exportdata = [time{ii} cos(aoa)*streamx{ii} - sin(aoa)*height{ii} sin(aoa)*streamx{ii} + cos(aoa)*height{ii} ...
    cos(aoa)*endpoint{ii}(:,1) - sin(aoa)*endpoint{ii}(:,2) endpoint{ii}(:,3)...
    gamma{ii} radius{ii}]
exportdatawavel = [cos(aoa)*streamx{ii} - sin(aoa)*height{ii} wavel{ii}]
vortexlegdata = [cos(aoa)*endpoint{ii}(:,1) - sin(aoa)*endpoint{ii}(:,2) 5-endpoint{ii}(:,3)]
%%
plotsequence = [1,2,3, 5,6, 8,9, 10,11];
symbol = {'og-', 'sb-', 'vk-',  'og--', 'sb--', 'vk--', 'og-.', 'sb-.', 'vk-.', '^r-', '+k-'};
legendlabel = {'Re 400, k 2, A/c 0.5', '1000, 2, 0.5', '10k, 2, 0.5',...
               '400, 2, 0.1', '1000, 2, 0.1', '10k, 2, 0.1',...
               '400, 3, 0.1', '1000, 3, 0.1', '10k, 3, 0.1',...
               '10k, 2, 0.5 exp', '10k, 2, 0.5, start'};
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
plot(0, 0, '^k-')
legend({legendlabel{:} '10k, 2, 0.5, exp'}, 'Location', 'SouthWest')
if savepng>0
    saveas(gcf, 'plunging/legend.png')
end
figure;
for ii=3
    xprime = cos(aoa)*endpoint{ii}(:,1) - sin(aoa)*endpoint{ii}(:,2);
    zprime = endpoint{ii}(:,3);
    plot(zprime, xprime, symbol{ii})
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
%% airfoil
chord=[0:0.001:1];
aoa=15/180.*pi;
airfoil=naca0012(chord);
figure
plot(cos(aoa)*chord+sin(aoa)*airfoil, -sin(aoa)*chord+cos(aoa)*airfoil, 'k-')
hold on;
plot(cos(aoa)*chord-sin(aoa)*airfoil, -sin(aoa)*chord-cos(aoa)*airfoil, 'k-')
xlabel('x/c')
ylabel('y/c')
title('vortex trajectory')
axis([-0.3 1.3 -0.4 0.2])
pbaspect([1.6 0.6 1])
set(gcf,'position',[500,500,900,360])
saveas(gcf, 'plunging/airfoil.png')
%% vortex trajectory
chord=[0:0.01:1];
airfoil=naca0012(chord);
figure
for ii=1:1:ncases
    plot(streamx{ii}, height{ii}, symbol{ii})
    hold on;
end
axis([-0.2 1.3 -0.3 0.3])
% legend(legendlabel, 'Location', 'Best')
plot(cos(aoa)*chord+sin(aoa)*airfoil, -sin(aoa)*chord+cos(aoa)*airfoil, 'k-')
plot(cos(aoa)*chord-sin(aoa)*airfoil, -sin(aoa)*chord-cos(aoa)*airfoil, 'k-')
xlabel('x/c')
ylabel('y/c')
text(-0.05, 0.2, 'A/c=0.5')
text(0.6, -0.03, 'A/c=0.1')
title('vortex trajectory')
pbaspect([1.6 0.6 1])
set(gcf,'position',[500,500,900,360])
if savepng>0
    saveas(gcf, 'plunging/trajectory.png')
end
%% vortex trajectory connect leg
chord=[0:0.01:1];
airfoil=naca0012(chord);
for ii=1:1:ncases
    figure
    lenz = length(endpoint{ii});
    for jj=1:1:lenz
        plot([streamx{ii}(jj) endpoint{ii}(jj,1)], [height{ii}(jj) endpoint{ii}(jj,2)], symbol{ii})
        hold on;
    end
    axis([0 1.5 -0.3 0.3])
    plot(cos(aoa)*chord+sin(aoa)*airfoil, -sin(aoa)*chord+cos(aoa)*airfoil, 'k-')
    plot(cos(aoa)*chord-sin(aoa)*airfoil, -sin(aoa)*chord-cos(aoa)*airfoil, 'k-')
    xlabel('x/c')
    ylabel('h/c')
    title('vortex trajectory')
    pbaspect([1.6 0.6 1])
    set(gcf,'position',[500,500,900,360])
    if savepng>0
        saveas(gcf, sprintf('plunging/trajectory%d.png', ii))
    end
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
plot([0 2], [0 2], '-k')
axis([0 2 0 1])
% legend(legendlabel, 'Location', 'Best')
xlabel('tU/c')
ylabel('x/c')
text(1.2, 0.3,'slope=0.52')
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
text(0.1,2, 'A/c=0.5')
text(1, 0.2, 'A/c=0.1')
% legend(legendlabel, 'Location', 'Best')
if savepng>0
    saveas(gcf, 'plunging/circulation.png')
end
%% radius
figure;
for ii=1:1:ncases
    plot(time{ii}, radius{ii}, symbol{ii})
    hold on;
end
hold off
xlabel('tU/c')
ylabel('a/c')
title('radius')
axis([0 2 0 0.18])
% legend(legendlabel, 'Location', 'Best')
if savepng>0
    saveas(gcf, 'plunging/radius.png')
end
%%  wavelength
figure
for ii=plotsequence
    plot(time{ii}, wavel{ii}, symbol{ii})
    hold on;
end
axis([0 2 0 1.5])
% legend(legendlabel, 'Location', 'NorthWest')
xlabel('tU/c')
ylabel('\lambda/c')
title('wavelength')
if savepng>0
    saveas(gcf, 'plunging/wavelength.png')
end
%%  wavelength x
figure
for ii=[3]
    plot(streamx{ii}, wavel{ii}, symbol{ii})
    hold on;
end
axis([0 2 0 2])
% legend(legendlabel, 'Location', 'NorthWest')
xlabel('x/c')
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
    saveas(gcf, 'plunging/waveheigth.png')
end
%% test data collapse
figure
for ii=plotsequence
    chordx = cos(aoa)*streamx{ii} - sin(aoa)*height{ii};
    chordy = sin(aoa)*streamx{ii} + cos(aoa)*height{ii};
    airfoily = naca0012(chordx);
    plot(time{ii}, wavel{ii}./(chordy - airfoily), symbol{ii})
    hold on;
end
axis([0 2 0 8])
% legend(legendlabel, 'Location', 'Best')
xlabel('tU/c')
ylabel("\lambda/h")
title("wavelength/h")
if savepng>0
    saveas(gcf, 'plunging/wavelength_distance.png')
end
%%
figure
for ii=3
    chordx = cos(aoa)*streamx{ii} - sin(aoa)*height{ii};
    chordy = sin(aoa)*streamx{ii} + cos(aoa)*height{ii};
    airfoily = naca0012(chordx);
    exportdata = [chordx wavel{ii}./radius{ii}]
    plot(streamx{ii}, wavel{ii}./(chordy - airfoily), symbol{ii})
    hold on;
end
% plot([0 1], [3 3], 'r--')
% plot([0 1], [4 4], 'r--')
% plot([0 1], [5 5], 'r--')
axis([0 1 0 6])
% legend(legendlabel, 'Location', 'Best')
xlabel('x/c')
ylabel("\lambda/h")
title("wavelength/h")
if savepng>0
    saveas(gcf, 'plunging/wavelength_distance_x.png')
end
%%
figure
for ii=2
    chordx = cos(aoa)*streamx{ii} - sin(aoa)*height{ii};
    chordy = sin(aoa)*streamx{ii} + cos(aoa)*height{ii};
    airfoily = naca0012(chordx );
    exportdata = [radius{ii}./(chordy - airfoily) wavel{ii}./(chordy - airfoily)]
    plot(radius{ii}./(chordy - airfoily), wavel{ii}./(chordy - airfoily), symbol{ii})
    hold on;
end
% plot([0 1], [3 3], 'r--')
% plot([0 1], [4 4], 'r--')
% plot([0 1], [5 5], 'r--')
axis([0 1 0 6])
% legend(legendlabel, 'Location', 'Best')
xlabel('a/h')
ylabel("\lambda/h")
title("wavelength/h")
if savepng>0
    saveas(gcf, 'plunging/wavelength_distance_ah.png')
end
%% test data collapse
figure
for ii=plotsequence
    plot(time{ii}, wavel{ii}./radius{ii}, symbol{ii})
    hold on;
end
axis([0 2 0 15])
% legend(legendlabel, 'Location', 'Best')
xlabel('tU/c')
ylabel("\lambda/a")
title("wavelength/a")
if savepng>0
    saveas(gcf, 'plunging/wavelength_radius.png')
end
%%
figure
for ii=plotsequence
    plot(streamx{ii}, wavel{ii}./radius{ii}, symbol{ii})
    hold on;
end
axis([0 1 0 14])
% legend(legendlabel, 'Location', 'Best')
xlabel('x/c')
ylabel("\lambda/a")
title("wavelength/a")
if savepng>0
    saveas(gcf, 'plunging/wavelength_radius_x.png')
end
%%
figure
for ii=2
    chordx = cos(aoa)*streamx{ii} - sin(aoa)*height{ii};
    chordy = sin(aoa)*streamx{ii} + cos(aoa)*height{ii};
    airfoily = naca0012(chordx);
    exportdata = [radius{ii}./(chordy - airfoily) wavel{ii}./radius{ii}]
    plot(radius{ii}./(chordy - airfoily), wavel{ii}./radius{ii}, symbol{ii})
    hold on;
end
axis([0 1 0 14])
% legend(legendlabel, 'Location', 'Best')
xlabel('a/h')
ylabel("\lambda/a")
title("wavelength/a")
if savepng>0
    saveas(gcf, 'plunging/wavelength_radius_ah.png')
end

%% 3D H1D simulation
x = [1.19983677910772579 1.58982589771490757 1.78888284367065653 1.97575262966993104]'
y = [-0.558142908959013306 -0.901414581066376286 -0.964381574174827394 -0.842509974610083257]'
t = [1.75 2 2.125 2.25]'
lambda=[1.4853 1.4853 1.4853 1.4853]'
[x*cos(aoa) - y * sin(aoa) t lambda]