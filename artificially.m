clear;
close all;
clc;
%% Read in the image pair
Fixed = imread ('D:\image\2fixed.jpg');
Moving = imread ('D:\image\2moving.jpg');
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
title('Fixed');
[x, y] = ginput(1);
hold on;
plot(x,y,'o');
[x1, y1] = ginput(1);
hold on;
plot(x1,y1,'o');
[x2, y2] = ginput(1);
hold on;
plot(x2,y2,'o');
figure;
imshow(Registered);
title('Registered');
[x0, y0] = ginput(1);
hold on;
plot(x0,y0,'o');


%% Calculate the distance
dist = sqrt((x0 - x)^2 + (y0 - y)^2);
distunit = sqrt((x1 - x2)^2 + (y1 - y2)^2);
realdist = dist / distunit
