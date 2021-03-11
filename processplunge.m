%%
clear;
clc;
close all;
setPlotParameters;
%%
fileformat={'Re400_k2_Ap5/R1_vcore%d.dat', 'Re1000_k2_Ap5/R1_vcore%d.dat',...
    'Re10k_k2_Ap5/R1_vcore%d.dat', 'Re10k_k2_Ap1/R1_vcore%d.dat'};
nfile=[109 122; 36, 49; 36 49; 4 29];
thresratio = [0.5, 0.5, 0.8, 0.5];
limitzmin = [5., 5., 5., 4.];
nvar = 10;
skip=1;
aoa = 15/180.*pi;
tT = 0.25 + [0:1:13]'*0.0625;
clear endpoint wavel radius gamma;
mode = 0;
% figure;
for nn=1:1:4
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
        tmpheight(ii-ns+1) = h - naca0012(x);
        tmpvortexheight(ii-ns+1) = ph - naca0012(x);
    end
    endpoint{nn} = tmpend;
    gamma{nn} = tmpgamma;
    radius{nn} = tmpradius;
    wavel{nn} = tmpwavel;
    streamx{nn} = tmpstreamx;
    height{nn} = tmpheight;
    vortexheight{nn} = tmpvortexheight;
end
%%
symbol = {'og-', 'sb-', 'vk-',  'vc--'};
legendlabel = {'Re 400, A/c=0.5', '1000, 0.5', '10k, 0.5', '10k, 0.1'};
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
for ii=1:1:4
    plot(endpoint{ii}(:,1), endpoint{ii}(:,2), symbol{ii})
    hold on;
end
plot(5-exploc(:,2),exploc(:,1), '^k-')
hold off
axis([3.5 5.5 0 0.8])
set(gca, 'XDir', 'reverse');
set(gca, 'YDir', 'reverse');
xlabel('z/c')
ylabel('x/c')
legend({legendlabel{:} '10k, 0.5, exp'}, 'Location', 'SouthWest')
title('LEV leg')
saveas(gcf, 'plunging/vortexleg.png')
%% vortex streamwise location
figure;
for ii=1:1:4
    plot(tT, streamx{ii}(1:14), symbol{ii})
    hold on;
end
axis([0 1.25 0 0.8])
ylabel('x/c')
xlabel('t/T')
legend(legendlabel, 'Location', 'Best')
title('chord direction location')
saveas(gcf, 'plunging/xlocation.png')
%% vortex height
figure;
for ii=1:1:4
    plot(tT, height{ii}(1:14), symbol{ii})
    hold on;
end
hold off
axis([0 1.25 0 0.4])
ylabel('h/c')
xlabel('t/T')
legend(legendlabel, 'Location', 'NorthWest')
title('distance to wall')
saveas(gcf, 'plunging/heighttowall.png')
%%
figure;
for ii=1:1:4
    plot(tT, gamma{ii}(1:14), symbol{ii})
    hold on;
end
hold off
axis([0 1.25 0 2.5])
ylabel('\Gamma/Uc')
xlabel('t/T')
title('circulation')
% legend(legendlabel, 'Location', 'Best')
saveas(gcf, 'plunging/circulation.png')
%%
figure;
for ii=1:1:4
    plot(tT, 1.58 * radius{ii}(1:14), symbol{ii})
    hold on;
end
hold off
xlabel('t/T')
ylabel('r/c')
title('radius')
axis([0 1.25 0 0.15])
% legend(legendlabel, 'Location', 'Best')
saveas(gcf, 'plunging/radius.png')
%%  wavelength
figure
for ii=1:1:4
    plot(tT, wavel{ii}(1:14), symbol{ii})
    hold on;
end
axis([0 1.25 0 2])
legend(legendlabel, 'Location', 'NorthWest')
xlabel('t/T')
ylabel('\lambda/c')
title('wavelength')
saveas(gcf, 'plunging/wavelength.png')
%% vortex height
figure
for ii=1:1:4
    plot(tT, vortexheight{ii}(1:14), symbol{ii})
    hold on;
end
axis([0 1.25 0 0.6])
legend(legendlabel, 'Location', 'Best')
xlabel('t/T')
ylabel('\Lambda/c')
title('crest height')
saveas(gcf, 'plunging/waveheight.png')