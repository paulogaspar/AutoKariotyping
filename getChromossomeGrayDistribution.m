%   AII Project
%   Computerized kariotyping support
%   Author:
%       -Paulo Gaspar     36503
%       -Patrick Marques  36086
%   Date:
%       26/01/2009


function chromossomes = getChromossomeGrayDistribution( chromossomes )

    for i=1:numel(chromossomes),
        Chromossome = i
        spinePoints = chromossomes(1,i).skeleton;
        originalImage = chromossomes(1,i).originalImage;
        imageMask = chromossomes(1,i).imageMask;

        grayDistribution = zeros(1,numel(spinePoints)/2);
        grayDistribution(1) = originalImage( spinePoints(1,2), spinePoints(1,1) );
        grayDistribution(end-1) = originalImage( spinePoints(end-1,2), spinePoints(end-1,1) );
        grayDistribution(end) = originalImage( spinePoints(end,2), spinePoints(end,1) );
        lastPoint = spinePoints(1,:);
        for j=2:numel(spinePoints)/2-2,
            nextPoint = spinePoints(j+2,:);
            slope = (nextPoint(2)-lastPoint(2)) / (nextPoint(1)-lastPoint(1));
            meanValue = getMeanValuesInLineOfImage(originalImage, imageMask, -1/slope, spinePoints(j,:));
            %meanValue
            grayDistribution(j) = meanValue; %originalImage(spinePoints(j,:));
            
            lastPoint = spinePoints(j-1,:);
        end
        
%         figure(1); imshow(chromossomes(1,i).originalImage);
%         figure(2); imshow(repmat(grayDistribution,50,1), []);
%         pause;
        chromossomes(i).grayDistribution = grayDistribution;
        
    end

end