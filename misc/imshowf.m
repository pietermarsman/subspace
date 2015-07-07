function [ ] = imshowf( image )
%IMSHOWF Summary of this function goes here
%   Detailed explanation goes here
imshow(image, [min(min(image)), max(max(image))]);

end

