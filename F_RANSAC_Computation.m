function [F] = F_RANSAC_Computation(xs, xss, n_iters, thresh)

    % xs  : N*3 matrix of normalized 2D homogeneous image coordinates matched from image 1
    % xss : N*3 matrix of normalized 2D homogeneous image coordinates matched from image 2
    % n_iters : Total number of iterations in RANSAC
    % thresh : Inlier threshold 
    
    max_inliers = -Inf;
    inliers = [];
    
    for i = 1:n_iters
        
        % Select a random sample of 8 coordinates from the matched
        % coordinates
        indices = randsample(size(xs, 1), 8);
        
        % Computing Fundamental Matrix from the chosen 8 points
        Fa = F_Eight_Point(xs(indices,:), xss(indices,:));
        
        % Calculating the error 
        err = sum((xss .* (Fa * xs')'),2);
        
        % Counting the number of inliers
        n_inliers = size( find(abs(err) <= thresh) , 1);

        if n_inliers > max_inliers
            max_inliers = n_inliers;
            F = Fa;
        end
    end
end