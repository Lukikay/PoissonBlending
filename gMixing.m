function output = gMixing(imgSource, maskSource, imgDestination, maskDestination)


indexImgSource = find(maskSource); % Get the linear index of mask in the images
indexImgDestination = find(maskDestination);
nPixels = size(indexImgSource, 1); % Get the pixels quantity of mask

indexOfSelected = zeros(size(imgSource)); % Label each selected pixel with linear index
for i = 1: nPixels
    indexOfSelected(indexImgSource(i)) = i;
end

A = delsq(indexOfSelected); % Create an adjacency matrix, finite difference laplacian, sparse matrix

b = zeros(nPixels, 1);
pqDestination = zeros(nPixels, 4); % east, west, south, north
pqSource = zeros(nPixels, 4);

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
            % f_p-f_q
            pqDestination(indexB, 1) = imgDestination(y, x)-imgDestination(y, x+1); % Gradient via east
            pqDestination(indexB, 2) = imgDestination(y, x)-imgDestination(y, x-1); % Gradient via west
            pqDestination(indexB, 3) = imgDestination(y, x)-imgDestination(y+1, x); % Gradient via south
            pqDestination(indexB, 4) = imgDestination(y, x)-imgDestination(y-1, x); % Gradient via north
            
            indexB = indexB + 1; 
            
        end
    end
end


indexB = 1; 
for x = 1: size(imgSource, 2)
    for y = 1: size(imgSource, 1)
        
        if maskSource(y, x) == 1
            % g_p-g_q
            pqSource(indexB, 1) = imgSource(y, x)-imgSource(y, x+1); % Gradient via east
            pqSource(indexB, 2) = imgSource(y, x)-imgSource(y, x-1); % Gradient via west
            pqSource(indexB, 3) = imgSource(y, x)-imgSource(y+1, x); % Gradient via south
            pqSource(indexB, 4) = imgSource(y, x)-imgSource(y-1, x); % Gradient via north
            
            indexB = indexB + 1;
            
        end
    end
end

% Check each pixel and each gradient, which has a stronger gradient and
% take it. So compare the absolute values with each pixels' four neighbours 
% gradients, and add the larger one to the guidance field corresponding.
for i = 1: nPixels
    for j = 1: 4
        if abs(pqDestination(i, j)) > abs(pqSource(i, j))
            b(i) = b(i) + pqDestination(i, j);
        else
            b(i) = b(i) + pqSource(i, j);
        end
    end
end


x = A\b;

gMixingImg = imgDestination; % Put new pixels to the destination image
for i = 1: nPixels
    gMixingImg(indexImgDestination(i)) = x(i);
end

output = gMixingImg;

end


