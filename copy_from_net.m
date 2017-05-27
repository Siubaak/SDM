close all;
clc;
I=imread('D:\image\2moving.jpg');
bw=rgb2gray(I);
figure;imshow(bw);
 bw=im2bw(bw, 0.18);
 figure;imshow(bw);
bw=~bw;
 se=strel('rectangle',[3,3]);
 bw=imerode(bw,se);
  figure;imshow(bw);
  bw=bwfill(bw,'hole');
%寻找不包括孔连通域的边缘，并且把每个连通域的边界描出来
[B,L] = bwboundaries(bw,4); 
figure,imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
 boundary = B{k};
 plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end
% 找到每个连通域的质心
stats = regionprops(L,'Area','Centroid');
% 循环历遍每个连通域的边界
for k = 1:length(B)
  % 获取一条边界上的所有点
  boundary = B{k};
  % 计算边界周长
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  % 获取边界所围面积
  area = stats(k).Area;
  % 计算匹配度
  metric =80*area/perimeter^2;
  % 要显示的匹配度字串
  metric_string = sprintf('%2.2f',perimeter);
  % 标记出匹配度接近1的连通域
  
  text(boundary(1,2)-35,boundary(1,1)+13,...
    metric_string,'Color','black',...
'FontSize',12,'FontWeight','bold');
 
end