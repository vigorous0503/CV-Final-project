
function Stitch(class,IMAGES,name)

%% Load a list of images (Change file name if you want to use other images)
imgList = find(class);
num = length(imgList);
% imgList = dir('./data/2016-01-12 12.52.*.jpg');

saveFileName = ['./result/',int2str(name),'.jpg'];

%% Add path
for i = 1 : num
    %% Resize to make memory efficient
    if max(size(IMAGES{class(i) })) > 1000 || length(imgList) > 10,
        IMAGES{class(i)} = imresize(IMAGES{class(i)}, 0.6);
    end
end
disp('Images loaded. Beginning feature detection...');
%% Feature detection
DESCRIPTOR = cell(1, length(imgList));
POINT_IN_IMG = cell(1, length(imgList));
for i = 1 : length(imgList),
    if ndims(IMAGES{class(i)})==3
        I = single(rgb2gray(IMAGES{class(i)}));
    else
        I = single(IMAGES{class(i)});
    end
    [f,d] = vl_sift(I) ;
    POINT_IN_IMG{i} = double(f(1:2,:)');
    DESCRIPTOR{i} = double(d);
end

image = cell( 1, num );
for i = 1 : num
    image{ i } = IMAGES{class(i)};
end

if length(imgList)~=2
    [ image , DESCRIPTOR, POINT_IN_IMG] = FindTheRef( image, DESCRIPTOR ,POINT_IN_IMG );
end
%% Compute Transformation
TRANSFORM = cell(1, length(imgList)-1);
for i = 1 : (length(imgList)-1),
    disp(['fitting transformation from ' num2str(i) ' to ' num2str(i+1)])
    [M, ~] = vl_ubcmatch(DESCRIPTOR{i}, DESCRIPTOR{i+1});
    M = M';
    TRANSFORM{i} = RANSACFit(POINT_IN_IMG{i}, POINT_IN_IMG{i+1}, M);
end

%% Make Panoramic image
disp('Stitching images...')
MultipleStitch(image, TRANSFORM, saveFileName);
disp(['The completed file has been saved as ' saveFileName]);
figure,imshow(imread(saveFileName));
end