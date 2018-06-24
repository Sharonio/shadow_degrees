close all; clc; clear all; 

originalImage = imread('trapezePic.png');
imshow(originalImage)

hold off


corners = ginput(4)

yCrop = imcrop(originalImage,[min(corners) max(corners)]);
imshow(yCrop)

imageCorners = size(yCrop)
imageCorners = imageCorners(1:2)

cornersAdjusted = corners - min(corners) + 1

plot(cornersAdjusted(:,1),cornersAdjusted(:,2),'r', 'LineWidth',3)
set(gca,'Ydir','reverse')
ylim([0 imageCorners(1)])
xlim([0 imageCorners(2)])

movingPoints = cornersAdjusted(1:4,:)
fixedPoints = [0 0; imageCorners(2) 0 ; imageCorners(2) imageCorners(1); 0 imageCorners(1)]

hold on

tform = fitgeotrans(movingPoints,fixedPoints,'projective')
rectangle = imwarp(yCrop,tform,'OutputView', imref2d(size(yCrop)))
imshow(rectangle)