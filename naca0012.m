function [t] = naca0012(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
x = min(x, 1);
x = max(x,0);
xs{1} = x;
for i=1:1:4
    xs{i+1} = xs{i}.*x;
end
m_t = 0.12;
t =  5.*m_t*(0.2969*sqrt(x) -0.1260*xs{1} - 0.3516*xs{2} + 0.2843*xs{3} - 0.1015*xs{4});
end

