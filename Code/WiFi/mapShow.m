function [ output_args ] = mapShow()

epsilon = 7;
r = 50;
% displays the map of IIT ropar and the bin locations
formatSpec = '%C%f%f%f';
T = readtable('binData.txt','Delimiter',',','Format',formatSpec);
data = table2array(T(:,2:end));

%display IIT Ropar map
hold on;
axis([0 1 0 1]);
placeImage = imread('iit_ropar.png');
[m,n,~] = size(placeImage);
imagesc([0.0,1.0],[0.0,1.0],placeImage);

scaleX = 1/450;
scaleY = 1/250;

%iterate over all points and display the image
for i = 1:size(data,1)
    getCoverageArea(data(i,1),data(i,2),data(i,3),r,epsilon,scaleX,scaleY);
end

%plot the bins
for i = 1:size(data,1)
    plot(data(i,1),data(i,2),'r*'); % plot the point
end


end

