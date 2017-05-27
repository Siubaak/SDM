clear;
close all;
clc;
%% Read in the image pair
Fixed = imread ('D:\image\Fixed.png');
Moving = imread ('D:\image\Moving.png');
Fixed = rgb2gray(Fixed);
Moving = rgb2gray(Moving);
figure;
imshow(Fixed);

%% Grey optimization
gopmin = min(min(Fixed));
gopmax = max(max(Fixed));
rcgo = size(Fixed);
for q = 1:rcgo(1)
    for w = 1:rcgo(2)
        if Fixed(q,w) == gopmin
            Fixed(q,w) = 0;
        else
            if Fixed(q,w) == gopmax
                 Fixed(q,w) = 255;
            else
                 Fixed(q,w) = round((Fixed(q,w) - gopmin) / (gopmax - gopmin) * 255);
            end
        end
    end
end

figure;
imshow(Fixed);