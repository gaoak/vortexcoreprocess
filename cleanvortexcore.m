function [lambda, secamp, zmin, loc, file2] = cleanvortexcore(file, aoa, zmin, zmax, thresh, mode)
%trim vortex core data
% first find the peak in height direction
z = file.data(:,3);
zstart = 1;
zend = 1;
for ii=1:1:length(z)
    if z(ii)<zmin
        zstart = ii;
        break;
    end
end
for ii=1:1:length(z)
    if z(ii)<zmax
        zend = ii;
        break;
    end
end
if zend<zstart;
    tmp = zstart;
    zstart = zend;
    zend = tmp;
end
index=[zstart:1:zend];
y = file.data(index,2);
acme = findacme(y);
thresh = min(thresh, autothresh(acme));
while 1
    [flag, acme] = trimacme(acme, thresh);
    if flag==0
        break;
    end
end
acme(:,1) = zstart-1+acme(:,1);
lenacme = length(acme);
ei = 1;
if acme(1,2)>acme(1+1,2)
    for ii=2:1:length(acme)-1
        if acme(ii,2)<acme(ii+1,2) && acme(ii,2)<acme(ii-1,2)
            ei = ii;
            break;
        end
    end
end
ee = lenacme;
if acme(lenacme,2)>acme(lenacme-1,2)
    for ii=length(acme)-1:-1:2
        if acme(ii,2)<acme(ii+1,2) && acme(ii,2)<acme(ii-1,2)
            ee = ii;
            break;
        end
    end
end
file2.data = file.data(acme(ei, 1):length(z),:);
lambda = z(acme(ei, 1)) - z(acme(min(ee,lenacme), 1));
d = cos(aoa)*file.data(acme(ei,1), 1) - sin(aoa)*file.data(acme(ei,1), 2);
loc = [file.data(acme(ei,1), 3), d];
if lenacme>2
    secamp = file.data(acme(ei+1, 1), 2) - file.data(acme(ei+2, 1), 2);
else
    secamp = thresh;
end
zmin = file.data(acme(ee, 1), 3);
if mode>0
    figure;
    plot(file.data(:,3), file.data(:,2),'b-')
    hold on;
    plot(file.data(acme(:,1),3), file.data(acme(:,1),2), 'o')
    plot([file.data(acme(ei,1),3), -lambda + file.data(acme(ei,1),3)], [file.data(acme(ei,1),2), file.data(acme(ei,1),2)], 'r-')
end
end

function acme = findacme(h)
nsize = length(h);
flag = 0;
acme(1,1)=1;
acme(1,2)=h(1);
acount = 2;
for ii=2:1:nsize-1
    if h(ii) <= h(ii-1) && h(ii)<=h(ii+1) && (h(ii)<h(ii-1) || h(ii)<h(ii+1));
        if flag==-1;
            acme(acount-1, 1) = round((acme(acount-1, 1) + ii)/2);
        else
            acme(acount, 1) = ii;
            acme(acount, 2) = h(ii);
            acount = acount + 1;
        end
        flag = -1.;
    end
     if h(ii) >= h(ii-1) && h(ii)>=h(ii+1) && (h(ii)>h(ii-1) || h(ii)>h(ii+1));
        if flag==1;
            acme(acount-1, 1) = round((acme(acount-1, 1) + ii)/2);
        else
            acme(acount, 1) = ii;
            acme(acount, 2) = h(ii);
            acount = acount + 1;
        end
        flag = 1.;
    end
end
if nsize>1;
    acme(acount, 1) = nsize;
    acme(acount, 2) = h(nsize);
end
end

function thresh = autothresh(acme)
thresh = 0;
nsize = length(acme);
for ii=1:1:nsize-1
    if abs(acme(ii+1,2) - acme(ii,2)) > thresh;
        thresh = abs(acme(ii+1,2) - acme(ii,2));
    end
end
thresh = thresh * 0.5;
end

function [flag, acme2] = trimacme(acme, thresh)
nsize = length(acme);
flag = 0;
for ii=1:1:nsize-1
    if abs(acme(ii+1,2) - acme(ii,2)) > thresh;
        sign = 1;
        if acme(ii+1,2) < acme(ii, 2);
            sign = -1;
        end
        if ii<=nsize-3 && abs(acme(ii+1,2)-acme(ii+2,2))<thresh;
            if sign*acme(ii+3,2)>sign*acme(ii+1,2);
                acme(ii+1,1) = -1;
                acme(ii+2,1 ) =-1;
            else
                acme(ii+2,1) = -1;
                acme(ii+3,1 ) =-1;
            end
            flag = 1;
            break;
        end
        if ii >=3 && abs(acme(ii,2)-acme(ii-1,2))<thresh;
            if sign*acme(ii-2,2)<sign*acme(ii,2);
                acme(ii,1) = -1;
                acme(ii-1,1 ) =-1;
            else
                acme(ii-1,1) = -1;
                acme(ii-2,1 ) =-1;
            end
            flag = 1;
            break;
        end
         if ii==nsize-2 && abs(acme(ii+1,2)-acme(ii+2,2))<thresh;
            acme(ii+2,1 ) =-1;
            flag = 1;
            break;
         end
        if ii==2 && abs(acme(ii,2)-acme(ii-1,2)) < thresh;
            acme(ii-1, 1) = -1;
            flag = 1;
            break
        end
    end
end
if flag==1
    count = 1;
    for ii=1:1:nsize
        if acme(ii,1)>0;
            acme2(count, :) = acme(ii, :);
            count = count  + 1;
        end
    end
else
    acme2 = acme;
end
end

