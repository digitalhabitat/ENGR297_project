% Michael Miller
% ENGR 297 - MATLAB Project Part 2
% April 26, 2016

clear all;
close all;
clc;

bone = imread('mouse_femur.jpg');

binary = zeros(496);

lower = input('enter lower threshold percentage limit[0-100]: ')/100;
upper = input('enter upper threshold percentage limit[0-100]: ')/100;

%Determine brightest pixel in image for relative threshold percentage
max_pixel = double(max(max(bone(:,:,1))));

%Add Ones to binary(i,j) for pixels that are within thresholds
binary((bone(:,:,1)>lower*max_pixel)==(bone(:,:,1)<upper*max_pixel))=1;

%counting how many pixels = 1 in binary data set
binary_pixel_count=(numel(binary(binary == 1)));

%Cross-sectional area estimation
binary_pixel_count
area_um2 = binary_pixel_count*(12)^2
area_mm2 = area_um2 *(1/1000)^2

%Compare im2bw function with binary
test = bone;
test(test(:,:,:)>=upper*max_pixel)=0;
test = im2bw(test,lower*max_pixel/255);

%test_pixel_count
test_pixel_count = (numel(test(test == 1)));

%Error Check
errors=sum(sum(test ~= binary));

figure(1)
imshow(bone)
title('Bone')

figure(2)
imshow(binary)
title('Binary')

figure(3)
imshow(test)
title('Test')

% EXAMPLE
% enter lower threshold percentage limit: 75
% enter upper threshold percentage limit: 95
% 
% binary_pixel_count =
% 
%         2365
% 
% 
% area_um2 =
% 
%       340560
% 
% 
% area_mm2 =
% 
%     0.3406
% 

