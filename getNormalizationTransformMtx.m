function [T] = getNormalizationTransformMtx(I)
    % I: image for which the normalization/conditioning transform is to be
    % calculated
    
    % T: normalization transform matrix
    
    % Calculating the mean of the image
    y = 1:size(I, 1);
    x = 1:size(I, 2);
    mu = [mean(x), mean(y)];
    
    
    % Calculating the average distance of all the image points from the
    % center of the image
    imageCenter = size(I)./2;
    distance = sqrt( (y.' - imageCenter(1)).^2 + (x - imageCenter(2)).^2 );
    d = mean2(distance);
    
    % Constructing T

    T = [ 1.44/d,      0, -1.44/d * mu(1);
               0, 1.44/d, -1.44/d * mu(2);
               0,      0,               1;
         ];
    
    % Normalizing the Point's Cooridinates to obtain a Well Condition svd
    % and improve the stability
    
    % Transforming the points so that the center of mass of the points lie
    % on (0, 0)
    
    
    
    % Scale the image so the the coordinates of any point lie in the range
    % [-1 1]
end