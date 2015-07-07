function [ sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols ] ...
    = algo_param( varargin )
%ALGO_PARAM Summary of this function goes here
%   Detailed explanation goes here

p = inputParser;
addOptional(p, 'sAlphas', 5);
addOptional(p, 'rAlphas', 50);
addOptional(p, 'hAlphas', 50);
addOptional(p, 'hReps', 100);
addOptional(p, 'pReps', 100);
addOptional(p, 'pLambdas', 1e-7);
addOptional(p, 'pTols', 1e-3);

parse(p,varargin{:});
sAlphas = p.Results.sAlphas;
rAlphas = p.Results.rAlphas;
hAlphas = p.Results.hAlphas;
hReps = p.Results.hReps;
pReps = p.Results.pReps;
pLambdas = p.Results.pLambdas;
pTols = p.Results.pTols;

end

