%% Clearing Memory
clear all;
close all;
clc;

%% Reading the images
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

a = (T1*coordsPoints1')';
b = (T2*coordsPoints2')';

%% Fundamental Matrix Estimation

% With RANSAC
Fnormalized = F_RANSAC_Computation(a, b, 1000, 0.05);

F = T2' * Fnormalized * T1;

%% Essential Matrix Computation from Fundamental Matrix

% Calibration Matrix
K = [558.7087, 0.0, 310.3210; 0.0, 558.2827, 240.2395; 0.0, 0.0, 1.0];

Eapproximate = K' * F * K;

% Forcing the constraints of the svd decomposition's diagonal values as
% 1,1,0

[U, S, V] = svd(Eapproximate);
E = U * diag([1,1,0]) * V';

% Uncomment the following line without forcing the svd constraint on E 
% E = Eapproximate;

%% Obtaining R and t from Essential Matrix

intrinsics = cameraIntrinsics([558.7087, 558.2827],[310.3210, 240.2395],[480, 640]);

[R,t] = relativeCameraPose(E,intrinsics,matchedPoints1,matchedPoints2);
t = t';

%% Linear/Algebraic Triangulation

P1 = K * [eye(3), [0; 0; 0]];
P2 = K * R * [eye(3), t];

X_1 = algebraicTriangulation(coordsPoints1', coordsPoints2', P1, P2);
X_1 = X_1 ./ repmat(X_1(4,:), 4, 1);

scatter3(X_1(1,:), X_1(2,:), X_1(3,:),17, 'MarkerFaceColor',[0 .75 .75]);
hold on;

xlabel('X');
ylabel('Y');
zlabel('Z');
% title('Camera 1: RED | Camera 2: BLUE');
axis('equal');
axis([-5 5 -5 5 -15 1])

hold on;
plotCameraFrustum(eye(3), [0; 0; 0], 'r');
hold on;
plotCameraFrustum(R, R*t,'b');



