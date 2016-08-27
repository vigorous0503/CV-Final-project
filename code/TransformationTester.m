%% Clear all
 close all;clear; 
addpath('data');
addpath('vlfeat-0.9.20-bin');
run('vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup');
%% Load image

path_imgDB = './data/';
addpath(path_imgDB);

imgFiles = dir(path_imgDB);
imgNamList = {imgFiles(~[imgFiles.isdir]).name};

% img1 = imread('./data/uttower1.jpg');
% img2 = imread('./data/uttower2.jpg');
path1 = ['./data/',imgNamList{1,1}];
path2 = ['./data/',imgNamList{1,2}];
img1 = imread(path1);
img2 = imread(path2);
% img1 =  imresize(img1,0.25);
% img2 =  imresize(img2,0.25);

%% Feature detection
I = single(rgb2gray(img1));
[f,d] = vl_sift(I) ;
pointsInImage1 = double(f(1:2,:)');
% desc1 = double(d');
desc1 = double(d);

I = single(rgb2gray(img2));
[f,d] = vl_sift(I) ;
pointsInImage2 = double(f(1:2,:)');
% desc2 = double(d');
desc2 = double(d);


%% Matching
[matches, scores] = vl_ubcmatch(desc1, desc2);
matches = matches';

% M = SIFTSimpleMatcher(desc1, desc2);

%% Transformation
% [ T_im1, best_pts ] = ransac( points1, points2, 'aff_lsq', 3 );
maxIter = 200;
maxInlierErrorPixels = .05*size(img1,1);
seedSetSize = max(3, ceil(0.1 * size(matches, 1)));
minInliersForAcceptance = ceil(0.3 * size(matches, 1));
H = RANSACFit(pointsInImage1, pointsInImage2, matches, maxIter, seedSetSize, maxInlierErrorPixels, minInliersForAcceptance);

%% Make Panoramic image
saveFileName = 'uttower_pano.jpg';
PairStitch(img1, img2, H, saveFileName);
disp(['Panorama was saved as uttower_pano.jpg' saveFileName]);
imshow(imread(saveFileName));
