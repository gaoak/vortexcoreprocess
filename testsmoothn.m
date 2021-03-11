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