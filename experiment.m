function [ err, mut, dur, pred, names ] = experiment( x, labels, n, sAlphas, rAlphas, hAlphas, hMaxReps, pReps, pLambda, pTol )
%EXPERIMENT Summary of this function goes here
%   Detailed explanation goes here

verbose = false;
useAll = false;
useRep = false;
useMix = true;
numUses = useAll + useRep + useMix; 

nExp = length(sAlphas) + length(rAlphas) * numUses + length(hAlphas) * length(hMaxReps) * numUses + length(pReps);
N = length(labels);
err = zeros(nExp, 1);
mut = zeros(nExp, 1);
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
nonNegative = true;

% SSC
for a = sAlphas
    fprintf('SSC(a=%d), ', a); 
    tic;
    [~, pred(iter, :)] = SSC(x, sR, sAffine, a, sOutlier, sRho, n);
    dur(iter) = toc;
    err(iter) = Misclassification(pred(iter, :)', labels);
    mut(iter) = MutualInfo(pred(iter, :), labels);
    names{iter} = ['SSC ', int2str(a)];
    iter = iter + 1;
end

% RSSC
for a = rAlphas
    fprintf('RSSC(a=%d):', a); 
    tic;
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
    if useAll
        fprintf('all,'); 
        tic;
        [C_sym, ~] = BuildAdjacency(rC, sK);
        pred(iter, :) = SpectralClustering(C_sym, n);
        dur(iter) = toc + rssc_duration;
        err(iter) = Misclassification(pred(iter, :)', labels);
        mut(iter) = MutualInfo(pred(iter, :), labels);
        names{iter} = ['RSSC all ', int2str(a)];
        iter = iter + 1;
    end

    % Missrate rssc with only representatives
    if useRep
        fprintf('rep,');
        tic;
        [rCSym, ~] = BuildAdjacency(rC(rRep, rRep), sK);
        rRepGrps = SpectralClustering(rCSym, min(n, length(rRep)));
        pred(iter, :) = InOutSample(rInX, rOutX, rRep, rNotRep, rRepGrps, verbose);
        dur(iter) = toc + rssc_duration;
        err(iter) = Misclassification(pred(iter, :)', labels);
        mut(iter) = MutualInfo(pred(iter, :), labels);
        names{iter} = ['RSSC rep ', int2str(a)];
        iter = iter + 1;
    end

    % Missrate rssc with ssc of representatives
    if useMix
        fprintf('mix; '); 
        tic;
        [~, rSGrps] = SSC(rInX, sR, sAffine, sAlpha, sOutlier, sRho, min(n, length(rRep)));
        pred(iter, :) = InOutSample(rInX, rOutX, rRep, rNotRep, rSGrps, verbose);
        dur(iter) = toc + rssc_duration;
        err(iter) = Misclassification(pred(iter, :)', labels);
        mut(iter) = MutualInfo(pred(iter, :), labels);
        names{iter} = ['RSSC mix ', int2str(a)];
        iter = iter + 1;
    end
end

% SSSC
for reps = pReps
    for tol = pTol
        for lambda = pLambda
            fprintf('SSSC(rep=%d,t=%d,l=%d), ', reps);
            tic;
            [pred(iter, :), ~, ~] = sssc(x, reps, n, lambda, tol, nonNegative);
            dur(iter) = toc;
            err(iter) = Misclassification(pred(iter, :)', labels);
            mut(iter) = MutualInfo(pred(iter, :), labels);
            names{iter} = ['SSSC ', int2str(reps)];
            iter = iter + 1;
        end
    end
end

% HSSC
for a = hAlphas
    for maxRep = hMaxReps
        fprintf('HSSC(a=%d,reps=%d):', a, maxRep); 
        tic;
        [hRep, hC] = hssc(x, a, maxRep, verbose);
        if nonNegative
            hC(hC < 0) = 0;
        end
        hNotRep = setdiff(1:size(x,2), hRep);
        hInX = x(:, hRep);
        hOutX = x(:, hNotRep);
        hC = hC - diag(diag(hC));
        hssc_duration = toc;

        % Missrate hssc with all datapoints
        if useAll
            fprintf('all,'); 
            tic;
            [hAllCSym, ~] = BuildAdjacency(hC, sK);
            pred(iter, :) = SpectralClustering(hAllCSym, n);
            dur(iter) = toc + hssc_duration;
            err(iter) = Misclassification(pred(iter, :)', labels);
            mut(iter) = MutualInfo(pred(iter, :), labels);
            names{iter} = ['HSSC all ', int2str(a), ' ', int2str(maxRep)];
            iter = iter + 1;
        end

        % Missrate hssc with only representatives
        if useRep
            fprintf('rep,'); 
            tic;
            [hRepCSym, ~] = BuildAdjacency(hC(hRep, hRep), sK);
            hRepGrps = SpectralClustering(hRepCSym, min(n, length(hRep)));
            pred(iter, :) = InOutSample(hInX, hOutX, hRep, hNotRep, hRepGrps, verbose);
            dur(iter) = toc + hssc_duration;
            err(iter) = Misclassification(pred(iter, :)', labels);
            mut(iter) = MutualInfo(pred(iter, :), labels);
            names{iter} = ['HSSC rep ', int2str(a), ' ', int2str(maxRep)];
            iter = iter + 1;
        end

        % Missrate hssc with ssc of representatives
        if useMix
            fprintf('mix; '); 
            tic;
            [~, hSGrps] = SSC(hInX, sR, sAffine, sAlpha, sOutlier, sRho, min(n, length(hRep)));
            pred(iter, :) = InOutSample(hInX, hOutX, hRep, hNotRep, hSGrps, verbose);
            dur(iter) = toc + hssc_duration;
            err(iter) = Misclassification(pred(iter, :)', labels);
            mut(iter) = MutualInfo(pred(iter, :), labels);
            names{iter} = ['HSSC mix ', int2str(a), ' ', int2str(maxRep)];
            iter = iter + 1;
        end
    end
    
end

end

function [labels] = InOutSample(InX, OutX, InIdx, OutIdx, InLabels, verbose)

labels = [];
if size(OutX, 2) > 0
    OutLabels = OutSample(InX, OutX, InLabels);
    labels([InIdx, OutIdx]) = [InLabels', OutLabels];
else
    if verbose
        warning('All datapoints are representatives')
    end
    labels(InIdx) = InLabels';
end

end