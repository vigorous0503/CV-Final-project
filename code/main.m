%% set path

clear all;close all;
addpath('data');
addpath('vlfeat-0.9.20-bin');
run('vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup');

%% Load a list of images

imgList = dir('./data/*.jpg');

IMAGES = cell(1, length(imgList));
for i = 1 : length(imgList),
    IMAGES{i} = imread(['./data/' imgList(i).name]);
end

%% classification

S=size(imgList);
S=S(1); 
num_matches=zeros(S,S);

for a=1:S
    
    for b=1:S
        if (a<=b)
          
            [numMatches, inlier] = sift_mosaic(IMAGES{a}, IMAGES{b});
                     
            num_matches(a,b)=numMatches; %存取到底有多少matches
                   
            num_inlier(a,b)=inlier;
        end
        
    end
    
end

num_matches=num_matches'+num_matches;
num_inlier=num_inlier'+num_inlier;

for i=1:S
    
    num_matches(i,i)=num_matches(i,i)/2;
    num_inlier(i,i)=num_inlier(i,i)/2;
    
end

compute=zeros(S,S); % computer用來存取哪些東西會相連

for i=1:S
    for j=1:S
        
        if (i<=j) %(剛剛算過的就不用算了,免得浪費計算)
            
            compute(i,j)=num_inlier(i,j)/num_matches(i,j);
            
            if (compute(i,j)>=0.6&&num_matches(i,j)>60)
                
                compute(i,j)=1;
                
            else
                
                compute(i,j)=0;
                
            end
            
        end
    end
end


compute=compute'+compute;

for i=1:S
    
    compute(i,i)=1;
    
end

A=group(compute,1);

Z=check(A,S,compute) ;

%% sorting & stitch each Panorama

for i=1:size(Z,1)
    
    len=length(find(Z(i,:)));
    if (Z(i,1)~=0&&len>1)
         Stitch(Z(i,:),IMAGES,i );
    end
    
end



