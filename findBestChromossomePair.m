%   AII Project
%   Computerized kariotyping support
%   Author:
%       -Paulo Gaspar     36503
%       -Patrick Marques  36086
%   Date:
%       26/01/2009


function chromossomes = findBestChromossomePair( chromossomes )

    for i=1:numel(chromossomes),
        chromossomes(i).Scores.Bands.done = false;
        chromossomes(i).Scores.Bands.Searchable = true;
    end

    chromossomes = getBestCrossCorrelation( chromossomes );

    hasChanged = true;
    i = 0;
    while ( hasChanged && (i<numel(chromossomes)) )
        i = i+1;

        %find next chromossome yet to be paired
        if (chromossomes(i).Scores.Bands.done)
            continue;
        end

        % record best chromossome index
        best_index = chromossomes(i).Scores.Bands.Indice;
        if best_index == 0,
            continue;
        end

        hasChanged = false;

        % make all chromossomes not searchable, for the function
        % getBestCrossCorrelation
        for k=1:numel(chromossomes),
            chromossomes(k).Scores.Bands.Searchable = false;
        end

        %run through all chromossomes to find wich ones reference this one as
        %the best for them.
        for j=1:numel(chromossomes),

            %avoid comparing with a already paired chromossome
            selectedChromossome = chromossomes(j).Scores.Bands;
            if (selectedChromossome.done) || (j == i) || (selectedChromossome.Indice ~= i),
                continue;
            end

            if (selectedChromossome.standardDeviation <= chromossomes(best_index).Scores.Bands.standardDeviation)
                best_index = j;
                hasChanged = true;
            else
                chromossomes(j).Scores.Bands.Searchable = true;
            end
        end

        % state this chromossome and his best pair as "done".
        if (chromossomes(i).Scores.Bands.Indice == best_index)
            hasChanged = true;
        end
        chromossomes(i).Scores.Bands.done = true;
        chromossomes(i).Scores.Bands.Indice = best_index;
        chromossomes(best_index).Scores.Bands.done = true;
        chromossomes(best_index).Scores.Bands.Indice = i;

    %     close all;
    %     figure(1); imshow(chromossomes(i).originalImage);
    %     figure(2); imshow(chromossomes(best_index).originalImage);
    %     title(num2str(i),'fontsize',7);
    %     xlabel(num2str(best_index),'fontsize',7);
    %     pause;


        chromossomes = getBestCrossCorrelation( chromossomes );
    end
end