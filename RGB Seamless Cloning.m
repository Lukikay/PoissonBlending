clear;
close all;


imgSource = im2double(imread('images\Whale.jpg'));
%imgSource = im2double(imread('images\01.jpg'));
%imgSource = im2double(imread('images\Pure.jpg'));
set(gcf, 'Position', [200 50 1500 900]);
sgtitle('RGB Seamless Cloning')
subplot(2,3,1);
imshow(imgSource);
title('Please specify polygonal ROI');
pause(2);


maskSource = roipoly(imgSource);
subplot(2,3,1);
title('Source image');
hightlightSource = cat(3,maskSource*0.2,maskSource*0.2,maskSource*0.2) + imgSource*0.8;
subplot(2,3,4);
imshow(hightlightSource);
title('Mask of Source image');


imgDestination = im2double(imread('images\Sky.jpg'));
%imgDestination = im2double(imread('images\02.jpg'));
subplot(2,3,2);
imshow(imgDestination);
title('Please specify blending position');
[xTarget, yTarget] = ginput(1);
title('Destination image');


maskDestination = maskDest(maskSource, imgDestination, xTarget, yTarget);
highlightDesst = cat(3,maskDestination*0.2,maskDestination*0.2,maskDestination*0.2) + imgDestination*0.8;
subplot(2,3,5);
imshow(highlightDesst);
title('Mask of Destination image');
drawnow;


gImportingR = gImporting(imgSource(:,:,1), maskSource, imgDestination(:,:,1), maskDestination);
gImportingG = gImporting(imgSource(:,:,2), maskSource, imgDestination(:,:,2), maskDestination);
gImportingB = gImporting(imgSource(:,:,3), maskSource, imgDestination(:,:,3), maskDestination);
taska = cat(3,gImportingR,gImportingG,gImportingB);
subplot(2,3,3);
imshow(taska);
title('Result of Importing Gradients');
drawnow;


gMixingR = gMixing(imgSource(:,:,1), maskSource, imgDestination(:,:,1), maskDestination);
gMixingG = gMixing(imgSource(:,:,2), maskSource, imgDestination(:,:,2), maskDestination);
gMixingB = gMixing(imgSource(:,:,3), maskSource, imgDestination(:,:,3), maskDestination);
taskb = cat(3,gMixingR,gMixingG,gMixingB);
subplot(2,3,6);
imshow(taskb);
title('Result of Mixing Gradients');


