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


[numMatches, inlier] = sift_mosaic;