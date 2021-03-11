function res = LEVcenterCond(data)
%LEV coordinate should have 0<=z<=5
%   Detailed explanation goes here
if data(3) <= 5;
    res = true;
else
    res = false;
end
end

