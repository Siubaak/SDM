clear;
close all;
clc;
%% Read in the image pair
Corner0 = imread ('D:\image\checkerboard5.jpg');
Corner0 = rgb2gray(Corner0);
level = graythresh(Corner0);
Corner0 = im2bw(Corner0,level);

%% Corner detection
C = corner(Corner0);

%% Plot
figure;
imshow(Corner0);
hold on;
plot(C(:,1),C(:,2),'o');