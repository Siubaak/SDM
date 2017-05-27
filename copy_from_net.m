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
%Ѱ�Ҳ���������ͨ��ı�Ե�����Ұ�ÿ����ͨ��ı߽������
[B,L] = bwboundaries(bw,4); 
figure,imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
 boundary = B{k};
 plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end
% �ҵ�ÿ����ͨ�������
stats = regionprops(L,'Area','Centroid');
% ѭ������ÿ����ͨ��ı߽�
for k = 1:length(B)
  % ��ȡһ���߽��ϵ����е�
  boundary = B{k};
  % ����߽��ܳ�
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  % ��ȡ�߽���Χ���
  area = stats(k).Area;
  % ����ƥ���
  metric =80*area/perimeter^2;
  % Ҫ��ʾ��ƥ����ִ�
  metric_string = sprintf('%2.2f',perimeter);
  % ��ǳ�ƥ��Ƚӽ�1����ͨ��
  
  text(boundary(1,2)-35,boundary(1,1)+13,...
    metric_string,'Color','black',...
'FontSize',12,'FontWeight','bold');
 
end