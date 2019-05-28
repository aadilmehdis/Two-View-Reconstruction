function [T] = getNormalizationTransformMtx(X)    
    % X: coordinates of the matched points
    
    % T: normalization transform matrix
    
    % Calculating the mean along the x and y coordinates for the given
    % points
    mu = [mean(X(:,1)), mean(X(:,2))];
    
    % Calculating the distance from the center of the of the image for the
    % given points
    distance = sqrt( (X(:,1) - mu(1)).^2 + (X(:,2) - mu(2)).^2 );
    d = mean(distance);
    
    % Constructing T
    % Transforming the points so that the center of mass of the points lie
    % on (0, 0)
    % Scale the image so the the coordinates of any point lie in the range
    % [-1 1]

    T = [    1.44/d,     0,    -1.44/d * mu(1);
               0,   1.44/d,    -1.44/d * mu(2);
               0,        0,                  1;
         ];
end