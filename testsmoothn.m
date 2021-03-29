%%
t = linspace(0,6*pi,1000);
x = sin(t) + 0.1*randn(size(t));
y = cos(t) + 0.1*randn(size(t));
z = t + 0.1*randn(size(t));
u = smoothn({x,y,z});
plot3(x,y,z,'r.',u{1},u{2},u{3},'k','linewidth',2)
axis tight square
%%
x = linspace(0,100,2^8);
y = cos(x/10)+(x/50).^2 + randn(size(x))/10;
y([70 75 80]) = [5.5 5 6];
z = smoothn(y); % Regular smoothing
zr = smoothn(y,'robust'); % Robust smoothing
subplot(121), plot(x,y,'r.',x,z,'k','LineWidth',2)
axis square, title('Regular smoothing')
subplot(122), plot(x,y,'r.',x,zr,'k','LineWidth',2)
axis square, title('Robust smoothing')
%%
figure
aoa = 15/180*pi;
x = file.data(:,1);
y = file.data(:,2);
z = file.data(:,3);
d = file.data(:,5); %sin(aoa)*x + cos(aoa)*y;
sz = smoothn({x',y',z'},'robust')';
    plot(sz{1}, sz{2},'-b')
    hold on;
%     plot(x,y,'.-k')
%     axis([0 5 0 0.6])
    set(gca, 'XDir', 'reverse');
    xlabel('z')
    ylabel('y')
%%
chord=[0.:0.01:1];
aoa=10/180*pi;
airfoil=naca0012(chord);
[tx, ty] = naca0012ds(chord);
dx = tx*cos(aoa) + ty*sin(aoa);
dy = -tx*sin(aoa) + ty*cos(aoa);
figure
plot(chord*cos(aoa)+airfoil*sin(aoa), -chord*sin(aoa)+airfoil*cos(aoa), 'k-')
hold on;
plot(chord*cos(aoa)-airfoil*sin(aoa), -chord*sin(aoa)-airfoil*cos(aoa), 'k-')
ds = 0.02;
for ii=1:1:length(chord)
    p1 = [chord(ii), airfoil(ii)];
    p = [p1(1)*cos(aoa)+p1(2)*sin(aoa), -p1(1)*sin(aoa)+p1(2)*cos(aoa), 0];
    p2 = p + ds*[-dy(ii), dx(ii), 0];
    plot([p(1), p2(1)], [p(2), p2(2)], 'b.-')
    [sect, cosangle] = intersectnaca0012(aoa, p, [-dy(ii) dx(ii) 0]);
    ca(ii) = cosangle;
    plot(sect(1), sect(2), '^r')
end
axis([0 1.5 -0.3 0.3])
xlabel('x/c')
ca'
ylabel('h/c')
title('vortex trajectory')
pbaspect([1.6 0.6 1])
%%
Gamma=2;
r = 0.08;
v = Gamma / (2*pi*r);
turn_over_time = 2*pi*r/v / (pi/2)