%   AII Project
%   Computerized kariotyping support
%   Author:
%       -Paulo Gaspar
%       -Patrick Marques
%   Date:
%       10/12/2009

function ChromossomeKaryotype( Filename )

    %% reads image and converts to gray scale
    original = imread(Filename);
    BW = ChromoSegmentation(original);
    chromossomes = GetChromossomeStructures(BW, original);
    chromossomes = getSkeleton( chromossomes );
    chromossomes = getChromossomeGrayDistribution( chromossomes );
    chromossomes = findBestChromossomePair( chromossomes ); %chromossomes = getBestCrossCorrelation( chromossomes );
    chromossomes = getChromossomeScores( chromossomes );

    for i=1:numel(chromossomes),
        chromossomes(i).pair = chromossomes(i).Scores.Bands.Indice;
    end

    DisplayKaryotyping (chromossomes);

    %% 
%     figure(2);
%     newStruct = chromossomes;
%     % Diferen�a entre o 1� desta classe e todos os outros da mesma class.....
%     j = 1;
%     for a1=[2 3 5 6 8 13 18],
%         a2 = newStruct(a1).Scores.Bands.Indice;
% 
%         subplot(4,4,j);
%         j = j + 1;
%         plot(newStruct(a1).Scores.Bands.ShiftedGrayValues.Matrix, 'r');
%         title(num2str(newStruct(a1).index));
%         xlabel(num2str(newStruct(a1).Scores.Bands.Indice));
% 
%         hold on;
%         plot(newStruct(a1).Scores.Bands.ShiftedGrayValues2.Matrix, 'b');
% 
%         subplot(4,4,j);
%         j = j + 1;
%         plot( abs(newStruct(a1).Scores.Bands.DifferenceVector.Matrix) );
%         % imprime a m�dia :S
%         line(1:numel(newStruct(a1).Scores.Bands.ShiftedGrayValues.Matrix), newStruct(a1).Scores.Bands.standardDeviation);
%         axis([1 numel(newStruct(a1).Scores.Bands.ShiftedGrayValues.Matrix) -100 100]);
%     end


    %%
%     figure(1)
%     plotI = 1;
%     newStruct = chromossomes;
% 
%     for i=1:numel(newStruct),
% 
%         %find biggest score
%         biggestScore =  intmax; %0; %
%         biggestScoreIndex = 1;
%         for k=1:numel(newStruct),
%     %         if (newStruct(k).Scores.GrayDistributionScore < biggestScore),
%             if (newStruct(k).Scores.Bands.Indice < biggestScore),
%             %if (newStruct(k).Scores.FinalScore > biggestScore),
%     %              biggestScore = newStruct(k).Scores.GrayDistributionScore;
%                biggestScore = newStruct(k).Scores.Bands.Indice;
%                % biggestScore = newStruct(k).Scores.FinalScore;
%                 biggestScoreIndex = k;
%             end
%         end
% 
%         subplot(6,8, plotI); plotI = plotI + 1;
%         imshow(newStruct(biggestScoreIndex).originalImage);
%         set(gca, 'ActivePositionProperty', 'OuterPosition');
% 
%         areaScore = newStruct(biggestScoreIndex).Scores.AreaScore;
%         PerimeterScore = newStruct(biggestScoreIndex).Scores.PerimeterScore;
%         LengthScore = newStruct(biggestScoreIndex).Scores.LengthScore;
%         MidToneScore = newStruct(biggestScoreIndex).Scores.MidToneScore;
%     %     GrayDistrScore = newStruct(biggestScoreIndex).Scores.GrayDistributionScore;
%         FinalScore = newStruct(biggestScoreIndex).Scores.FinalScore;
% 
%         %title(num2str(areaScore),'fontsize',7);
%         title(num2str(newStruct(biggestScoreIndex).index),'fontsize',7);
%         xlabel(num2str(newStruct(biggestScoreIndex).Scores.Bands.Indice),'fontsize',7);
% 
%         newStruct(biggestScoreIndex) = [];
%     end

end