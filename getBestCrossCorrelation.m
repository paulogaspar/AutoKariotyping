%   AII Project
%   Computerized kariotyping support
%   Author:
%       -Paulo Gaspar     36503
%       -Patrick Marques  36086
%   Date:
%       26/01/2009


function chromossomes = getBestCrossCorrelation( chromossomes )
    
    function [ diffe c1 c2 ] = difference( Gray1, Gray2, Shift)
        % With a Gray Distributions and the Correlation between it
        % get the diferences of values on the 'valor' point
        s = abs(Shift);
        sizes = max( [numel(Gray1) numel(Gray2)] );
        c1 = zeros(1, sizes + 2*s);
        c1(s+1:s+numel(Gray1)) = Gray1;
        c2 = zeros(1, sizes + 2*s);
        c2(s+1:s+numel(Gray2)) = Gray2;
        
        c2 = circshift(c2, [0 double(Shift)]);
        diffe = (c1 - c2);
    end

    % Initialize with zeros
    for i=1:numel(chromossomes)
        if (chromossomes(i).Scores.Bands.done || ~chromossomes(i).Scores.Bands.Searchable)
            continue;
        end
        chromossomes(i).Scores.Bands.standardDeviation = intmax;
        chromossomes(i).Scores.Bands.Indice = 0;
    end

    for i=1:numel(chromossomes),
        
        if (chromossomes(i).Scores.Bands.done || ~chromossomes(i).Scores.Bands.Searchable)
            continue;
        end
        
        gray1 = chromossomes(i).grayDistribution;
        size1 = chromossomes(i).area; %numel(gray1);
        grayscore1 = mean(chromossomes(i).originalImage(chromossomes(i).originalImage(:) > 0));
        
%         if (chromossomes(i).Scores.Bands.Indice ~= 0)
%             continue;
%         end
        %%%%%%%%%%%%%%%
%         close all;
%         figure(1);
%         imshow(chromossomes(i).originalImage);
%         title(int2str(size1));
%         figure(2);
%         BRA = 1;
        %%%%%%%%%%%%%%%%
        
        for j=1:numel(chromossomes),
            
            if (chromossomes(j).Scores.Bands.done)
                continue;
            end

            % ignore chromossomes with too dispar length
            gray2 = chromossomes(j).grayDistribution;
            size2 = chromossomes(j).area;
            grayscore2 = mean(chromossomes(j).originalImage(chromossomes(j).originalImage(:) > 0));
            
            if (min(size1,size2)/max(size1, size2) < 0.8) || (i == j), 
                continue;
            end
            
            if (max(grayscore1, grayscore2) - min(grayscore1, grayscore2) > 20)
                continue;
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%
%             subplot(5,10,BRA); BRA = BRA +1;
%             imshow(chromossomes(j).originalImage);
%             title(int2str(size2));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % calculate cross correlation, and verify if its maximum is bigger
            % than the maximum obtained until now for this chromossome.
            [xcorr1, lag1] = xcorr(gray1, gray2);
            [xcorr2, lag2] = xcorr(gray1, gray2(end:-1:1));
            %[correlation ] = [xcorr1 xcorr2];
            if (max(xcorr1) > max(xcorr2))
                lag = lag1(find(xcorr1 == max(xcorr1))); %#ok<*FNDSB>
            else
                lag = lag2(find(xcorr2 == max(xcorr2)));
                gray2 = gray2(end:-1:1);
            end

            % calculates differences
            [grayDifferences grayAligned1 grayAligned2] = difference( gray1, gray2, lag);
            
            % ignore differences where aligned gray distributions are zero, so it
            % wont affect the standard deviation value
            noZerosIndexes = (grayAligned1 ~= 0) & (grayAligned2 ~= 0);
            standardDeviationOfGrayDifference = std(grayDifferences(noZerosIndexes));
    
            if (standardDeviationOfGrayDifference < chromossomes(i).Scores.Bands.standardDeviation)
                chromossomes(i).Scores.Bands.standardDeviation = standardDeviationOfGrayDifference;

                chromossomes(i).Scores.Bands.ShiftedGrayValues.Matrix = grayAligned1(noZerosIndexes);
                chromossomes(i).Scores.Bands.ShiftedGrayValues2.Matrix = grayAligned2(noZerosIndexes);
                chromossomes(i).Scores.Bands.DifferenceVector.Matrix = grayDifferences(noZerosIndexes);
                
                chromossomes(i).Scores.Bands.Indice = j;
            end
        end

        % If the cromossome being tested cross correlation score is smaller,
        % change it for this one.
%         j = chromossomes(i).Scores.Bands.Indice;
%         if (chromossomes(i).Scores.Bands.standardDeviation < chromossomes(j).Scores.Bands.standardDeviation)
%             chromossomes(j).Scores.Bands.standardDeviation = chromossomes(i).Scores.Bands.standardDeviation;
%             %chromossomes(j).Scores.Bands.Corr(i).Matrix = correlation;
%             %chromossomes(j).Scores.Bands.ShiftedGrayValues.Matrix = grayAligned2(noZerosIndexes);
%             %chromossomes(j).Scores.Bands.DifferenceVector.Matrix = grayDifferences(noZerosIndexes);
%             chromossomes(j).Scores.Bands.Indice = i;
%         end
        
    end

end