function [ P_label, Tr_idx, Tt_idx ] = sssc( data, landmark_no, n)
%SSSC Summary of this function goes here
%   Detailed explanation goes here

par.lambda = 1e-7;
par.tolerance = 0.001;
par.maxIteration = 5000;
par.isNonnegative = true;

idx = randperm(size(data, 2));
Tr_idx = idx(1:landmark_no);
Tt_idx= idx(landmark_no+1:end);

% --- split the data into two parts for landmark and non-landmark
Tr_dat = data(:, Tr_idx); % the landmark data;
Tt_dat = data(:, Tt_idx); % the non-landmark data

% clustering the in-sample data
Tr_plabel = InSample(Tr_dat, par.lambda, par.tolerance, par, n);
Tt_plabel = OutSample(Tr_dat, Tt_dat, Tr_plabel);
P_label = [];
P_label([Tr_idx, Tt_idx], 1) = [Tr_plabel Tt_plabel];

end

