function [ repInd, C ] = hssc( Y, alpha, max_rep, nonNegative, verbose )
%HSSC Summary of this function goes here
%   Detailed explanation goes here

N = size(Y, 2);
idx = randperm(N, N);
subsets = 2; % ceil(N / s);
s = N / subsets;

repInd = [];
hssc_repInd = [];
hssc_C = [];
C = zeros(N);

for i = [1:subsets]
    subset_start = round(s*(i-1)) + 1;
    subset_end = round(s*i);
    subset_idx = idx(subset_start:subset_end);
    [subset_rep, subset_C] = rssc(Y(:, subset_idx), alpha, 0, nonNegative, false);
    hssc_repInd = [hssc_repInd, subset_idx(subset_rep)];
    hssc_C(subset_idx, subset_idx) = subset_C;
end

if size(hssc_repInd, 2) >= size(Y, 2)
    if verbose
        alpha = alpha * .5;
        warning(sprintf('Could not reduce number of representatives. Dividing alpha by 2.\nSize Y: %g. Alpha: %d', size(Y, 2), alpha))
    end
    
end
if size(hssc_repInd, 2) > max_rep
    [repInd2, C2_] = hssc(Y(:, hssc_repInd), alpha, max_rep, nonNegative, verbose);
    C(hssc_repInd, :) = C2_ * hssc_C(hssc_repInd, :);
    repInd = hssc_repInd(repInd2);
else
    repInd = hssc_repInd;
    C = hssc_C;
end

end