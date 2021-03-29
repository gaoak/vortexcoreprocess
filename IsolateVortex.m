%%
% clear;
clc;
close all;
setPlotParameters;
savepng=1;
%%
peakz = [6.792608691	6.801249506	6.945263088	7	7
6.562186961	6.550665874	6.740763802	6.801249506	6.776042999
6.386490391	6.337525774	6.573708047	6.619792393	6.573240358
6.230955723	6.138787031	6.475778812	6.423933922	6.402768572
6.086942142	5.968851005	6.36632849	6.274159798	6.232296787
5.937168017	5.793154435	6.262638711	6.107104043	6.123547545
5.689464657	5.476324556	6.052378882	5.83635851	5.667976394
5.459042926	5.16525522	5.859400683	5.568493248	5.450477909
5.243022554	4.894509686	5.692344928	5.372634777	5.238857761];
peaky = [2.595430248	2.595430248	2.618472421	2.894978497	2.661829271
2.601190791	2.601190791	2.589669705	2.713521385	2.605985065
2.583909161	2.589669705	2.586789433	2.707760841	2.605985065
2.586789433	2.583909161	2.589669705	2.707760841	2.59422839
2.583909161	2.575268346	2.583909161	2.707760841	2.582471715
2.58102889	2.575268346	2.583909161	2.696239755	2.591289221
2.58102889	2.560866988	2.572388075	2.678958125	2.582471715
2.572388075	2.555106445	2.572388075	2.661676495	2.582471715
2.566627532	2.557986717	2.566627532	2.658796224	2.579532547];
valleyz=[6.593869949	6.585229134	6.645714838	6.550665874	6.49976114
6.346166588	6.328884959	6.495940713	6.285680884	6.229357618
6.141667303	6.089822413	6.291441427	6.075421055	6.058885833
5.931407474	5.876682313	6.147427846	5.873802041	5.850204854
5.778753077	5.67794357	6.037977524	5.698105471	5.709124756
5.626098681	5.490725914	5.885323127	5.510887815	5.58567967
5.352472876	5.153734133	5.646260582	5.217100109	5.288823629
5.078847071	4.834023982	5.421599395	4.940594033	5.062507638
4.839784525	4.560398177	5.225740924	4.692890672	4.815617466];
valleyy = [2.485979926	2.474458839	2.480219383	2.468698296	2.485479148
2.462937753	2.460057481	2.468698296	2.451416666	2.470783304
2.460057481	2.45717721	2.480219383	2.416853407	2.470783304
2.465818024	2.448536395	2.480219383	2.40533232	2.459026629
2.454296938	2.445656123	2.474458839	2.385170419	2.447269954
2.454296938	2.43989558	2.477339111	2.373649332	2.441391617
2.451416666	2.431254765	2.465818024	2.365008517	2.432574111
2.437015308	2.42261395	2.474458839	2.350607159	2.423756605
2.448536395	2.431254765	2.471578568	2.339086073	2.420817436];
%%
Reynolds = [1000, 2000, 1000, 1000, 1000];
Radius =   1.58*[0.05, 0.05, 0.08, 0.05,0.05];
Height =   [0.2,  0.2,  0.2,  0.4, 0.2];
Gamma =    [1.,   1.,   1.,   1., 1.];
Ratio = Radius./Height;
time = [.4:.4:2.4 3.2 4 4.8]';
%+ Re 2000, ^ Re 1000, s Re 800, o Re 400
% b r0.05, h0.2; r r0.06, h0.2; k r0.08, h0.2
%vis --
plottype = {'^b', '+b', '^k', '^r','sg'};
DS = [2,1,3,4,5];
legendlabel = {'\Gamma/\nu 2000, \sigma 0.05, h 0.2','1000,0.05,0.2', '1000,0.08,0.2', '1000,0.05,0.4', '1000,0.05,0.2(h)x0.4(w)'};
index = 1;
figure;
for ii=DS
    plot([0], [0]  , plottype{ii});
    hold on;
end
 legend(legendlabel, 'Location', 'Best');
 if savepng>0
    saveas(gcf, 'isolate/legend.png')
 end
%% wave amplitude / disturbance height
amp = (peaky - valleyy);
figure;
for ii=DS
    st = time*Gamma(ii)/Radius(ii)/Radius(ii);
    sz = amp(:, ii)./Height(ii);
    plot(st, sz, plottype{ii});
    hold on;
end
xlabel('t \Gamma/r^2')
ylabel('\Lambda/h')
title('wave amplitude/disturbance height')
axis([0 800 0 1])
if savepng>0
    saveas(gcf, 'isolate/amp_height.png')
end
%% wave length / wave amplitude
amp = (peaky - valleyy);
dispz = 2.*(peakz - valleyz);
figure;
for ii=DS
    st = time*Gamma(ii)/Radius(ii)/Radius(ii);
    sz = dispz(:, ii)./amp(:,ii);
    plot(st, sz, plottype{ii});
    hold on;
end
% plot([0 800], [3 3], 'r--')
% plot([0 800], [4 4], 'r--')
% plot([0 800], [5 5], 'r--')
xlabel('t \Gamma/r^2')
ylabel('\lambda/\Lambda')
title('wavelength/peak-peak wave amplitude')
axis([0 800 0 8])
if savepng>0
    saveas(gcf, 'isolate/wavelength_amp.png')
end
%% wave length / intial disturbance heihgt
dispz = 2.*(peakz - valleyz);
figure;
for ii=DS
    st = time*Gamma(ii)/Radius(ii)/Radius(ii);
    sz = dispz(:, ii)./Height(ii);
    plot(st, sz, plottype{ii});
    hold on;
end
% plot([0 800], [3 3], 'r--')
% plot([0 800], [4 4], 'r--')
% plot([0 800], [5 5], 'r--')
xlabel('t \Gamma/a^2')
ylabel('\lambda/h')
title('wave length/disturbance height')
axis([0 800 0 6])
if savepng>0
    saveas(gcf, 'isolate/wavelength_height.png')
end
%% wave length / intial disturbance heihgt
dispz = 2.*(peakz - valleyz);
figure;
for ii=DS
    st = time*0 + Height(ii)/Radius(ii);
    sz = dispz(:, ii)./Height(ii);
    plot(st, sz, plottype{ii});
    hold on;
end
xlabel('a/h')
ylabel('\lambda/h')
title('wave length/disturbance height')
axis([0 6 0 6])
if savepng>0
    saveas(gcf, 'isolate/wavelength_height_rh.png')
end
%% wave length / radius
dispz = 2.*(peakz - valleyz);
figure;
for ii=DS
    st = time*Gamma(ii)/Radius(ii)/Radius(ii);
    sz = dispz(:, ii)./Radius(ii);
    plot(st, sz, plottype{ii});
    hold on;
end
xlabel('t \Gamma/a^2')
ylabel('\lambda/a')
title('wavelength/radius')
axis([0 800 0 14])
if savepng>0
    saveas(gcf, 'isolate/wavelength_radius.png')
end
%% wave length / radius
dispz = 2.*(peakz - valleyz);
figure;
for ii=DS
    st = time*0 + Height(ii)/Radius(ii);
    sz = dispz(:, ii)./Radius(ii);
    plot(st, sz, plottype{ii});
    hold on;
end
xlabel('a/h')
ylabel('\lambda/a')
title('wavelength/radius')
axis([0 6 0 14])
if savepng>0
    saveas(gcf, 'isolate/wavelength_radius_rh.png')
end
%% wave length / radius
amp = (peaky - valleyy);
dispz = 2.*(peakz - valleyz);
figure;
for ii=DS
    st = time*Gamma(ii)/Height(ii)/Height(ii);
    sz = dispz(:, ii)./amp(:,ii);
    plot(st, sz, plottype{ii});
    hold on;
end
plot([0 60], [3 3], 'r--')
plot([0 60], [4 4], 'r--')
plot([0 60], [5 5], 'r--')
xlabel('t \Gamma/h^2')
ylabel('\lambda/\Lambda')
title('wavelength/peak-peak wave amplitude')
axis([0 60 0 8])
if savepng>0
    saveas(gcf, 'isolate/wavelength_amp.png')
end
%% vortex peak location
dispz = valleyz;
figure;
for ii=DS
    st = time*Gamma(ii)/Height(ii)/Height(ii);
    sz = (7 - dispz(:,ii))/Height(ii);
    plot(st,  sz , plottype{ii});
    hold on;
end
% legend({legendlabel{:} 'speed U_i_0'}, 'Location', 'Best');
xlabel('t\Gamma/h^2')
ylabel('z/h')
axis([0 60 0 10])
title('axial displacement of valley')
%%
dispz = peakz;
figure;
for ii=DS
    st = time*Gamma(ii)/Height(ii)/Height(ii);
    sz = (7 - dispz(:,ii))/Height(ii);
    plot(st,  sz , plottype{ii});
    hold on;
end
% legend({legendlabel{:} 'speed U_i_0'}, 'Location', 'Best');
xlabel('t\Gamma/h^2')
ylabel('z/h')
axis([0 60 0 10])
title('axial displacement of peak')
%%
dispz = peakz - valleyz;
figure;
for ii=DS
    st = time*Gamma(ii)/Height(ii)/Height(ii);
    sz = 2*dispz(:,ii)/Height(ii);
    plot(st,  sz , plottype{ii});
    hold on;
%     slope(ii) =f.p1;
end
% legend({legendlabel{:} 'speed U_i_0'}, 'Location', 'Best');
xlabel('t\Gamma/h^2')
ylabel('\lambda/h')
axis([0 60 0 7])
title('twice peak to valley length')
%%
dispz = peakz - valleyz;
figure;
for ii=DS
    st = time*Gamma(ii)/Height(ii)/Height(ii);
    sz = 2*dispz(:,ii)/Height(ii);
    plot(st,  sz , plottype{ii});
    hold on;
%     slope(ii) =f.p1;
end
% legend({legendlabel{:} 'speed U_i_0'}, 'Location', 'Best');
xlabel('t\Gamma/h^2')
ylabel('\lambda/h')
axis([0 60 0 7])
title('twice peak to valley length')
%% add data to L-vortex
dispz = peakz - valleyz;
for ii=DS
    st = time*Gamma(ii)/Height(ii)/Height(ii);
    sz = 2*dispz(:,ii)/Height(ii);
    plot(st,  sz , strcat(plottype{ii},'-'));
    hold on;
%     slope(ii) =f.p1;
end
% legend({legendlabel{:} 'speed U_i_0'}, 'Location', 'Best');
%%
figure;
for ii=DS
    plot([0], [0]  , strcat(plottype{ii},'-'));
    hold on;
end
 legend(legendlabel, 'Location', 'Best');
%% wave amplitude
amp = peaky - valleyy;
figure;
for ii=DS
    st = time*Gamma(ii)/Height(ii)/Height(ii);
    sz = amp(:,ii)/Height(ii);
    plot(st, sz, plottype{ii});
    hold on;
end
% legend(legendlabel, 'Location', 'Best');
xlabel('t\Gamma/h^2')
ylabel('\Lambda/h')
title('peak-peak wave amplitude')
axis([0 60 0 1.5])
%% with dimension vortex peak location
index = 2;
dispz = peakz;
figure;
count = 1;
clear sampx sampy;
for ii=DS
    st = (time - time(index))*Gamma(ii)/Radius(ii)/Radius(ii);
    sz = (dispz(index,ii) - dispz(:,ii))/Radius(ii);
    plot(st,  sz , plottype{ii});
    hold on;
    for jj=1:1:length(st)
        if st(jj)>0 && st(jj)<500
            sampx(count) = st(jj);
            sampy(count) = sz(jj);
            count = count + 1;
        end
    end
end
% legend({legendlabel{:} 'speed U_i_0'}, 'Location', 'Best');
xlabel('(t-t_2)\Gamma/\sigma^2')
ylabel('(z-z_2)/\sigma')
axis([-500 2000 -10 40])
title('axial displacement of peak')
f = fit(sampx', sampy', 'poly1')
plot([0 1500]', f([0 1500]') + 5, 'b-')
text(0, 30, 'slope 0.021')
% plot(f)
%% vortex valley location
index = 1;
dispz = valleyz;
figure;
count = 1;
clear sampx sampy;
for ii=DS
    st = (time - time(index))*Gamma(ii)/Radius(ii)/Radius(ii);
    sz = (dispz(index,ii) - dispz(:,ii))/Radius(ii);
    plot(st,  sz , plottype{ii});
    hold on;
    for jj=1:1:length(st)
        if st(jj)>160 && st(jj)<660
            sampx(count) = st(jj);
            sampy(count) = sz(jj);
            count = count + 1;
        end
    end
end
% legend({legendlabel{:} 'speed U_i_0'}, 'Location', 'Best');
xlabel('(t-t_1)\Gamma/\sigma^2')
ylabel('(z-z_1)/\sigma')
axis([-500 2000 0 40])
title('axial displacement of valley')
f = fit(sampx', sampy', 'poly1')
plot([0 1500]', f([0 1500]') + 5, 'b-')
text(0, 30, 'slope 0.024')
% plot(f)
%% wave length
index  =2;
wavelen =peakz - valleyz;
figure;
for ii=DS
%     st = (time - time(index))*Gamma(ii)/Radius(ii)/Radius(ii);
%     sz = (wavelen(:,ii) - wavelen(index,ii))/Radius(ii);
    st = (time )*Gamma(ii)/Radius(ii)/Radius(ii);
    sz = (wavelen(:,ii))/Radius(ii);
    plot(st, sz, plottype{ii});
    hold on;
end
% legend(legendlabel, 'Location', 'Best');
xlabel('t\Gamma/\sigma^2')
ylabel('\lambda/h')
title('wave length')
% axis([0 60 -0.03 0.12])