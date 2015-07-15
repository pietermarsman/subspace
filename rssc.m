function [ repInd, C ] = rssc( Y, alpha, r, nonnegative, verbose)
%RSSC Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 2)
    alpha = 5;
end
if (nargin < 3)
    r = 0;
end
if (nargin < 4)
    verbose = true;
end

q = 2;
regParam = [alpha alpha];
affine = false;
thr =  1e-7;
maxIter = 5000;
thrS = 0.9999;
thrP = 0.95;
N = size(Y,2);

Y = Y - repmat(mean(Y,2),1,N);
if (r >= 1)
    [~,S,V] = svd(Y,0);
    r = min(r,size(V,1));
    Y = S(1:r,1:r) * V(:,1:r)';
end

C = almLasso_mat_func(Y,affine,regParam,q,thr,maxIter,verbose);

if nonnegative
    C(C < 0) = 0;
end

% Always return all indices
sInd = findRep(C,thrS,q);
% repInd = rmRep(sInd,Y,thrP);
repInd = sInd;
end

