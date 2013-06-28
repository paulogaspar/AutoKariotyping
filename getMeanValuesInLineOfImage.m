%   AII Project
%   Computerized kariotyping support
%   Author:
%       -Paulo Gaspar     36503
%       -Patrick Marques  36086
%   Date:
%       26/01/2009


function media = getMeanValuesInLineOfImage(originalImage, imageMask, lineSlope, point)

%media = originalImage(point(2), point(1));

%create larger images to accomodate line
newImage = zeros(size(originalImage) + 10);
newMask = zeros(size(originalImage) + 10);
newImage(6:end-5, 6:end-5) = originalImage;
newMask(6:end-5, 6:end-5) = imageMask;

%create line
point = point + 5;
attachment = imrotate(ones(1,10), atan(-lineSlope)*180/pi);
attachment = bwmorph(attachment, 'thin', Inf);
sizes = size(attachment);

linha = point(2) - int32(sizes(1)/2)+1;
coluna = point(1) - int32(sizes(2)/2)+1;

% newImage(linha:linha+sizes(1)-1, coluna:coluna+sizes(2)-1) = newImage(linha:linha+sizes(1)-1, coluna:coluna+sizes(2)-1) .* ~attachment;
% newImage(point(2), point(1)) = 255;
% close all;
% figure(1); imshow(newImage,[]);
% pause;

pointList = regionprops(attachment, 'PixelList');
pointList = pointList.PixelList;
sum = 0;
count = 0;
for i=1:numel(pointList)/2,
    if (newMask(linha + pointList(i,2), coluna + pointList(i,1)) ~= 0)
        count = count +1;
        sum = sum + newImage(linha + pointList(i,2), coluna + pointList(i,1));
    end
end
media = sum/count;



end