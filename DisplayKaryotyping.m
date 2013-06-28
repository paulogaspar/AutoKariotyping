%   AII Project
%   Computerized kariotyping support
%   Author:
%       -Paulo Gaspar     36503
%       -Patrick Marques  36086
%   Date:
%       26/01/2009


function [ result ] = DisplayKaryotyping( ChromossomeStructList )
    % DisplayKaryotyping Display the result of karyotyping
    %   ChromossomeStructList

    % Result image initialize
    imageSize = [800, 600];
    result = ones(imageSize)*255;
    border = 20; % prevent errors :P :D

    i = 5;
    j = 5;
    lineH = 0;
    indexs = 1:numel(ChromossomeStructList);
    while( numel(indexs) > 0 )
        % get chromossome
        index = indexs(1);
        indexs(1) = [];
        chromo = ChromossomeStructList(index).originalImage;
        mask = ChromossomeStructList(index).imageMask;

        % rotate the chromossome
        p1 = ChromossomeStructList(index).skeleton(1,:);
        p2 = ChromossomeStructList(index).skeleton(int32(end), :);
        teta = (p1(2) - p2(2)) / (p1(1) - p2(1));
        chromo = imrotate(chromo, 90-atan(-teta)*180/pi);

        
        %erase black boarders
        while(sum(chromo(1,:)) == 0)
            chromo(1,:) = [];
        end

        while(sum(chromo(end,:)) == 0)
            chromo(end,:) = [];
        end

        while(sum(chromo(:,1)) == 0)
            chromo(:,1) = [];
        end

        while(sum(chromo(:,end)) == 0)
            chromo(:,end) = [];
        end
        
        sizes = size(chromo);

        % if pair of chromosomes doesn't fit here change line
        if imageSize(2) < j + sizes(1)*2 + border
            i = i + lineH + border;
            lineH = 0;
            j = 5;
        end

        % put this chromossome in the result image
        chromo(chromo == 0) = 255;
        
        result(i:i+sizes(1)-1,j:j+sizes(2)-1) = chromo;
        j = j + sizes(2) + 5;

        % store the maximum height of this line
        if lineH < sizes(1)
            lineH = sizes(1);
        end

        % get chromossome
        pair_index = ChromossomeStructList(index).pair;
        if pair_index == 0 || isempty(indexs(indexs==pair_index))
            % If no pair available jump to next...
            j = j + sizes(2) + 50;
            continue
        end
        chromo = ChromossomeStructList(pair_index).originalImage;
        indexs(indexs==pair_index) = [];

        % rotate the chromossome
        p1 = ChromossomeStructList(pair_index).skeleton(1,:);
        p2 = ChromossomeStructList(pair_index).skeleton(int32(end),:);
        teta = (p1(2) - p2(2)) / (p1(1) - p2(1));
        chromo = imrotate(chromo, 90-atan(-teta)*180/pi);
        
        while(sum(chromo(1,:)) == 0)
            chromo(1,:) = [];
        end

        while(sum(chromo(end,:)) == 0)
            chromo(end,:) = [];
        end

        while(sum(chromo(:,1)) == 0)
            chromo(:,1) = [];
        end

        while(sum(chromo(:,end)) == 0)
            chromo(:,end) = [];
        end
        
        % put this chromossome in the resulte image
        sizes = size(chromo);
        
        chromo(chromo == 0) = 255;
        result(i:i+sizes(1)-1,j:j+sizes(2)-1) = chromo;
        j = j + sizes(2) + 50;

        % store the maximum height of this line
        if lineH < sizes(1)
            lineH = sizes(1);
        end
    end

    imshow( result , []);
end