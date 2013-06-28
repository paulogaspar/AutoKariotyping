%   AII Project
%   Computerized kariotyping support
%   Author:
%       -Paulo Gaspar     36503
%       -Patrick Marques  36086
%   Date:
%       26/01/2009


function [ chromossomeStructures ] = getSkeleton( chromossomeStructures )

for z=1:numel(chromossomeStructures),
    
    %get skeleton in an one pixel line
    skeleton = bwmorph(chromossomeStructures(1,z).imageMask, 'thin', Inf);
    skeleton = bwmorph(skeleton, 'spur', 2); 

%     imshow(~skeleton.*chromossomeStructures(1,z).imageMask);
%     pause;
    
    %get skeleton pixel list
    structInfo = regionprops(skeleton, 'PixelList');
    pixelList = structInfo.PixelList;
    
    %get end points fo skeleton
    tmp = bwmorph( skeleton, 'endpoints', 5);
    endPoints = regionprops(tmp, 'PixelList');

    sizes2 = size(skeleton);
    newSkeleton = zeros(sizes2 + 42);
    newSkeleton(21:21+sizes2(1)-1, 21:21+sizes2(2)-1) = skeleton;

    for i=1:2,
        endpoint = endPoints(i).PixelList;
        
        %choose a pixel 5 pixels away in distance
        if numel(pixelList)/2 > 5
            for j=1:numel(pixelList)/2,
                point = pixelList(j,:);
                distance = sum((endpoint-point).^2).^0.5;
                if ((distance < 6) && (distance > 4))
                    break;
                end
            end
        else
            point = endPoints(3-i).PixelList;
        end
        
        %create attachment line
        slope = (endpoint(2)-point(2)) / (endpoint(1)-point(1));
        attachment = imrotate(ones(1,20), atan(-slope)*180/pi);
        attachment = bwmorph(attachment, 'thin', Inf);
%         attachment = imbordererase(attachment);
    
        %erase black boarders
        while(sum(attachment(1,:)) == 0)
            attachment(1,:) = [];
        end

        while(sum(attachment(end,:)) == 0)
            attachment(end,:) = [];
        end

        while(sum(attachment(:,1)) == 0)
            attachment(:,1) = [];
        end

        while(sum(attachment(:,end)) == 0)
            attachment(:,end) = [];
        end
        
        sizes1 = size(attachment);
        
        %find Y coordinate
        if (point(2) >= endpoint(2))
            Lfinal = 21+endpoint(2) - sizes1(1);
        elseif (point(2) < endpoint(2)) 
            Lfinal = 21+endpoint(2) - 1;
        end
        
        %find X coordinate     
        if (point(1) >= endpoint(1))
            Cfinal = 21+endpoint(1) - sizes1(2);
        elseif (point(1) < endpoint(1))
            Cfinal = 21+endpoint(1) - 1;
        end
        
        newSkeleton(Lfinal:Lfinal+sizes1(1)-1, Cfinal:Cfinal+sizes1(2)-1) = newSkeleton(Lfinal:Lfinal+sizes1(1)-1, Cfinal:Cfinal+sizes1(2)-1) + attachment*2;
  
    end
    
    %apply mask to new skeleton to remove excess
    newSkeleton = newSkeleton(21:21+sizes2(1)-1, 21:21+sizes2(2)-1)>0;
    newSkeleton = newSkeleton .* chromossomeStructures(1,z).imageMask;
    
    %get list of pixels in built skeleton
    path = regionprops(newSkeleton, 'PixelList');
    path = path.PixelList;

    %sort pixels
    endPoints = bwmorph(newSkeleton, 'endpoints');
    endPoints = regionprops(endPoints, 'PixelList');
    path2 = PointsSort( path, endPoints(1).PixelList );
    
    %save skeleton points
    chromossomeStructures(z).skeleton = path2;

end

end