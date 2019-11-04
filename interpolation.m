function output = interpolation(grayImg, mask)


indexOfImg = find(mask); % Get the linear index of mask in the image
nPixels = size(indexOfImg, 1); % Get the pixels quantity of mask

indexOfSelected = zeros(size(grayImg)); % Label each selected pixel with linear index
for i = 1: nPixels
    indexOfSelected(indexOfImg(i)) = i;
end

A = delsq(indexOfSelected); % Create an adjacency matrix, finite difference laplacian, sparse matrix

b = zeros(nPixels, 1);

indexB = 1; 
for x = 1: size(grayImg, 2)
    for y = 1: size(grayImg, 1)
        
        if mask(y, x) == 1           

            if mask(y, x+1) == 0 % east pixel exceed the ROI
                b(indexB) = b(indexB) + grayImg(y, x+1);
            end
            
            if mask(y, x-1) == 0 % west pixel exceed the ROI
                b(indexB) = b(indexB) + grayImg(y, x-1);
            end             
            
            if mask(y+1, x) == 0 % south pixel exceed the ROI
                b(indexB) = b(indexB) + grayImg(y+1, x);
            end            
            
            if mask(y-1, x) == 0 % north pixel exceed the ROI
                b(indexB) = b(indexB) + grayImg(y-1, x);
            end            
            
            indexB = indexB + 1;
            % No guidance field now
        end
    end
end

x = A\b;

interpolationImg = grayImg; % Put new pixels to the image
for i = 1: nPixels
    interpolationImg(indexOfImg(i)) = x(i);
end

output = interpolationImg;

end

