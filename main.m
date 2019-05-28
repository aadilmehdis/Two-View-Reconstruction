% Reading the images
img1 = rgb2gray(imread('img1.png'));
img2 = rgb2gray(imread('img2.png'));

%%  Feature Extraction and Matching 

% Obtain keypoints using SURF from the images 
kp1 = detectSURFFeatures(img1);
kp2 = detectSURFFeatures(img2);

% Extract features descriptors from the keypoints
[f1,vpts1] = extractFeatures(img1,kp1);
[f2,vpts2] = extractFeatures(img2,kp2);

% Match the corresponding points
indexPairs = matchFeatures(f1,f2);
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

% Obtain the coordinates of the matched points
coordsPoints1 = padarray(matchedPoints1.Location', 1, 1, 'post')';
coordsPoints2 = padarray(matchedPoints2.Location', 1, 1, 'post')';

% Visualize cadidate matches
figure; ax = axes;
showMatchedFeatures(img1,img2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

%% Get Normalization Transform

T1 = getNormalizationTransformMtx(coordsPoints1);
T2 = getNormalizationTransformMtx(coordsPoints2);

%% Normalizing the Point's Coordinates

a = (T*coordsPoints1')';
b = (T*coordsPoints2')';

%% Fundamental Matrix Estimation

Fnormalized = F_Eight_Point(a(1:8,:), b(1:8,:));
F = T1' * Fnormalized * T2;

%% Essential Matrix Computation from Fundamental Matrix

% Calibration Matrix
K = [558.7087, 0.0, 310.3210; 0.0, 558.2827, 240.2395; 0.0, 0.0, 1.0];

Eapproximate = K' * F * K;

% Forcing the constraints of the svd decomposition's diagonal values as
% 1,1,0

[U, S, V] = svd(Eapproximate);
E = U * diag([1,1,0]) * V';

%% Obtaining R and t from Essential Matrix

% Z = [0,1,0;-1,0,0;0,0,0];
% W = [0,-1,0;1,0,0;0,0,0];
% 
% S1B = U*Z*U';
% S2B = U*Z'*U';
% R1  = U*W*V';
% R2  = U*W'*V';
% 
% E1 = S1B*R1;
% E2 = S2B*R1;
% E3 = S1B*R2;
% E4 = S2B*R2;

% [relativeOrientation,relativeLocation] = relativeCameraPose(E,K,inlierPoints1,inlierPoints2);

[R, t] = decomposeEssentialMatrix(E, coordsPoints1', coordsPoints2', K);





