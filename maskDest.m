function maskDest = maskDest(maskSource, imgDestination, xTarget, yTarget)

[yMaskSource, xMaskSource] = find(maskSource);

ulMaskBox = [min(yMaskSource), min(xMaskSource)]; %upper left
lrMaskBox = [max(yMaskSource), max(xMaskSource)]; %lower right

centerPoint = mean([ulMaskBox; lrMaskBox]);
halfHeight = centerPoint(1)-min(yMaskSource);
halfWidth = centerPoint(2)-min(xMaskSource);
boxMask = maskSource(min(yMaskSource):max(yMaskSource), min(xMaskSource):max(xMaskSource));

% Check whether the ROI that mapping to the destination images has exceed its
% boundaries, if exceeded, then move the ROI inside the image.
if (yTarget + halfHeight > size(imgDestination, 1) - 2) 
    yTarget = size(imgDestination, 1) - halfHeight - 2;
end

if (yTarget - halfHeight < 2)
    yTarget = halfHeight + 2;
end

if (xTarget + halfWidth > size(imgDestination, 2) - 2)
    xTarget = size(imgDestination, 2) - halfWidth -2;
end

if (xTarget - halfWidth < 2)
    xTarget = halfWidth + 2;
end

xTarget = round(xTarget);
yTarget = round(yTarget);

% Create the mask for the destination image.
maskDest = zeros(size(imgDestination,1), size(imgDestination,2));
maskDest(yTarget-floor(halfHeight):yTarget-floor(halfHeight)+halfHeight*2,...
    xTarget-floor(halfWidth):xTarget-floor(halfWidth)+halfWidth*2) = boxMask;

end