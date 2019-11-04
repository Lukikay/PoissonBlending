function output = gImporting(imgSource, maskSource, imgDestination, maskDestination)


indexImgSource = find(maskSource); % Get the linear index of mask in the images
indexImgDestination = find(maskDestination);
nPixels = size(indexImgSource, 1); % Get the pixels quantity of mask

indexOfSelected = zeros(size(imgSource)); % Label each selected pixel with linear index
for i = 1: nPixels
    indexOfSelected(indexImgSource(i)) = i;
end

A = delsq(indexOfSelected); % Create an adjacency matrix, finite difference laplacian, sparse matrix

b = zeros(nPixels, 1);

indexB = 1; 
for x = 1: size(imgDestination, 2)
    for y = 1: size(imgDestination, 1)
        
        if maskDestination(y, x) == 1

            if maskDestination(y, x+1) == 0 % east pixel exceed the ROI
                b(indexB) = b(indexB) + imgDestination(y, x+1);
            end
            
            if maskDestination(y, x-1) == 0 % west pixel exceed the ROI
                b(indexB) = b(indexB) + imgDestination(y, x-1);
            end             
            
            if maskDestination(y+1, x) == 0 % south pixel exceed the ROI
                b(indexB) = b(indexB) + imgDestination(y+1, x);
            end            
            
            if maskDestination(y-1, x) == 0 % north pixel exceed the ROI
                b(indexB) = b(indexB) + imgDestination(y-1, x);
            end            
            
            indexB = indexB + 1;

        end
    end
end

Laplacian = [0 -1 0; -1 4 -1; 0 -1 0]; % Laplacian kernal
imgSourceLap = conv2(imgSource, Laplacian, 'same');
v = imgSourceLap(indexImgSource); % Add Laplacian pixels(guidance field) in ROI to b
b = b + v;

x = A\b;

gImportingImg = imgDestination; % Put new pixels to the destination image
for i = 1: nPixels
    gImportingImg(indexImgDestination(i)) = x(i);
end

output = gImportingImg;

end

