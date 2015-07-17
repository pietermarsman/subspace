function [ e, m, d, p, cs, rep, names ] = experiment( x, labels, n, varargin )
%EXPERIMENT Summary of this function goes here
%   Detailed explanation goes here

%% Parse input
p = inputParser;
addOptional(p, 'sAlphas', []);
addOptional(p, 'r', 0);
addOptional(p, 'affine', false);
addOptional(p, 'sOutlier', false);
addOptional(p, 'sRho', 1.0);
addOptional(p, 'sK', 0);
addOptional(p, 'useAll', false);
addOptional(p, 'useRep', true);
addOptional(p, 'useNoRep', true);
addOptional(p, 'rAlphas', []);
addOptional(p, 'hAlphas', []);
addOptional(p, 'hReps', [size(x, 2)]);
addOptional(p, 'pReps', []);
addOptional(p, 'pLambdas', 1e-7);
addOptional(p, 'pTols', 1e-3);
addOptional(p, 'nonnegative', false);
addOptional(p, 'verbose', false);
parse(p,varargin{:});

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
hAlphas = p.Results.hAlphas;
hReps = p.Results.hReps;
pReps = p.Results.pReps;
pLambdas = p.Results.pLambdas;
pTols = p.Results.pTols;
nonNegative = p.Results.nonnegative;

%% Experiment params
verbose = p.Results.nonnegative;
numUses = useAll + useRep + useNoRep; 

nExp = length(sAlphas) + length(rAlphas) * numUses + ...
    length(hAlphas) * length(hReps) * numUses + ...
    length(pReps) * length(pLambdas) * length(pTols);
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
for a = sAlphas
    name = before(sprintf('SSC(a=%d)', a));
    [C, ssc_pred] = SSC(x, r, affine, a, sOutlier, sRho, n);
    [d(i), e(i), m(i), names{i}, cs{i}, rep{i}] = ...
        after(name, ssc_pred, labels, C, 1:N, 0);
    i = i + 1;
end

%% RSSC
for a = rAlphas
    before('RSSC');
    [rRep, rC] = rssc(x, a, r, affine, nonNegative, false);
    [rNotRep, rInX, rOutX] = divide_dataset(x, rRep);
    [rDur, ~, ~, ~, cs{i}, ~] = after([], [], [], rC, [], 0);
    
    % RSSC with all datapoints
    if useAll
        name = before(sprintf('RSSC_all(a=%d)', a));
        [C_sym, ~] = BuildAdjacency(rC, sK);
        rssc1_pred = SpectralClustering(C_sym, n);
        [d(i), e(i), m(i), names{i}, ~, rep{i}] = ...
            after(name, rssc1_pred, labels, [], 1:N, rDur);
        i = i + 1;
    end
    
    % RSSC with SSSC of representatives
    if useRep
        name = before(sprintf('RSSC_rep(a=%d)', a));
        rSGrps = InSample(rInX, par.lambda, par.tolerance, par, par.nClass)';
        rssc2_pred = InOutSample(rInX, rOutX, rRep, rNotRep, rSGrps, verbose);
        [d(i), e(i), m(i), names{i}, ~, rep{i}] = ...
            after(name, rssc2_pred', labels, [], rRep, rDur);
        i = i + 1;
    end
    
    % RSSC with SSSC of non-representatives
    if useNoRep
        name = before(sprintf('RSSC_no(a=%d)', a));
        rssc3_pred = rssc_cluster(x, rRep, 0.2, n);
        [d(i), e(i), m(i), names{i}, ~, rep{i}] = ...
            after(name, rssc3_pred', labels, [], rNotRep, rDur);
        i = i + 1;
    end
end

%% SSSC
pReps = check_reps(round(pReps * N), N);
for pRep = pReps
    for tol = pTols
        for lambda = pLambdas
            name = before(sprintf('SSSC(r=%d,t=%d,l=%d)', pRep, log10(tol), log10(lambda)));
            [sssc_pred, reps, ~] = sssc(x, pRep, n, lambda, tol, nonNegative);
            [d(i), e(i), m(i), names{i}, ~, rep{i}] = ...
                after(name, sssc_pred, labels, [], reps, 0);
            i = i + 1;
        end
    end
end

%% HSSC
hReps = check_reps(hReps, N);
for a = hAlphas
    name = before(sprintf('HSSC(a=%d)', a)); 
    [hRep, hC] = hssc(x, a, affine, nonNegative, verbose);
    [hNotRep, hInX, hOutX] = divide_dataset(x, hRep);
    [hDur, ~, ~, ~, cs{i}, ~] = ...
        after(name, [], [], hC, [], 0);

    % HSSC with all datapoints
    if useAll
        name = before(sprintf('HSSC_all(a=%d)', a));
        [hCSym, ~] = BuildAdjacency(hC, sK);
        h1_pred = SpectralClustering(hCSym, n);
        [d(i), e(i), m(i), names{i}, cs{i}, rep{i}] = ...
            after(name, h1_pred, labels, hC, 1:N, hDur);
        i = i + 1;
    end

    % HSSC with SSSC of representatives
    if useRep
        name = before(sprintf('HSSC_rep(a=%d)', a));
        hSGrps = InSample(hInX, par.lambda, par.tolerance, par, par.nClass)';
        h2_pred = InOutSample(hInX, hOutX, hRep, hNotRep, hSGrps, verbose);
        [d(i), e(i), m(i), names{i}, ~, rep{i}] = ...
            after(name, h2_pred', labels, [], hRep, hDur);
        i = i + 1;
    end

    % HSSC with SSSC of non-representatives
    if useNoRep
        name = before(sprintf('HSSC_no(a=%d)', a));
        h3_pred = rssc_cluster(x, hRep, 0.2, n);
        [d(i), e(i), m(i), names{i}, ~, rep{i}] = ...
            after(name, h3_pred', labels, [], hNotRep, hDur);
        i = i + 1;
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