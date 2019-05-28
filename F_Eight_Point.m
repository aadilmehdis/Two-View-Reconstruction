function [F] = F_Eight_Point(a, b)
    % a, b homogeneous coordinates of the image pixels
    % Dimension of a, b is N*3
    
    % A is the equation matrix of dimension N*9
    for i = 1:size(a,1)
        A(n, :) = kron(b(i,:),a(i,:));
    end
   
    % SVD of A
    [U, S, V] = svd(A);
    
    % F is the eigenvector corresponding to the smallest Eigen Value
    F = reshape(V(:,9), 3, 3)';
    
    % F computed above may not be a rank(2) matrix. 
    % F has to be rank(2), so set the smallest Eigen Value of the svd of F
    % to zero and recompute F
    [Uf, Sf, Vf] = svd(F);
    F = Uf * [Sf(1,1), Sf(2,2), 0]' * Vf';
    
end