%   AII Project
%   Computerized kariotyping support
%   Author:
%       -Paulo Gaspar     36503
%       -Patrick Marques  36086
%   Date:
%       26/01/2009


function chromossomes = getChromossomeScores( chromossomes )

    weights = [
                150; %area weight
                100; %perimeter weight
                70; %length weight
                50; %mid tone weight
                0; %gray distribution weight %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% nao usado
              ];


    % Calculate Score
    for i=1:numel(chromossomes),
        % Individual score
        chromossomes(i).Scores.AreaScore = chromossomes(i).area * weights(1);
        chromossomes(i).Scores.PerimeterScore = chromossomes(i).perimeter * weights(2);
        chromossomes(i).Scores.LengthScore = numel(chromossomes(i).skeleton) * weights(3);
        chromossomes(i).Scores.MidToneScore = mean(chromossomes(i).originalImage(chromossomes(i).originalImage(:) > 0)) * weights(4);
        chromossomes(i).Scores.GrayDistributionScore = chromossomes(i).Scores.Bands.standardDeviation; %* weights(5);

        % Total Score
        chromossomes(i).Scores.FinalScore = (chromossomes(i).Scores.AreaScore + chromossomes(i).Scores.PerimeterScore + chromossomes(i).Scores.LengthScore + chromossomes(i).Scores.MidToneScore) / sum(weights);
    end

end