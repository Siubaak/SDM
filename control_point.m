clear;
close all;
clc;
%% Read in the image pair
Fixed = imread ('D:\image\Fixed.png');
Moving = imread ('D:\image\Moving.png');
imshowpair(Fixed, Moving, 'montage');
Fixed = rgb2gray(Fixed);
Moving = rgb2gray(Moving);

%% Image registration
[optimizer, metric] = imregconfig('Monomodal');
Registered = imregister(Moving, Fixed, 'Similarity', optimizer, metric);
figure;
imshowpair(Registered, Fixed);
title('Similarity');

%% Select control point
figure;
imshow(Fixed);
title('Fixed - CP Select');
[x, y] = ginput(1);
x = round(x);
y = round(y);
hold on;
plot(x,y,'o');

%% Store a small area image in Fixed
range = 10;
tolerance = 20;
G = zeros(2*range+1,2*range+1);
ii = 0;
for i=(x-range):(x+range)
    ii = ii + 1;
    jj = 0;
    for j=(y-range):(y+range)
        jj = jj + 1;
        G(ii,jj) = Fixed(i,j);
    end
end

%% Grey to Binary
%Fixed
sumG = 0;
for ii=1:(2*range+1)
    for jj=1:(2*range+1)
        sumG = sumG + G(ii,jj);
    end
end
aveG = sumG / ((2*range+1)^2);
hv = zeros(((2*range+1)^2),1);
k = 0;
for ii=1:(2*range+1)
    for jj=1:(2*range+1)
        k = k + 1;
        if G(ii,jj) >= aveG
            hv(k) = 1;
        else
            hv(k) = 0;
        end
    end
end

%% Hamming distance
rc = size(Registered);
xran = 60;
yran = 120;
iii = rc(1) - xran;       %assume what we concern is located in the middle and we don't care about the edge information.
jjj = rc(2) - yran;
u = 0;
ppp=0;
cp = zeros(1,2);
G0 = zeros(2*range+1,2*range+1);
figure;
imshow(Registered);
title('Corresponding Point');
for i=xran:iii
    for j=yran:jjj
        ii0 = 0;
        for i1=(i):(i+2*range)
            ii0 = ii0 + 1;
            jj0 = 0;
            for j1=(j):(j+2*range)
                jj0 = jj0 + 1;
                G0(ii0,jj0) = Registered(i1,j1);
            end
        end
        %Fixed
        sumG0 = 0;
        for ii0=1:(2*range+1)
            for jj0=1:(2*range+1)
                sumG0 = sumG0 + G0(ii0,jj0);
            end
        end
        aveG0 = sumG0 / ((2*range+1)^2);
        hv0 = zeros(((2*range+1)^2),1);
        k0 = 0;
        for ii0=1:(2*range+1)
            for jj0=1:(2*range+1)
                k0 = k0 + 1;
                if G0(ii0,jj0) >= aveG0
                    hv0(k0) = 1;
                else
                    hv0(k0) = 0;
                end
            end
        end
        pp = 0;
        for i2=1:((2*range+1)^2)
            if hv(i2)==hv0(i2)
               pp = pp + 1; 
            end
        end
        ppp = max(ppp,pp);
        if pp >= (((2*range+1)^2)-tolerance)
            u = u + 1;
            cp(u,1) = i;
            cp(u,2) = j;
            hold on
            plot(j,i,'o');
        end
    end
end

%% Calculate the distance
%Breakpoint is needed below for selecting the control points (F12)
%dist = sqrt((movingPoints(1,1) - fixedPoints(1,1))^2 + (movingPoints(1,2) - fixedPoints(1,2))^2);
%distunit = sqrt((fixedPoints(2,1) - fixedPoints(3,1))^2 + (fixedPoints(2,2) - fixedPoints(3,2))^2);
%Checkboard is needed to determine the unit of distance
%realdist = dist / distunit
