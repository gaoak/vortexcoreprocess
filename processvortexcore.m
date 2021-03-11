function [radius, gamma, lambda, peakheight, streamx, height, loc] = processvortexcore(file, aoa, mode)
%%location lambda
x = file.data(:,1);
y = file.data(:,2);
z = file.data(:,3);
sr = smoothn({x',y',z'},1,'robust')';
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
d = cos(aoa)*x - sin(aoa)*y;
sd = cos(aoa)*sr{1} - sin(aoa)*sr{2};
streamx = mean(sd(zstart:1:zend));
loc = [z(1), d(1)];
if mode==1
     figure;
    plot(sr{3},sd,'-b')
    hold on;
    plot(z,d,'.k')
    plot(loc(1), loc(2),'or')
    axis([0 5 0 1])
    set(gca, 'XDir', 'reverse');
    set(gca, 'YDir', 'reverse');
    xlabel('z')
    ylabel('x')
end
%% z-y plot
d = sin(aoa)*x + cos(aoa)*y;
sd = sin(aoa)*sr{1} + cos(aoa)*sr{2};
height = mean(sd(zstart:1:zend));
locy = [z(1), d(1)];
% wavelength
[~, maxi] = max(sd(1:floor(0.3*length(x))));
lambda=z(maxi) - z(1);
peakheight = sd(maxi);
if mode==4
%     figure;
    plot(sr{3},sd,'-b')
    hold on;
    plot(z,d,'.k')
    plot(locy(1), locy(2),'or')
    plot(sr{3}(maxi), sd(maxi), 'og')
    axis([0 5 0 0.6])
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
%     figure;
    plot(z,0*z+radius,'-k')
    hold on;
    plot(sr{1},sr{2},'-b')
    plot(z,r,'.k')
    set(gca, 'XDir', 'reverse');
    xlabel('z')
    ylabel('r')
    axis([0 5 0 0.12])
end
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