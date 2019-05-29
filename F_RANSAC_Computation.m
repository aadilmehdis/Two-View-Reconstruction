function [F] = F_RANSAC_Computation(xs, xss, n_iters, thresh)

    % xs  : N*3 matrix of normalized 2D homogeneous image coordinates matched from image 1
    % xss : N*3 matrix of normalized 2D homogeneous image coordinates matched from image 2
    % n_iters : Total number of iterations in RANSAC
    % thresh : Inlier threshold 
    
    max_inliers = -Inf;
    
    for i = 1:n_iters
        
        % Select a random sample of 8 coordinates from the matched
        % coordinates
        indices = randsample(size(xs, 1), 8);
        
        % Computing Fundamental Matrix from the chosen 8 points
        Fa = F_Eight_Point(xs(indices,:), xss(indices,:));
        
        % Counting the number of inliers
        n_inliers = 0;

        for j = 1:size(xs, 1)
            if abs(xs(j,:) * Fa * xss(j,:)') <= thresh
                n_inliers = n_inliers + 1;
            end
        end
        
        % Check if the number of inliers in this iteration is the best
        % uptil now
        if n_inliers > max_inliers
            max_inliers = n_inliers;
            F = Fa;
        end
    end
end