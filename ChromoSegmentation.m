%   AII Project
%   Computerized kariotyping support
%   Author:
%       -Paulo Gaspar     36503
%       -Patrick Marques  36086
%   Date:
%       26/01/2009


% parameter is the image to segment
% return the segmented image
function [ segmentedImage ] = ChromoSegmentation( image )

    % reads image and converts to gray scale
    A = rgb2gray(image);

    % enhances contrast using filters and top/bottom hats.
    H = fspecial('gaussian', 1,3);
    A = imfilter(A,H);
    se = strel('disk',4);
    J = imsubtract(imadd(A,imtophat(A,se)), imbothat(A,se));

    % obtain markers of chromossomes
    F = ~imextendedmax(J, 20);
    L = bwmorph(F,'majority', inf);
    D = bwareaopen(L, 40);

    % get separation lines from watershed
    water = watershed(~D);

    % get well defined mask
    C = imfill(imadjust(A)<240, 'holes');
    V = imerode(C, strel('disk', 2));
    B = imdilate(V, strel('disk', 4));

    % apply watershed to separate chromossomes that were stuck together
    G = B .* water;
    I = imfill(~(imadjust(G)<1), 'holes');

    % Remove holes and small artifacts. Replace removed holes that should stay (folded chromossomes).
    bigHoles = imdilate(bwareaopen(~(imadjust(A)<230), 10), strel('disk', 1));
    X = (I-bigHoles) == 1;
    Y = bwareaopen(X, 40, 4); %remove small artifacts
    Z = ~bwareaopen(~Y, 40, 4); %remove small holes

    segmentedImage = Z;

end