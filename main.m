clear;
close all;
clc;
%% Read in the image pair
Fixed = imread ('D:\image\image3.png');
Moving = imread ('D:\image\image4.png');
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
%ceng = Fixed(x, y);
G = [Fixed((x-1), (y-1)) Fixed((x-1), y) Fixed((x-1), (y+1));
     Fixed(x, (y-1)) Fixed(x, y) Fixed(x, (y+1));
     Fixed((x+1), (y-1)) Fixed((x+1), y) Fixed((x+1), (y+1))];
rc = size(Registered);
ii = rc(1) - 1;
jj = rc(2) - 1;
aa = 0;
cp = zeros(1,2);
ppp=0;
for i=2:ii
    for j=2:jj
        ceng0 = Registered(i, j);
        GG = [Registered((i-1), (j-1)) Registered((i-1), j) Registered((i-1), (j+1));
              Registered(i, (j-1)) Registered(i, j) Registered(i, (j+1));
              Registered((i+1), (j-1)) Registered((i+1), j) Registered((i+1), (j+1))];
        k = 0;
        for a=1:3
            for b=1:3
                if GG(a,b)<=(G(a,b)+2) && GG(a,b)>=(G(a,b)-2)
                    k = k + 1; 
                end
            end
        end
        ppp = max(ppp,k);
        if k == 9
            aa = aa + 1;
            cp(aa,1) = i;
            cp(aa,2) = j;
        end
    end
end
cp
r = 1


%% Calculate the distance
%Breakpoint is needed below for selecting the control points (F12)
%dist = sqrt((movingPoints(1,1) - fixedPoints(1,1))^2 + (movingPoints(1,2) - fixedPoints(1,2))^2);
%distunit = sqrt((fixedPoints(2,1) - fixedPoints(3,1))^2 + (fixedPoints(2,2) - fixedPoints(3,2))^2);
%Checkboard is needed to determine the unit of distance
%realdist = dist / distunit
