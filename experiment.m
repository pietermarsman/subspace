function [ err, dur ] = experiment( x, labels, n, sAlphas, rAlphas, hAlphas, hMaxRep, pLandmarks )
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
    fprintf('SSC (a=%d), ', a); tic;
    [~, ssc_grps] = SSC(x, 0, false, a, false, 1, n);
    err.ssc(iter) = Misclassification(ssc_grps, labels);
    dur.ssc(iter) = toc;
    
    iter = iter + 1;
end

% RSSC
err.rssc = zeros(length(rAlphas), 3);
dur.rssc = zeros(length(rAlphas), 3);
iter = 1;
for a = rAlphas
    fprintf('RSSC (a=%d), ', a); tic;
    [rRep, rC] = rssc(x, a, 0, false);
    rC(rC < 0) = 0;
    rNotRep = setdiff(1:size(x,2), rRep);
    rInX = x(:, rRep);
    rOutX = x(:, rNotRep);
    rC = rC - diag(diag(rC));
    rssc_duration = toc;
    
    % Missrate rssc with all datapoints
    fprintf('RSSC all, '); tic;
    [C_sym, ~] = BuildAdjacency(rC, 0);
    grps = SpectralClustering(C_sym,n);
    err.rssc(iter, 1) = Misclassification(grps, labels);
    dur.rssc(iter, 1) = toc + rssc_duration;

    % Missrate rssc with only representatives
    fprintf('RSSC rep, '); tic;
    [rCSym, ~] = BuildAdjacency(rC(rRep, rRep), 0);
    rssc_grps = SpectralClustering(rCSym, n);
    mixed_labels = [];
    if size(rOutX, 2) > 0
        not_rep_labels = OutSample(rInX, rOutX, rssc_grps);
        mixed_labels([rRep, rNotRep]) = [rssc_grps', not_rep_labels];
    else
        warning('RSSC has used all datapoints as representatives')
        mixed_labels(rRep) = rssc_grps';
    end
    err.rssc(iter, 2) = Misclassification(mixed_labels', labels);
    dur.rssc(iter, 2) = toc + rssc_duration;

    % Missrate rssc with ssc of representatives
    fprintf('RSSC mix, '); tic;
    new_labels = labels(rRep);
    [~, mixed_grps] = SSC(rInX, 0, false, 20, false, 1, length(rRep));
    mixed_labels = [];
    if size(rOutX, 2) > 0
        not_rep_labels = OutSample(rInX, rOutX, mixed_grps);
        mixed_labels([rRep, rNotRep]) = [mixed_grps', not_rep_labels];
    else
        warning('RSSC has used all datapoints as representatives')
        mixed_labels(rRep) = mixed_grps';
    end
    err.rssc(iter, 3) = Misclassification(mixed_labels', labels);
    dur.rssc(iter, 3) = toc + rssc_duration;
    
    iter = iter + 1;
end

% SSSC
err.sssc = zeros(length(pLandmarks), 1);
dur.sssc = zeros(length(pLandmarks), 1);
iter = 1;
for landmarks = pLandmarks
    fprintf('SSSC, '); tic;
    [sssc_labels, ~, ~] = sssc(x, landmarks, n);
    err.sssc(iter) = Misclassification(sssc_labels, labels);
    dur.sssc(iter) = toc;
    
    iter = iter + 1;
end

% HSSC
err.hssc = zeros(length(hAlphas), 3);
dur.hssc = zeros(length(hAlphas), 3);
iter = 1;
for a = hAlphas
    fprintf('HSSC (a=%d), ', a); tic;
    [hRep, hC] = hssc(x, a, hMaxRep);
    hC(hC < 0) = 0;
    hNotRep = setdiff(1:size(x,2), hRep);
    hInX = x(:, hRep);
    hOutX = x(:, hNotRep);
    hC = hC - diag(diag(hC));
    hssc_duration = toc;
    
    % Missrate hssc with all datapoints
    fprintf('HSSC all, '); tic;
    [hCSym1, ~] = BuildAdjacency(hC, 0);
    hGrps1 = SpectralClustering(hCSym1, n);
    err.hssc(iter, 1) = Misclassification(hGrps1, labels);
    dur.hssc(iter, 1) = toc + hssc_duration;

    % Missrate hssc with only representatives
    fprintf('HSSC rep, '); tic;
    [hCSym2, ~] = BuildAdjacency(hC(hRep, hRep), 0);
    hGrps2 = SpectralClustering(hCSym2, n);
    hLabels1 = [];
    if size(hOutX, 2) > 0
        hOutLabels1 = OutSample(hInX, hOutX, hGrps2);
        hLabels1([hRep, hNotRep]) = [hGrps2', hOutLabels1];
    else
        warning('HSSC has used all datapoints as representatives')
        hLabels1(hRep) = hGrps2';
    end
    err.hssc(iter, 2) = Misclassification(hLabels1', labels);
    dur.hssc(iter, 2) = toc + hssc_duration;

    % Missrate hssc with ssc of representatives
    fprintf('HSSC mix'); tic;
    hSscLabels = labels(hRep);
    [~, hSscGrps] = SSC(hInX, 0, false, 20, false, 1, length(hRep));
    hLabels2 = [];
    if size(hOutX, 2) > 0
        hOutLabels2 = OutSample(hInX, hOutX, hSscGrps);
        hLabels2([hRep, hNotRep]) = [hSscGrps', hOutLabels2];
    else
        warning('HSSC has used all datapoints as representatives')
        hLabels2(hRep) = hSscGrps';
    end
    err.hssc(iter, 3) = Misclassification(hLabels2', labels);
    dur.hssc(iter, 3) = toc + hssc_duration;
    
    iter = iter + 1;
end

end

