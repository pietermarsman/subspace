function [ err, dur, pred ] = experiment( x, labels, n, sAlphas, rAlphas, hAlphas, hMaxReps, pReps )
%EXPERIMENT Summary of this function goes here
%   Detailed explanation goes here

err = struct();
dur = struct();
pred = struct();

% Constants
sR = 0; % projection dimension
sAffine = false;
sAlpha = 20; % default ssc alpha
sOutlier = false; % if there are outliers
sRho = 1; % coefficient threshold
sK = 0; % number of strongest coefficients to keep
ssLambda = 1e-7;
ssTolerance = 0.001;
nonNegative = true;

% SSC
err.ssc = zeros(length(sAlphas), 1);
dur.ssc = zeros(length(sAlphas), 1);
pred.ssc = cell(length(sAlphas), 1);
iter = 1;
for a = sAlphas
    fprintf('SSC(a=%d), ', a); tic;
    [~, pred.ssc{iter}] = SSC(x, sR, sAffine, a, sOutlier, sRho, n);
    err.ssc(iter) = Misclassification(pred.ssc{iter}, labels);
    dur.ssc(iter) = toc;
    
    iter = iter + 1;
end

% RSSC
err.rssc = zeros(length(rAlphas), 3);
dur.rssc = zeros(length(rAlphas), 3);
pred.rssc = cell(length(rAlphas), 3);
iter = 1;
for a = rAlphas
    fprintf('RSSC(a=%d):', a); tic;
    [rRep, rC] = rssc(x, a, sR, false);
    if nonNegative
        rC(rC < 0) = 0;
    end
    rNotRep = setdiff(1:size(x,2), rRep);
    rInX = x(:, rRep);
    rOutX = x(:, rNotRep);
    rC = rC - diag(diag(rC));
    rssc_duration = toc;
    
    % Missrate rssc with all datapoints
    fprintf('all,'); tic;
    [C_sym, ~] = BuildAdjacency(rC, sK);
    pred.rssc{iter, 1} = SpectralClustering(C_sym, n);
    err.rssc(iter, 1) = Misclassification(pred.rssc{iter, 1}, labels);
    dur.rssc(iter, 1) = toc + rssc_duration;

    % Missrate rssc with only representatives
    fprintf('rep,'); tic;
    [rCSym, ~] = BuildAdjacency(rC(rRep, rRep), sK);
    rRepGrps = SpectralClustering(rCSym, n);
    pred.rssc{iter, 2} = InOutSample(rInX, rOutX, rRep, rNotRep, rRepGrps);
    err.rssc(iter, 2) = Misclassification(pred.rssc{iter, 2}', labels);
    dur.rssc(iter, 2) = toc + rssc_duration;

    % Missrate rssc with ssc of representatives
    fprintf('mix; '); tic;
    [~, rSGrps] = SSC(rInX, sR, sAffine, sAlpha, sOutlier, sRho, n);
    pred.rssc{iter, 3} = InOutSample(rInX, rOutX, rRep, rNotRep, rSGrps);
    err.rssc(iter, 3) = Misclassification(pred.rssc{iter, 3}', labels);
    dur.rssc(iter, 3) = toc + rssc_duration;
    
    iter = iter + 1;
end

% SSSC
err.sssc = zeros(length(pReps), 1);
dur.sssc = zeros(length(pReps), 1);
pred.sssc = cell(length(pReps), 1);
iter = 1;
for reps = pReps
    fprintf('SSSC(rep=%d), ', reps); tic;
    [pred.sssc{iter}, ~, ~] = sssc(x, reps, n, ssLambda, ssTolerance, nonNegative);
    err.sssc(iter) = Misclassification(pred.sssc{iter}, labels);
    dur.sssc(iter) = toc;
    
    iter = iter + 1;
end

% HSSC
err.hssc = zeros(length(hAlphas), 3);
dur.hssc = zeros(length(hAlphas), 3);
pred.hssc = cell(length(hAlphas), 3);
iter = 1;
for a = hAlphas
    for maxRep = hMaxReps
        fprintf('HSSC(a=%d):', a); tic;
        [hRep, hC] = hssc(x, a, maxRep);
        if nonNegative
            hC(hC < 0) = 0;
        end
        hNotRep = setdiff(1:size(x,2), hRep);
        hInX = x(:, hRep);
        hOutX = x(:, hNotRep);
        hC = hC - diag(diag(hC));
        hssc_duration = toc;

        % Missrate hssc with all datapoints
        fprintf('all,'); tic;
        [hAllCSym, ~] = BuildAdjacency(hC, sK);
        pred.hssc{iter, 1} = SpectralClustering(hAllCSym, n);
        err.hssc(iter, 1) = Misclassification(pred.hssc{iter, 1}, labels);
        dur.hssc(iter, 1) = toc + hssc_duration;

        % Missrate hssc with only representatives
        fprintf('rep,'); tic;
        [hRepCSym, ~] = BuildAdjacency(hC(hRep, hRep), sK);
        hRepGrps = SpectralClustering(hRepCSym, n);
        pred.hssc{iter, 2} = InOutSample(hInX, hOutX, hRep, hNotRep, hRepGrps);
        err.hssc(iter, 2) = Misclassification(pred.hssc{iter, 2}', labels);
        dur.hssc(iter, 2) = toc + hssc_duration;

        % Missrate hssc with ssc of representatives
        fprintf('mix; '); tic;
        [~, hSGrps] = SSC(hInX, sR, sAffine, sAlpha, sOutlier, sRho, n);
        pred.hssc{iter, 3} = InOutSample(hInX, hOutX, hRep, hNotRep, hSGrps);
        err.hssc(iter, 3) = Misclassification(pred.hssc{iter, 3}', labels);
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