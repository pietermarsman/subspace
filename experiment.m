function [ err, mut, dur, pred, cs, rep, names ] = experiment( x, labels, n, sAlphas, rAlphas, hAlphas, hMaxReps, pReps, pLambda, pTol )
%EXPERIMENT Summary of this function goes here
%   Detailed explanation goes here

%% Experiment params
verbose = true;
useAll = false;
useRep = true;
useNoRep = true;
numUses = useAll + useRep + useNoRep; 

nExp = length(sAlphas) + length(rAlphas) * numUses + ...
    length(hAlphas) * length(hMaxReps) * numUses + ...
    length(pReps) * length(pLambda) * length(pTol);
N = length(labels);
err = zeros(nExp, 1);
mut = zeros(nExp, 1);
dur = zeros(nExp, 1);
pred = zeros(nExp, N);
iter = 1;

%% Constants
sR = 0; % projection dimension
sAffine = false;
sAlpha = 5; % default ssc alpha
sOutlier = false; % if there are outliers
sRho = 1; % coefficient threshold
sK = 0; % number of strongest coefficients to keep
nonNegative = false;

%% SSSC params
par.nClass = n;
par = L1ParameterConfig(par);
par.lambda = 1e-7;
par.tolerance = 1e-3;


%% SSC
for a = sAlphas
    name = before(sprintf('SSC(a=%d)', a));
    [C, ssc_pred] = SSC(x, sR, sAffine, a, sOutlier, sRho, n);
    [dur(iter), err(iter), mut(iter), names{iter}, cs{iter}, rep{iter}] = ...
        after(name, ssc_pred, labels, C, 1:N, 0, iter);
    iter = iter + 1;
end

%% RSSC
for a = rAlphas
    before('RSSC');
    [rRep, rC] = rssc(x, a, sR, nonNegative, false);
    [rNotRep, rInX, rOutX] = divide_dataset(x, rRep);
    [rDur, ~, ~, ~, cs{iter}, ~] = ...
        after([], [], [], rC, [], 0, iter);
    
    % RSSC with all datapoints
    if useAll
        name = before(sprintf('RSSC_all(a=%d)', a));
        [C_sym, ~] = BuildAdjacency(rC, sK);
        rssc1_pred = SpectralClustering(C_sym, n);
        [dur(iter), err(iter), mut(iter), names{iter}, ~, rep{iter}] = ...
            after(name, rssc1_pred, labels, [], 1:N, rDur, iter);
        iter = iter + 1;
    end
    
    % RSSC with SSSC of representatives
    if useRep
        name = before(sprintf('RSSC_rep(a=%d)', a));
        rSGrps = InSample(rInX, par.lambda, par.tolerance, par, par.nClass)';
        rssc2_pred = InOutSample(rInX, rOutX, rRep, rNotRep, rSGrps, verbose);
        [dur(iter), err(iter), mut(iter), names{iter}, ~, rep{iter}] = ...
            after(name, rssc2_pred', labels, [], rRep, rDur, iter);
        iter = iter + 1;
    end
    
    % RSSC with SSSC of non-representatives
    if useNoRep
        name = before(sprintf('RSSC_no(a=%d)', a));
        rssc3_pred = rssc_cluster(x, rRep, 0.2, n);
        [dur(iter), err(iter), mut(iter), names{iter}, ~, rep{iter}] = ...
            after(name, rssc3_pred', labels, [], rNotRep, rDur, iter);
        iter = iter + 1;
    end
end

%% SSSC
for pRep = pReps
    for tol = pTol
        for lambda = pLambda
            name = before(sprintf('SSSC(r=%d,t=%d,l=%d)', pRep, log10(tol), log10(lambda)));
            [sssc_pred, reps, ~] = sssc(x, pRep, n, lambda, tol, nonNegative);
            [dur(iter), err(iter), mut(iter), names{iter}, ~, rep{iter}] = ...
                after(name, sssc_pred, labels, [], reps, 0, iter);
            iter = iter + 1;
        end
    end
end

%% HSSC
hMaxReps = check_reps(hMaxReps, N);
for a = hAlphas
    for maxRep = hMaxReps
        name = before(sprintf('HSSC(a=%d,r=%d):', a, maxRep)); 
        [hRep, hC] = hssc(x, a, maxRep, nonNegative, verbose);
        [hNotRep, hInX, hOutX] = divide_dataset(x, hRep);
        [hDur, ~, ~, ~, cs{iter}, ~] = ...
            after(name, [], [], hC, [], 0, iter);

        % HSSC with all datapoints
        if useAll
            name = before(sprintf('HSSC_all(a=%d,r=%d)', a, maxRep));
            [hCSym, ~] = BuildAdjacency(hC, sK);
            h1_pred = SpectralClustering(hCSym, n);
            [dur(iter), err(iter), mut(iter), names{iter}, cs{iter}, rep{iter}] = ...
                after(name, h1_pred, labels, hC, 1:N, hDur, iter);
            iter = iter + 1;
        end

        % HSSC with SSSC of representatives
        if useRep
            name = before(sprintf('HSSC_sssc(a=%d,r=%d)', a, maxRep));
            hSGrps = InSample(hInX, par.lambda, par.tolerance, par, par.nClass)';
            h2_pred = InOutSample(hInX, hOutX, hRep, hNotRep, hSGrps, verbose);
            [dur(iter), err(iter), mut(iter), names{iter}, ~, rep{iter}] = ...
                after(name, h2_pred', labels, [], hRep, hDur, iter);
            iter = iter + 1;
        end
        
        % HSSC with SSSC of non-representatives
        if useNoRep
            name = before(sprintf('HSSC_no(a=%d)', a));
            h3_pred = rssc_cluster(x, hRep, 0.2, n);
            [dur(iter), err(iter), mut(iter), names{iter}, ~, rep{iter}] = ...
                after(name, h3_pred', labels, [], hNotRep, hDur, iter);
            iter = iter + 1;
        end
    end
    
end

end

%% Functions

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

function [reps] = check_reps(reps, N)
    if ~isempty(reps)
        reps(reps > N) = [];
    end
    if isempty(reps)
        reps = [N];
    end
end

function [notRep, inX, outX] = divide_dataset(x, rep)
    notRep = setdiff(1:size(x,2), rep);
    inX = x(:, rep);
    outX = x(:, notRep);
end

function [name] = before(name)
    fprintf('%s, ', name);
    tic;
end

function [d, e, m, n, c, r] = after(name, pred, labels, C, rep, dur, iter)
    d = toc + dur;
    if length(pred) + length(labels) > 0
        e = Misclassification(pred, labels);
        m = MutualInfo(pred, labels);
    else
        e = 0;
        m = 0;
    end
    n = name;
    c = C;
    r = rep;
end