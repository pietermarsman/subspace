% function [ P_label, Tr_idx, Tt_idx ] = sssc( data, landmark_no, n, lambda, tolerance, nonNegative)
% %SSSC Summary of this function goes here
% %   Detailed explanation goes here
% 
% par.nClass = n;
% par = L1ParameterConfig(par);
% par.lambda = lambda;
% par.tolerance = tolerance;
% par.landmarkNO = landmark_no;
% par.ndim = size(data, 1);
% 
% idx = randperm(size(data, 2));
% Tr_idx = idx(1:landmark_no);
% Tt_idx= idx(landmark_no+1:end);
% 
% % --- split the data into two parts for landmark and non-landmark
% Tr_dat = data(:, Tr_idx); % the landmark data;
% Tt_dat = data(:, Tt_idx); % the non-landmark data
% 
% % clustering the in-sample data
% Tr_plabel = InSample(Tr_dat, par.lambda, par.tolerance, par, n);
% Tt_plabel = OutSample(Tr_dat, Tt_dat, Tr_plabel);
% P_label = [];
% P_label([Tr_idx, Tt_idx], 1) = [Tr_plabel Tt_plabel];
% 
% end

function [ labels, InIdx, OutIdx ] = sssc( x, InIdx, nReps, n, lambda, tol )
%RSSC_CLUSTER Summary of this function goes here
%   Detailed explanation goes here
% percentage: of points from the dataset to use for the clustering. If
% there are to few non-representatives, random representatives are added.
% If there are to much non-representatives, random ones are chosen. If the
% value is lower than 0 the non-representatives are used no matter how much
% there are. 

% Parameter settings
par.nClass = n;
par = L1ParameterConfig(par);
par.lambda = lambda;
par.tolerance = tol;
par.landmarkNO = nReps;
par.ndim = size(x, 1);

% Select the insample and outsample points
OutIdx = setdiff(1:size(x, 2), InIdx);
if nReps > 0
    if length(InIdx) > nReps
        random_idx = randperm(length(InIdx), nReps);
        InIdx = InIdx(random_idx);
    else
        random_idx = randperm(length(OutIdx), nReps - length(InIdx));
        InIdx = [InIdx, OutIdx(random_idx)];
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

