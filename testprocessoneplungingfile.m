% clear;
clear;
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
for nn=1:1:3
    thresh = 1;
    ns=nfile(nn,1);
    ne=nfile(nn,2);
    for ii=ne:-1:ns
        filename = sprintf(fileformat{nn}, ii);
        file = loaddata(filename, skip, nvar, @LEVcenterCond);
        aoa=15/180*pi;
        [lambda, secamp, file] = cleanvortexcore(file, aoa, 5., 2.5,thresh);
        thresh = 0.5*secamp;
        lambda
    end
end
%%
x = file.data(:,1);
nlen = length(x);
y = file.data(:,2);
z = file.data(:,3);
w_x = file.data(:,7);
w_y = file.data(:,8);
w_z = file.data(:,9);
sr = smoothn({x',y',z'},1,'robust')';
d = cos(aoa)*x - sin(aoa)*y;
h = sin(aoa)*x + cos(aoa)*y;
tang = zeros(nlen, 4);
for ii=1:1:3
    tang(2:nlen-1,ii)=sr{ii}(3:nlen) - sr{ii}(1:nlen-2);
    tang(1,ii) = 1.;
    tang(nlen, ii) = 1.;
end
angle = tang(:,1).*w_x + tang(:,2).*w_y + tang(:,3).*w_z;
norm = sqrt((tang(:,1).*tang(:,1) + tang(:,2).*tang(:,2) + tang(:,3).*tang(:,3)).* (w_x.*w_x + w_y.*w_y + w_z.*w_z));
angle = angle./norm;
%%
figure;
plot(z, angle,'.-')
hold on;
plot(z, file.data(:,4)./0.056,'r-')
figure;
plot(z, x, 'b')
hold on;
plot(z,d,'b--')
plot(z, y, 'r')
plot(z,h,'r--')
figure;
plot(z, file.data(:,10), 'b')