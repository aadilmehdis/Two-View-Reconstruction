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

F = F_Eight_Point(a, b);

