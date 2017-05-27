clear;
clc;
%similarity-Non reflective similarity transformation consisting of translation, rotation, and scale.
%%Step 1: Read the images
%%Step 2: Choose Control Points in the images
%%Step 3: Save the Control Point Pairs to the MATLAB workspace
%%Step 4: Fine-Tune the Control Point Pair Placement (Optional)
%%Step 5: Specify the type of transformation and infer its parameters
%%Step 6: Transform the unregistered image
%Step 1
Fixed = imread('D:\image\image1.png');
Moving = imread('D:\image\image2.png');

%Step 2 & Step 3
cpselect(Moving, Fixed); %chose the control points

%Step 4 (Neglected)
%Step 5
mytform = fitgeotrans(movingPoints, fixedPoints, 'projective');      %cp2tform is not recommended. Use fitgeotrans instead.(yau 14:19 11/08/2015)

%Step 6
Registered = imwarp(Moving, mytform);                      %imtransform is not recommended. Use imwarp instead.(yau 14:21 11/08/2015)

%Show the image
figure,
imshowpair(Registered,Fixed,'blend','Scaling','joint');