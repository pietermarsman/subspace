function [ repInd, C ] = hssc( Y, alpha, s )
%HSSC Summary of this function goes here
%   Detailed explanation goes here

max_rep_ind_size = 50;
N = size(Y, 2);
idx = randperm(N, N);
subsets = ceil(N / s);
s = N / subsets;

repInd = [];
hssc_repInd = [];
hssc_C = [];
C = zeros(N);

for i = [1:subsets]
    subset_start = round(s*(i-1)) + 1;
    subset_end = round(s*i);
    subset_idx = idx(subset_start:subset_end);
    [subset_rep, subset_C] = rssc(Y(:, subset_idx), alpha, 0, false);
    hssc_repInd = [hssc_repInd, subset_idx(subset_rep)];
    hssc_C(subset_idx, subset_idx) = subset_C;
end

if size(hssc_repInd, 2) > max_rep_ind_size
    disp 'repeat'
    [repInd2, C2_] = hssc(Y(:, hssc_repInd), alpha, s);
    C(hssc_repInd, :) = C2_ * hssc_C(hssc_repInd, :);
    repInd = hssc_repInd(repInd2);
else
    disp 'done'
    repInd = hssc_repInd;
    C = hssc_C;
end

end