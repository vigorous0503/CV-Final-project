function [ IMAGES , DESCRIPTOR, POINT_IN_IMG] = FindTheRef( IMAGES, DESCRIPTOR ,POINT_IN_IMG )

stack_IMG = IMAGES;
stack_DESC = DESCRIPTOR;
stack_POINT = POINT_IN_IMG;

% match = zeros( length(stack_DESC),length(stack_DESC) );
test_num = 0;
test_match = 0;
% while test_num == 0 || test_match ~=  length(stack_DESC)-1
while 1
    if test_num~=0 && test_match ==  length(stack_DESC)-1
        break
    end
    match = zeros( length(stack_DESC),length(stack_DESC) );
    
    num = zeros( 1, length(stack_DESC) );
    for j = 1 : length(stack_DESC)
        
        DESCRIPTOR = stack_DESC;
        DESCRIPTOR( j ) = [];
        POINT_IN_IMG = stack_POINT;
        POINT_IN_IMG( j ) = [];
        
        for i = 1 : length(DESCRIPTOR)
            
            [M, ~] = vl_ubcmatch(stack_DESC{j}, DESCRIPTOR{i});
            M = M';
            if length(stack_DESC) ==4
                TRANSFORM = RANSACFit(stack_POINT{j}, POINT_IN_IMG{i}, M, 200, ceil(0.2 * size(M, 1)), 30, floor(0.36 * size(M, 1)));
            else
                TRANSFORM = RANSACFit(stack_POINT{j}, POINT_IN_IMG{i}, M);
            end
            if TRANSFORM(1,2) ~= 0
                num( j ) = num( j ) + 1;
                if j>i
                    match( j,i) = 1;
                else
                    match( j,i+1) = 1;
                end
            end
        end
    end
    test_num = sum( num==length(stack_DESC)-1);
    [~,index ] = max(num);
    test_match = sum( match( :, index));
end

IMAGES = cell( 1,length(stack_IMG) );
DESCRIPTOR = cell( 1,length(stack_DESC) );
POINT_IN_IMG = cell( 1,length(stack_POINT) );
[~,index1] = max(num);
position_ref = ceil( median(1 : length(stack_IMG)));
IMAGES{ position_ref } = stack_IMG{index1};
DESCRIPTOR{ position_ref } = stack_DESC{index1};
POINT_IN_IMG{ position_ref } = stack_POINT{index1};

% ref-right
position = position_ref;
n = 1;
while position ~= length(stack_IMG)
    if n ==1
        
        [~,index2] = min(num);
        IMAGES{ position+1 } = stack_IMG{index2};
        DESCRIPTOR{ position+1 } = stack_DESC{index2};
        POINT_IN_IMG{ position+1 } = stack_POINT{index2};
        num( index2 ) = 7;
        n = n+1;
        position = position + 1;
    else
        
        index3 = find(match( index2 ,: ) ==1);
        index3(index3==5) = [];
        delet = find( num == 7 );
        a = ismember( index3, delet);
        index3(a) = [];
        [~, index4] = min(num( index3 ));
        index4 = index3(index4);
        IMAGES{ position+1 } = stack_IMG{index4};
        DESCRIPTOR{ position+1 } = stack_DESC{index4};
        POINT_IN_IMG{ position+1 } = stack_POINT{index4};
        num( index4 ) = 7;
        index2 = index4;
        n = n+1;
        position = position + 1;
    end
end
% left-ref
position = position_ref;
n = 1;
while position ~= 1
    if n ==1
        
        [~,index2] = min(num);
        IMAGES{ position - 1 } = stack_IMG{index2};
        DESCRIPTOR{ position -1 } = stack_DESC{index2};
        POINT_IN_IMG{ position - 1 } = stack_POINT{index2};
        num( index2 ) = 7;
        n = n+1;
        position = position - 1;
    else
        
        index3 = find(match( index2 ,: ) ==1);
        index3(index3==5) = [];
        delet = find( num == 7 );
        a = ismember( index3, delet);
        index3(a) = [];
        [~,index4] = min(num( index3 ));
        index4 = index3(index4);
        IMAGES{ position - 1 } = stack_IMG{index4};
        DESCRIPTOR{ position -1 } = stack_DESC{index4};
        POINT_IN_IMG{ position - 1 } = stack_POINT{index4};
        num( index4 ) = 7;
        index2 = index4;
        n = n+1;
        position = position - 1;
    end
end
end