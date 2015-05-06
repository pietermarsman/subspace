%---------------------------------------------------
%
% The following function reads in PGM (8-bit
% unsigned) data and places it into a matrix of
% NxM size.
%
% Author:  David Jansing
% Date:   April 14, 1998
% For use with Octave
%
%---------------------------------------------------

function [image_data]=read_pgm(filename);

[fid,msg]=fopen(filename,"r","native");

if (~isempty(msg)) % Messaging problem
        error(msg);
end

if (fid==-1) % Can't find file
        error(sprintf('Can''t open "%s" for reading.',filename));
end

str=fgetl(fid); % Get the 'P5'
str=fgetl(fid); % Get next field (is either column/row or comment)

while (str(1:1)=='#')
        str=fgetl(fid); % Eliminate the comments from the image file (if they exist)
end

[S_A]=strsplit(str," ");
M=str2num(S_A{1});
N=str2num(S_A{2});
% disp("The columns are:"),disp(M)
% disp("The rows are:"),disp(N)

str=fgetl(fid); % Get number of intensity values (typically 255)

[raw_data,num_pixels]=fread(fid,M*N,"uchar",0,"native");
% disp("The number of pixels read in:"),disp(num_pixels)

if (num_pixels!=(M*N))
        error(sprintf('Did not read in enough pixels.'));
end

for i = 1:N
        for j = 1:M
                image_data(i,j)=raw_data((i-1)*M+j);
        end
end 
