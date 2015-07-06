%--------------------------------------------------------------------------
% This is the main function to run for finding the representatives
% Y: DxN data matrix of N data points in D-dimensional space
% alpha: regularization parameter, typically in [2,50]
% r: project data into r-dim space if needed, enter 0 to use original data
% verbose: enter true if want to see the iterations information
% C: NxN coefficient matrix whose nonzero rows indicate the representatives
% repInd: indices of representatives in the order of their ranking
%--------------------------------------------------------------------------
% Copyright @ Ehsan Elhamifar, 2012
%--------------------------------------------------------------------------

clc, clear all

% input the data matrix
%randn('state',0);rand('state',0);
D = 10; d = 1; N = 1000;
Y = [orth(randn(D,d)) * randn(d, N), orth(rand(D, d)) * randn(d, N)];
N = 2 * N
Y_shuffle = Y(:, randperm(N));

% input the regularization parameter
alpha = 20; % typically alpha in [2,20]

% if desired to reduce data dimension by PCA enter the projection
% dimension r, else r = 0 for using the data without any projections
r = 0;

% report information about iterations
verbose = false;

% find the representatives via sparse modelling
[repInd,C] = smrs(Y_shuffle,alpha,r,verbose);
repInd = sort(repInd);