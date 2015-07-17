function [ labels ] = rssc_cluster( x, reps, percentage, n )
%RSSC_CLUSTER Summary of this function goes here
%   Detailed explanation goes here
% percentage: of points from the dataset to use for the clustering. If
% there are to few non-representatives, random representatives are added.
% If there are to much non-representatives, random ones are chosen. If the
% value is lower than 0 the non-representatives are used no matter how much
% there are. 

% Parameter settings
par = L1ParameterConfig();
par.nClass = n;
par.lambda = 1e-7;
par.tolerance = 1e-3;

% Select the insample and outsample points
InIdx = setdiff(1:size(x,2), reps);
if percentage > 0
    nReps = round(size(x, 2) * percentage);
    if length(InIdx) > nReps
        random_idx = randperm(length(InIdx), nReps);
        InIdx = InIdx(random_idx);
    else
        random_idx = randperm(length(reps), nReps - length(InIdx));
        InIdx = [InIdx, reps(random_idx)];
    end
end
OutIdx = setdiff(1:size(x, 2), InIdx);
InX = x(:, InIdx);
OutX = x(:, OutIdx);

% Do the insample/outsample
if length(InIdx) > n
    InLabels = InSample(InX, par.lambda, par.tolerance, par, par.nClass)';
    OutLabels = OutSample(InX, OutX, InLabels);
    labels([InIdx, OutIdx]) = [InLabels', OutLabels];
else
    labels([InIdx, OutIdx]) = 1;

end

