clear;
close all;
clc;

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
I2 = Registered;
I1 = Fixed;
a = size(Fixed);

Id = zeros(1);
for i=1:a(1)
    for j=1:a(2)
        Id(i,j)=I1(i,j)-I2(i,j);
    end
end
threshold = 40;
T = zeros(1);
for i=1:a(1)
    for j=1:a(2)
        if Id(i,j) >= threshold
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

figure;
imshow(T);