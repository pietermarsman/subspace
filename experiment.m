function [ err, dur, pred, names ] = experiment( x, labels, n, sAlphas, rAlphas, hAlphas, hMaxReps, pReps )
%EXPERIMENT Summary of this function goes here
%   Detailed explanation goes here

nExp = length(sAlphas) + length(rAlphas) * 3 + length(hAlphas) * length(hMaxReps) * 3 + length(pReps);
N = length(labels);
err = zeros(nExp, 1);
dur = zeros(nExp, 1);
pred = zeros(nExp, N);
iter = 1;

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
for a = sAlphas
    fprintf('SSC(a=%d), ', a); tic;
    [~, pred(iter, :)] = SSC(x, sR, sAffine, a, sOutlier, sRho, n);
    err(iter) = Misclassification(pred(iter, :)', labels);
    dur(iter) = toc;
    names{iter} = ['SSC ', int2str(a)];
    iter = iter + 1;
end

% RSSC
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
    pred(iter, :) = SpectralClustering(C_sym, n);
    err(iter) = Misclassification(pred(iter, :)', labels);
    dur(iter) = toc + rssc_duration;
    names{iter} = ['RSSC all ', int2str(a)];
    iter = iter + 1;

    % Missrate rssc with only representatives
    fprintf('rep,'); tic;
    [rCSym, ~] = BuildAdjacency(rC(rRep, rRep), sK);
    rRepGrps = SpectralClustering(rCSym, n);
    pred(iter, :) = InOutSample(rInX, rOutX, rRep, rNotRep, rRepGrps);
    err(iter) = Misclassification(pred(iter, :)', labels);
    dur(iter) = toc + rssc_duration;
    names{iter} = ['RSSC rep ', int2str(a)];
    iter = iter + 1;

    % Missrate rssc with ssc of representatives
    fprintf('mix; '); tic;
    [~, rSGrps] = SSC(rInX, sR, sAffine, sAlpha, sOutlier, sRho, n);
    pred(iter, :) = InOutSample(rInX, rOutX, rRep, rNotRep, rSGrps);
    err(iter) = Misclassification(pred(iter, :)', labels);
    dur(iter) = toc + rssc_duration;
    names{iter} = ['RSSC mix ', int2str(a)];
    iter = iter + 1;
end

% SSSC
for reps = pReps
    fprintf('SSSC(rep=%d), ', reps); tic;
    [pred(iter, :), ~, ~] = sssc(x, reps, n, ssLambda, ssTolerance, nonNegative);
    err(iter) = Misclassification(pred(iter, :)', labels);
    dur(iter) = toc;
    names{iter} = ['SSSC ', int2str(reps)];
    iter = iter + 1;
end

% HSSC
for a = hAlphas
    for maxRep = hMaxReps
        fprintf('HSSC(a=%d,reps=%d):', a, maxRep); tic;
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
        pred(iter, :) = SpectralClustering(hAllCSym, n);
        err(iter) = Misclassification(pred(iter, :)', labels);
        dur(iter) = toc + hssc_duration;
        names{iter} = ['HSSC all ', int2str(a), ' ', int2str(maxRep)];
        iter = iter + 1;

        % Missrate hssc with only representatives
        fprintf('rep,'); tic;
        [hRepCSym, ~] = BuildAdjacency(hC(hRep, hRep), sK);
        hRepGrps = SpectralClustering(hRepCSym, n);
        pred(iter, :) = InOutSample(hInX, hOutX, hRep, hNotRep, hRepGrps);
        err(iter) = Misclassification(pred(iter, :)', labels);
        dur(iter) = toc + hssc_duration;
        names{iter} = ['HSSC rep ', int2str(a), ' ', int2str(maxRep)];
        iter = iter + 1;

        % Missrate hssc with ssc of representatives
        fprintf('mix; '); tic;
        [~, hSGrps] = SSC(hInX, sR, sAffine, sAlpha, sOutlier, sRho, n);
        pred(iter, :) = InOutSample(hInX, hOutX, hRep, hNotRep, hSGrps);
        err(iter) = Misclassification(pred(iter, :)', labels);
        dur(iter) = toc + hssc_duration;
        names{iter} = ['HSSC mix ', int2str(a), ' ', int2str(maxRep)];
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