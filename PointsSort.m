%   AII Project
%   Computerized kariotyping support
%   Author:
%       -Paulo Gaspar     36503
%       -Patrick Marques  36086
%   Date:
%       26/01/2009


function [SortedPoints] = PointsSort( PointsList, InitalPoint )
    Directions = [-1 -1; -1 0; -1 1; 0 -1; 0 1;1 -1; 1 0; 1 1];

    SortedPoints = [];
    point = InitalPoint;

    % while have points to sort
    while( size( PointsList, 1) > 1  )
        % test all directions
        for x = 1:8
            next = point + Directions(x,:);
            index = find( PointsList(:,1) == next(1) & PointsList(:,2) == next(2));
            if (size( index, 1) == 1)
                % add this point to list and go to next
                SortedPoints = [SortedPoints; point];
                old = find( PointsList(:,1) == point(1) & PointsList(:,2) == point(2));
                PointsList(old,:) = [];
                point = next;
                break;
            end
        end
    end
    %add last point
    SortedPoints = [SortedPoints; point];
end