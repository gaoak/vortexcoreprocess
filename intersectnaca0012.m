function [sect, cosangle] = intersectnaca0012(aoa, point, dir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
lendir = sqrt(dir(1)*dir(1) + dir(2)*dir(2) + dir(3)*dir(3));
dir = dir / lendir;
if dir(2)>0
    dir = -dir;
end
p(1) = point(1)*cos(aoa) - point(2)*sin(aoa);
p(2) = point(1)*sin(aoa) + point(2)*cos(aoa);
p(3) = point(3);
d(1) = dir(1)*cos(aoa) - dir(2)*sin(aoa);
d(2) = dir(1)*sin(aoa) + dir(2)*cos(aoa);
d(3) = dir(3);
ts = -1.;
te = 1.;
while te - ts > 1E-4
    t = 0.5 * (te + ts);
    tp = p + d * t;
    airt = naca0012(tp(1));
    if tp(2) < airt-1E-5
        te = t;
    elseif tp(2) > airt+1E-5
        ts = t;
    else
        break;
    end
end
[dx, dy] = naca0012ds(tp(1));
cosangle = abs(-d(1)*dy + d(2)*dx)/sqrt(dx*dx + dy*dy);
sect = point + t*dir;
if sect(1)<0 | sect(1)>1
    sect = [nan nan nan];
end
end

