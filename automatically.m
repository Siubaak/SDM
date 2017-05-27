clear;
close all;
clc;
%% Read in the image pair
Fixed = imread ('D:\image\2fixed.jpg');
Moving = imread ('D:\image\2moving.jpg');
imshowpair(Fixed, Moving, 'montage');
title('Fixed & Moving');
Fixed = rgb2gray(Fixed);
Moving = rgb2gray(Moving);

%% Image registration
[optimizer, metric] = imregconfig('Monomodal');
Registered = imregister(Moving, Fixed, 'Similarity', optimizer, metric);
figure;
imshowpair(Registered, Fixed);
title('Image registration');

%% Image processing
se=strel('square',2);
G = Registered;
G1 = Fixed;
G = im2bw(G, 0.18);
G = ~G;
G = imerode(G,se);
G = ~G;
G1 = im2bw(G1, 0.18);
G1 = ~G1;
G1 = imerode(G1,se);
G1 = ~G1;

%% Find checkerboard
C = [0 0 0 0 1 1 1 1 1
     0 0 0 0 1 1 1 1 1
     0 0 0 0 1 1 1 1 1
     0 0 0 0 1 1 1 1 1
     1 1 1 1 1 1 1 1 1
     1 1 1 1 1 0 0 0 0
     1 1 1 1 1 0 0 0 0 
     1 1 1 1 1 0 0 0 0 
     1 1 1 1 1 0 0 0 0];
cp = zeros(1,2);
cp1 = zeros(1,2);
rc = size(G);
xt = 60;
yt = 120;
u = 0;
u1 = 0;
for i=xt:rc(1)-xt
    for j=yt:rc(2)-yt
        pp = 0;
        oo = 0;
        ii0 = 0;
        for i1=(i-4):(i+4)
            ii0 = ii0 + 1;
            jj0 = 0;
            for j1=(j-4):(j+4)
                jj0 = jj0 + 1;
                if G(i1,j1) == C(ii0,jj0)
                   pp = pp + 1; 
                end
                if G1(i1,j1) == C(ii0,jj0)
                   oo = oo + 1; 
                end
            end
        end
        if pp >= 77
            u = u + 1;
            cp(u,2) = i;
            cp(u,1) = j;
        end
        if oo >= 77
            u1 = u1 + 1;
            cp1(u1,2) = i;
            cp1(u1,1) = j;
        end
    end
end
figure;
imshow(Registered);
title('Registered');
hold on;
plot(cp(:,1),cp(:,2),'o');
figure;
imshow(Fixed);
title('Fixed');
hold on;
plot(cp1(:,1),cp1(:,2),'o');

%% Calculation
xy0 = mean(cp,1);
xy = mean(cp1,1);
dist = sqrt((xy0(1) - xy(1))^2 + (xy0(2) - xy(2))^2);
%pixelrate = 10 / sqrt((x1 - x2)^2 + (y1 - y2)^2);
pixelrate = 1 / 2.5;
realdist = pixelrate * dist


