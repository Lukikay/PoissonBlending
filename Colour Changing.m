clear;
close all;

%%%%%%% Type 1: Environment Colour Discard
imgSource = im2double(imread('images\FantasyCandies.jpg'));
set(gcf, 'Position', [200 50 1500 900]);
sgtitle('Local Colour Changes')
subplot(2,3,1);
imshow(imgSource);
title('Please specify polygonal ROI');
pause(2);


maskSource = roipoly(imgSource);
subplot(2,3,1);
title('Original image');
hightlightSource = maskSource*0.2 + imgSource*0.8;
subplot(2,3,2);
imshow(hightlightSource);
title('Mask');
drawnow;


maskDestination = maskSource;
imgDestination = rgb2gray(imgSource);

gImportingR = gImporting(imgSource(:,:,1), maskSource, imgDestination(:,:,1), maskDestination);
gImportingG = gImporting(imgSource(:,:,2), maskSource, imgDestination(:,:,1), maskDestination);
gImportingB = gImporting(imgSource(:,:,3), maskSource, imgDestination(:,:,1), maskDestination);
taska = cat(3,gImportingR,gImportingG,gImportingB);
subplot(2,3,3);
imshow(taska);
title('Type 1: Environment Colour Discard');
drawnow;


%%%%%%% Type 2: Local Colour Change
imgSource_2 = im2double(imread('images\FantasyCandies_2.jpg'));
subplot(2,3,4);
imshow(imgSource_2);
title('Please specify polygonal ROI');
pause(2);


maskSource_2 = roipoly(imgSource_2);
subplot(2,3,4);
title('Original image');
hightlightSource_2 = maskSource_2*0.2 + imgSource_2*0.8;
subplot(2,3,5);
imshow(hightlightSource_2);
title('Mask');
drawnow;


maskDestination_2 = maskSource_2;
imgColorChange(:,:,1) = imgSource_2(:,:,1);
% Switch colour channels to change colour
imgColorChange(:,:,2) = imgSource_2(:,:,3); 
imgColorChange(:,:,3) = imgSource_2(:,:,2);


gImportingR = gImporting(imgColorChange(:,:,1), maskSource_2, imgSource_2(:,:,1), maskDestination_2);
gImportingG = gImporting(imgColorChange(:,:,2), maskSource_2, imgSource_2(:,:,2), maskDestination_2);
gImportingB = gImporting(imgColorChange(:,:,3), maskSource_2, imgSource_2(:,:,3), maskDestination_2);
taskb = cat(3,gImportingR,gImportingG,gImportingB);
subplot(2,3,6);
imshow(taskb);
title('Type 2: Local Colour Change');


