function [dx, dy] = naca0012ds(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
x = min(x, 1);
x = max(x,0);
xs{1} = x;
for i=1:1:4
    xs{i+1} = xs{i}.*x;
end
m_t = 0.12;
t =  5.*m_t*(0.2969*0.5./sqrt(x) -0.1260 - 0.3516*2.*xs{1} + 0.2843*3.*xs{2} - 0.1015*4.*xs{3});
len = sqrt(1+t.*t);
dx = 1./len;
dy = t./len;
for ii=1:1:length(dy)
    if isnan(dy(ii))
        dy(ii) = 1;
    end
end
end