function [radius, gamma, streamx, height, legcosangle] = processvortexcore(file, aoa, mode)
%wind frame
%aoa angle of attack of airfoil
%gamma circulation
%radius = sqrt(sigma1 *  sigma2)
%streamx streamwise location of vortex column in wind frame
%height vertical location of vortex column in wind frame (anti gravity)
%peakheight is y of the peak
%the file has been cleaned so that the first point is the leg location
x = file.data(:,1);
y = file.data(:,2);
z = file.data(:,3);
sr = smoothn({x',y',z'},1,'robust')';
%%angle at tip
legi = 1;
lege = 6;
point = [sr{1}(legi) sr{2}(legi) sr{3}(legi)];
dir = [sr{1}(lege) sr{2}(lege) sr{3}(lege)] - point;
[sect, legcosangle] = intersectnaca0012(aoa, point, dir);
%% plane region
zstart = 1;
zend = 1;
for ii=1:1:length(z)
    if z(ii)<2
        zstart = ii;
        break;
    end
end
for ii=1:1:length(z)
    if z(ii)<1
        zend = ii;
        break;
    end
end
%% z-x plot
d = x;
sd = sr{1};
streamx = mean(sd(zstart:1:zend));
if mode==1
     figure;
    plot(sr{3},sd,'-b')
    hold on;
    plot(z,d,'.k')
    axis([0 5 0 1])
    set(gca, 'XDir', 'reverse');
    set(gca, 'YDir', 'reverse');
    xlabel('z')
    ylabel('x')
end
%% z-y plot
d = y;
sd = sr{2};
height = mean(sd(zstart:1:zend));
if mode==4
%     figure;
    plot(sr{3},sd,'-b')
    hold on;
    plot(z,d,'.k')
    plot(sect(3), sect(2), '^r')
%     axis([0 5 0 0.6])
    set(gca, 'XDir', 'reverse');
    xlabel('z')
    ylabel('y')
%     pbaspect([5 0.6 1])
end
%% radius
r = sqrt(file.data(:,4) .* file.data(:,5));
sr = smoothn({z',r'},'robust')';
radius = mean(sr{2}(zstart:1:zend));
if sd(1)>=0 && sd(1)<=1 && mode==2
    figure;
    plot(z,0*z+radius,'-k')
    hold on;
    plot(sr{1},sr{2},'-b')
    plot(z,r,'.k')
    set(gca, 'XDir', 'reverse');
    xlabel('z')
    ylabel('r')
    axis([0 5 0 0.12])
end
%%circulation
g = file.data(:,6);
sg = smoothn({z',g'},'robust')';
gamma = mean(sg{2}(zstart:1:zend));
if sd(1)>=0 && sd(1)<=1 && mode==3
    figure;
    plot(z,0*z+gamma,'-k')
    hold on;
    plot(sg{1},sg{2},'-b')
    plot(z,g,'.k')
    axis([0 5 0 2.5])
    set(gca, 'XDir', 'reverse');
    ylabel('\Gamma')
    xlabel('z')
end
end