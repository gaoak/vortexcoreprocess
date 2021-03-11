function file2 = cleanvortexcore(file, aoa, mode)
%trim vortex core data
% first find the peak in height direction
x = file.data(:,1);
y = file.data(:,2);
z = file.data(:,3);
nsize = length(x);
acme = findacme(y);
[maxv, maxi] = max(y(1:floor(0.3*nsize)));
[minv, mini] = min(y(1:floor(0.3*nsize)));
thresh = autothresh(acme)
while 1
    [flag, acme] = trimacme(acme, thresh);
    if flag==0;
        break;
    end
end
figure;
plot(z, y,'b-')
hold on;
plot(z(acme(:,1)), y(acme(:,1)), 'o')
% plot(z(maxi), y(maxi), 'o')
% plot(z(endi), y(endi), 'o')
file2 = file;
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

