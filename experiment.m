function [ err, dur ] = experiment( x, labels, n, sAlphas, rAlphas, hAlphas, hMaxReps, pReps )
%EXPERIMENT Summary of this function goes here
%   Detailed explanation goes here
% todo use different alphas
% todo save all data
% todo get all parameters in this file

err = struct();
dur = struct();

% SSC
err.ssc = zeros(length(sAlphas), 1);
dur.ssc = zeros(length(sAlphas), 1);
iter = 1;
for a = sAlphas
    fprintf('SSC(a=%d), ', a); tic;
    [~, sLabels] = SSC(x, 0, false, a, false, 1, n);
    err.ssc(iter) = Misclassification(sLabels, labels);
    dur.ssc(iter) = toc;
    
    iter = iter + 1;
end

% RSSC
err.rssc = zeros(length(rAlphas), 3);
dur.rssc = zeros(length(rAlphas), 3);
iter = 1;
for a = rAlphas
    fprintf('RSSC(a=%d):', a); tic;
    [rRep, rC] = rssc(x, a, 0, false);
    rC(rC < 0) = 0;
    rNotRep = setdiff(1:size(x,2), rRep);
    rInX = x(:, rRep);
    rOutX = x(:, rNotRep);
    rC = rC - diag(diag(rC));
    rssc_duration = toc;
    
    % Missrate rssc with all datapoints
    fprintf('all,'); tic;
    [C_sym, ~] = BuildAdjacency(rC, 0);
    rAllLabels = SpectralClustering(C_sym,n);
    err.rssc(iter, 1) = Misclassification(rAllLabels, labels);
    dur.rssc(iter, 1) = toc + rssc_duration;

    % Missrate rssc with only representatives
    fprintf('rep,'); tic;
    [rCSym, ~] = BuildAdjacency(rC(rRep, rRep), 0);
    rRepGrps = SpectralClustering(rCSym, n);
    rRepLabels = InOutSample(rInX, rOutX, rRep, rNotRep, rRepGrps);
    err.rssc(iter, 2) = Misclassification(rRepLabels', labels);
    dur.rssc(iter, 2) = toc + rssc_duration;

    % Missrate rssc with ssc of representatives
    fprintf('mix; '); tic;
    [~, rSGrps] = SSC(rInX, 0, false, 20, false, 1, length(rRep));
    rSLabels = InOutSample(rInX, rOutX, rRep, rNotRep, rSGrps);
    err.rssc(iter, 3) = Misclassification(rSLabels', labels);
    dur.rssc(iter, 3) = toc + rssc_duration;
    
    iter = iter + 1;
end

% SSSC
err.sssc = zeros(length(pReps), 1);
dur.sssc = zeros(length(pReps), 1);
iter = 1;
for reps = pReps
    fprintf('SSSC(rep=%d), ', reps); tic;
    [sssc_labels, ~, ~] = sssc(x, reps, n);
    err.sssc(iter) = Misclassification(sssc_labels, labels);
    dur.sssc(iter) = toc;
    
    iter = iter + 1;
end

% HSSC
err.hssc = zeros(length(hAlphas), 3);
dur.hssc = zeros(length(hAlphas), 3);
iter = 1;
for a = hAlphas
    for maxRep = hMaxReps
        fprintf('HSSC(a=%d):', a); tic;
        [hRep, hC] = hssc(x, a, maxRep);
        hC(hC < 0) = 0;
        hNotRep = setdiff(1:size(x,2), hRep);
        hInX = x(:, hRep);
        hOutX = x(:, hNotRep);
        hC = hC - diag(diag(hC));
        hssc_duration = toc;

        % Missrate hssc with all datapoints
        fprintf('all,'); tic;
        [hAllCSym, ~] = BuildAdjacency(hC, 0);
        hAllLabels = SpectralClustering(hAllCSym, n);
        err.hssc(iter, 1) = Misclassification(hAllLabels, labels);
        dur.hssc(iter, 1) = toc + hssc_duration;

        % Missrate hssc with only representatives
        fprintf('rep,'); tic;
        [hRepCSym, ~] = BuildAdjacency(hC(hRep, hRep), 0);
        hRepGrps = SpectralClustering(hRepCSym, n);
        hRepLabels = InOutSample(hInX, hOutX, hRep, hNotRep, hRepGrps);
        err.hssc(iter, 2) = Misclassification(hRepLabels', labels);
        dur.hssc(iter, 2) = toc + hssc_duration;

        % Missrate hssc with ssc of representatives
        fprintf('mix; '); tic;
        [~, hSGrps] = SSC(hInX, 0, false, 20, false, 1, length(hRep));
        hSLabels = InOutSample(hInX, hOutX, hRep, hNotRep, hSGrps);
        err.hssc(iter, 3) = Misclassification(hSLabels', labels);
        dur.hssc(iter, 3) = toc + hssc_duration;

        iter = iter + 1;
    end
end

end

function [labels] = InOutSample(InX, OutX, InIdx, OutIdx, InLabels)

labels = [];
if size(OutX, 2) > 0
    OutLabels = OutSample(InX, OutX, InLabels);
    labels([InIdx, OutIdx]) = [InLabels', OutLabels];
else
    warning('All datapoints are representatives')
    labels(hRep) = hSscGrps';
end

end