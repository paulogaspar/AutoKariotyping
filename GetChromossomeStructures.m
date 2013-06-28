%   AII Project
%   Computerized kariotyping support
%   Author:
%       -Paulo Gaspar     36503
%       -Patrick Marques  36086
%   Date:
%       26/01/2009


function [ chromossomeList ] = GetChromossomeStructures( segmentedImage, originalImage )

    %Get properties of each chromossome
    labeledImage = labelmatrix(bwconncomp(segmentedImage));

    %build each chromossome structure
    chromossomeList = [];
    grayImage = rgb2gray(originalImage);
    for i=1:max(max(labeledImage)),

        currentImage = labeledImage == i;
        properties = regionprops(currentImage, 'BoundingBox', 'ConvexImage', 'Perimeter', 'Area', 'ConvexHull');

        chromossomeList(i).perimeter = properties.Perimeter; %#ok<*AGROW>
        chromossomeList(i).area = properties.Area;
        chromossomeList(i).index = i; % just an ID to indentify each chromossome
        chromossomeList(i).pair = -1; % ID of the chromossome that pairs with this one

        %get chromossome mask through convexHull and boundingBox. Opening at
        %the end to smooth image boarded
        box = uint16(properties.BoundingBox);
        imageMask = currentImage(box(2)-1:box(2)+box(4), box(1)-1:box(1)+box(3)); %image inside bouding box
        imageMask = imopen(imageMask, strel('disk',3));

        chromossomeList(i).imageMask = imageMask;
        chromossomeList(i).originalImage = grayImage(box(2)-1:(box(2)+box(4)), box(1)-1:(box(1)+box(3))) .* uint8(chromossomeList(i).imageMask);
    end
end