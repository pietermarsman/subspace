function [ e, m, d, p, cs, rep, names ] = experiment( x, labels, n, algo, varargin )
%EXPERIMENT Summary of this function goes here
%   Detailed explanation goes here

%% Parse input
p = inputParser;
addOptional(p, 'sAlphas', 5);
addOptional(p, 'r', 0);
addOptional(p, 'affine', false);
addOptional(p, 'sOutlier', false);
addOptional(p, 'sRho', 1.0);
addOptional(p, 'sK', 0);
addOptional(p, 'useAll', false);
addOptional(p, 'useRep', true);
addOptional(p, 'useNoRep', true);
addOptional(p, 'rAlphas', 50);
addOptional(p, 'rLambda', 1e-7);
addOptional(p, 'rTol', 1e-3);
addOptional(p, 'hAlphas', 50);
addOptional(p, 'numreps', .1);
addOptional(p, 'pLambdas', 1e-7);
addOptional(p, 'pTols', 1e-3);
addOptional(p, 'nonnegative', false);
addOptional(p, 'verbose', false);
parse(p,varargin{:});

if length(algo) ~= 4
    error('Length of algo should be 4')
end

%% Algorithm parameters
sAlphas = p.Results.sAlphas;
r = p.Results.r;                        % projection dimension
affine = p.Results.affine;
sOutlier = p.Results.sOutlier;          % if there are outliers
sRho = p.Results.sRho;                  % coefficient threshold
sK = p.Results.sK;                      % number of strongest coefficients to keep
useAll = p.Results.useAll;
useRep = p.Results.useRep;
useNoRep = p.Results.useNoRep;
rAlphas = p.Results.rAlphas;
rLambda = p.Results.rLambda;
rTol = p.Results.rTol;
hAlphas = p.Results.hAlphas;
hLambda = rLambda;
hTol = rTol;
numreps = check_reps(round(p.Results.numreps * length(labels)), length(labels));
pLambdas = p.Results.pLambdas;
pTols = p.Results.pTols;
nonNegative = p.Results.nonnegative;

%% Experiment params
verbose = p.Results.nonnegative;

nExp = algo(1) * length(sAlphas) ...
    + algo(2) * length(rAlphas) * useAll ...
    + algo(2) * length(rAlphas) * length(numreps) * (useRep + useNoRep) ...
    + algo(4) * length(hAlphas) * useAll ...
    + algo(4) * length(hAlphas) * length(numreps) * (useRep + useNoRep) ...
    + algo(3) * length(numreps) * length(pLambdas) * length(pTols);
N = length(labels);
e = zeros(nExp, 1);
m = zeros(nExp, 1);
d = zeros(nExp, 1);
p = zeros(nExp, N);
cs = cell(nExp, 1);
rep = cell(nExp, 1);
names = cell(nExp, 1);
i = 1;

%% SSSC params
par.nClass = n;
par = L1ParameterConfig(par);
par.lambda = 1e-7;
par.tolerance = 1e-3;


%% SSC
if algo(1)
    for a = sAlphas
        name = before(sprintf('SSC(a=%f)', a));
        [C, ssc_pred] = SSC(x, r, affine, a, sOutlier, sRho, n);
        [d(i), e(i), m(i), names{i}, cs{i}, rep{i}] = ...
            after(name, ssc_pred, labels, C, 1:N, 0);
        i = i + 1;
    end
end

%% RSSC
if algo(2)
    for a = rAlphas
        before('RSSC');
        [rRep, rC] = rssc(x, a, r, affine, nonNegative, false);
        [rNotRep, rInX, rOutX] = divide_dataset(x, rRep);
        [rDur, ~, ~, ~, cs{i}, ~] = after([], [], [], rC, [], 0);

        % RSSC with all datapoints
        if useAll
            name = before(sprintf('RSSC_all(a=%f)', a));
            [C_sym, ~] = BuildAdjacency(rC, sK);
            r1_pred = SpectralClustering(C_sym, n);
            [d(i), e(i), m(i), names{i}, ~, rep{i}] = ...
                after(name, r1_pred, labels, [], 1:N, rDur);
            i = i + 1;
        end

        
        for numrep = numreps
            % RSSC with SSSC of representatives
            if useRep
                name = before(sprintf('RSSC_rep(a=%f,r=%d)', a, numrep));
                r2_pred = sssc(x, rRep, numrep, n, rLambda, rTol);
                [d(i), e(i), m(i), names{i}, ~, rep{i}] = ...
                    after(name, r2_pred', labels, [], rRep, rDur);
                i = i + 1;
            end

            % RSSC with SSSC of non-representatives
            if useNoRep
                name = before(sprintf('RSSC_no(a=%f,r=%d)', a, numrep));
                r3_pred = sssc(x, rNotRep, numrep, n, rLambda, rTol);
                [d(i), e(i), m(i), names{i}, ~, rep{i}] = ...
                    after(name, r3_pred', labels, [], rNotRep, rDur);
                i = i + 1;
            end
        end
    end
end

%% SSSC
if algo(3)
    for numrep = numreps
        for tol = pTols
            for lambda = pLambdas
                name = before(sprintf('SSSC(r=%f,t=%f,l=%f)', numrep, log10(tol), log10(lambda)));
                [p_pred, pReps, ~] = sssc(x, 1:size(x, 2), numrep, n, lambda, tol);
                [d(i), e(i), m(i), names{i}, ~, rep{i}] = ...
                    after(name, p_pred', labels, [], pReps, 0);
                i = i + 1;
            end
        end
    end
end

%% HSSC
if algo(4)
    for a = hAlphas
        name = before(sprintf('HSSC(a=%f)', a)); 
        [hRep, hC] = hssc(x, a, affine, nonNegative, verbose);
        [hNotRep, hInX, hOutX] = divide_dataset(x, hRep);
        [hDur, ~, ~, ~, cs{i}, ~] = ...
            after(name, [], [], hC, [], 0);

        % HSSC with all datapoints
        if useAll
            name = before(sprintf('HSSC_all(a=%f)', a));
            [hCSym, ~] = BuildAdjacency(hC, sK);
            h1_pred = SpectralClustering(hCSym, n);
            [d(i), e(i), m(i), names{i}, cs{i}, rep{i}] = ...
                after(name, h1_pred, labels, hC, 1:N, hDur);
            i = i + 1;
        end

        for numrep = numreps
            % HSSC with SSSC of representatives
            if useRep
                name = before(sprintf('HSSC_rep(a=%f,r=%d)', a, numrep));
                h2_pred = sssc(x, numrep, numrep, n, hLambda, hTol);
                [d(i), e(i), m(i), names{i}, ~, rep{i}] = ...
                    after(name, h2_pred', labels, [], hRep, hDur);
                i = i + 1;
            end

            % HSSC with SSSC of non-representatives
            if useNoRep
                name = before(sprintf('HSSC_no(a=%f,r=%d)', a, numrep));
                h3_pred = sssc(x, hNotRep, numrep, n, hLambda, hTol);
                [d(i), e(i), m(i), names{i}, ~, rep{i}] = ...
                    after(name, h3_pred', labels, [], hNotRep, hDur);
                i = i + 1;
            end
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
        if isempty(reps)
            reps = [N];
        end
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

function [d, e, m, n, c, r] = after(name, pred, labels, C, rep, dur)
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