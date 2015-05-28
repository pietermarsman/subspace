function [ Grps ] = spectral_clustering( C, K, n )
%SPECTRAL_CLUSTERING Summary of this function goes here
%   Detailed explanation goes here

CKSym = BuildAdjacency(C,K);
imshow(CKSym)
[Grps , SingVals, LapKernel] = SpectralClustering(CKSym,n);

end

