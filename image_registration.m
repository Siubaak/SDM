clear;
clc;
%% Read in the image pair
Fixed = imread ('D:\image\image3.png'); %Remain stationary
Moving = imread ('D:\image\image4.png'); %Moving and align to stationary image

%% View the images side by side in a montage
imshowpair(Fixed, Moving, 'montage');
Fixed = rgb2gray(Fixed);
Moving = rgb2gray(Moving);

%% Configure parameters in imregconfig
[optimizer, metric] = imregconfig('Monomodal'); %Captured from single camera (similar brightness ranges)

%% Trial 1 Default registration
Registered = imregister(Moving, Fixed, 'translation', optimizer, metric);
figure;
imshowpair(Registered, Fixed);
title('Translation');

%% Trial 2 Change transform type in imregister
Registered = imregister(Moving, Fixed, 'affine', optimizer, metric);
figure;
imshowpair(Registered, Fixed);
title('Affine');

%affine-Affine transformation consisting of translation, rotation, scale, and shear
%% Trial 3 Change transform type in imregister
Registered = imregister(Moving, Fixed, 'Similarity', optimizer, metric);
figure;
imshowpair(Registered, Fixed);
title('Similarity');
%This transform type is more accurate