clear;
close all;
clc;
%% Threshold
threshold = 0;
%% Read in image
Fixed = imread ('D:\image\2fixed.jpg');
Moving = imread ('D:\image\2moving.jpg');
Fixed = rgb2gray(Fixed);
Moving = rgb2gray(Moving);
%% Image registration
[optimizer, metric] = imregconfig('Monomodal');
Registered = imregister(Moving, Fixed, 'Similarity', optimizer, metric);
figure;
imshowpair(Registered, Fixed);
title('Image registration');
I2 = im2double(Registered);
I1 = im2double(Fixed);
%% Mean & Standard deviation
a = size(Fixed);
rows1 = reshape(I1,a(1)*a(2),1);
rows2 = reshape(I2,a(1)*a(2),1);
u1 = mean(rows1);
u2 = mean(rows2);
sigma1 = std(rows1);
sigma2 = std(rows2);
%% Normalize I2
I22=zeros(1);
for i=1:a(1)
    for j=1:a(2)
        I22(i,j) = sigma1/sigma2*(I2(i,j)-u2)+u1;
    end
end
%% Change detection
Ir = zeros(1);
for i=1:a(1)
    for j=1:a(2)
        Ir(i,j)=atan(I1(i,j)/I22(i,j))-pi/4;
    end
end
T = zeros(1);
for i=1:a(1)
    for j=1:a(2)
        if Ir(i,j) >= threshold
            T(i,j) = 0;
        else
            T(i,j) = 1;
        end
    end
end
T = ~T;
se=strel('square',2);
T = imerode(T,se);
T = ~T;
%% Choose the image range
[x1,y1] = ginput(1);
hold on;
plot(x1,y1,'o');
[x2,y2] = ginput(1);
hold on;
plot(x2,y2,'o');
[x3,y3] = ginput(1);
hold on;
plot(x3,y3,'o');
TT = zeros(1);
z = 0;
for j=round(x1):round(x2)
    z = z + 1;
    n = 0;
    for i=round(y1):round(y3)
        n = n + 1;
        TT(n,z)=T(i,j);
    end
end
%% Figure show
figure;
imshow(TT);