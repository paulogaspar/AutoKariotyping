%   AII Project
%   Computerized kariotyping support
%   Author:
%       -Paulo Gaspar     36503
%       -Patrick Marques  36086
%   Date:
%       26/01/2009


function [ PointList  ] = ChromoSkeletonLine( image )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here

    %
    %This function get distance between a end Point and
    % branch point 'problem'
    %
    function [distance path branchdindex] = getDist( StartPoint, BranchsList, ListOfPoints )
        Directions = [-1 -1; -1 0; -1 1; 0 -1; 0 1;1 -1; 1 0; 1 1];
        
        distance = 0;
        path = [];
        point = StartPoint;
        lastPoint = StartPoint;
        z = point + Directions(1,:);
        
        while( 1 )
            branchdindex = find( BranchsList(:,1) == z(1) & BranchsList(:,2) == z(2));
            if( size( branchdindex, 1) == 0 )
                for x = 1:8
                    z = point + Directions(x,:);
                    branchdindex = find( BranchsList(:,1) == z(1) & BranchsList(:,2) == z(2));
                    if (size( branchdindex, 1) == 1)
                        path = [path; point];
                        distance = distance + 1;
                        return
                    end
                    if( z(1) ~= lastPoint(1) || z(2) ~= lastPoint(2) )
                        % not the previous
                        if( size( find( ListOfPoints(:,1) == z(1) & ListOfPoints(:,2) == z(2)), 1) == 1 )
                            next = z;
                        end
                    end
                end
                
                if( next(1) ~= lastPoint(1) || next(2) ~= lastPoint(2) )
                    % not the previous
                    if( size( find( ListOfPoints(:,1) == next(1) & ListOfPoints(:,2) == next(2)), 1) == 1 )
                        path = [path; point];
                        lastPoint = point;
                        point = next;
                        distance = distance + 1;
                    end
                end
            else
                return;
            end
        end
    end

    %
    % Remove Elements B form A
    %
    function A = removePointes(A, B)
        for q = 1:size(B, 1)
            A( find( A(:,1) == B(q,1) & A(:,2) == B(q,2)),: ) = [];
        end
    end

    %Get Skeleton
    A = bwmorph( image, 'skel', inf);
    A = bwmorph( A, 'thin', inf);
    lpoint = regionprops( A, 'PixelList' );
    %lpoint = lpoint.PixelList;
    lpoints = [];
    for i=1:size(lpoint)
        lpoints = [lpoints; lpoint(i).PixelList];
    end

    imshow(A);
    
    %Get Branch Points
    B = bwmorph( A, 'Branchpoints', 1);
    if( sum(B(:)) == 0 )
%         disp('No banch Points');
        PointList = lpoints;
        return
    end
    bpoint = regionprops( B, 'PixelList' );
    %bpoints = bpoints.PixelList;
    bpoints = [];
    for i=1:size(bpoint)
        bpoints = [bpoints; bpoint(i).PixelList];
    end
%     imshow( B ), figure;

    %Get End Points
    C = bwmorph( A, 'endpoints', 5);
    epoint = regionprops( C, 'PixelList' );
    epoints = [];
    for i=1:size(epoint)
        epoints = [epoints; epoint(i).PixelList];
    end
%     imshow( C );
    
    % while more then 2 endpoints find one way ot cur them
    k = 1;
    Dist = [];
    while( k <= size(epoints,1) )
        %get distance
        [ e.distance e.path e.branch ] = getDist(epoints(k,:), bpoints , lpoints);
        Dist = [Dist e];

        % Remove all searched points...
        lpoints = removePointes(lpoints, e.path);
        k = k + 1;
    end
    
    PointList = lpoints;

%     % Re-construct correct line...
%     index = find([Dist.distance] == max([Dist.distance]) );
%     if( numel(index) ~= 0 )
%         PointList = [ PointList; Dist(index(1)).path];
%         
%         branchIndex = Dist( find([Dist.distance] == max([Dist.distance]) ) ).branch;
%         Others = Dist(find( [Dist.branch] ~= 1));
% 
%         %index = find([Dist.distance] == max([Dist.distance]) & [Dist.branch] ~= branchIndex);
%         index = find([Others.distance] == max([Others.distance]) );
%         if( numel(index) ~= 0 )
%             PointList = [ PointList; Others(index(1)).path];
%         end
%     end
end