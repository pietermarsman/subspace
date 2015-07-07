function [ x, labels, N, d, n, D, noise, cos ] = get_data( dataset, n, varargin )
%SETUP_DATA Summary of this function goes here
%   Detailed explanation goes here


p = inputParser;
addOptional(p, 'noise', 0.0);
addOptional(p, 'cos', 0.5);
addOptional(p, 'N', 1000);
addOptional(p, 'D', 500);
addOptional(p, 'Di', 10);

parse(p,varargin{:});
noise = p.Results.noise;
cos = p.Results.cos;
N = p.Results.N;
D = p.Results.D;
d = p.Results.Di;

% Dataset
if dataset == 1
    [~, ~, x, labels] = linear_subspace(N, d, n, D, cos, noise);
elseif dataset == 2
    load('datasets/YaleBCrop025.mat');
    N = size(Y, 2) * n;
    d = 11;
    D = size(Y, 1);
    noise = -1;
    cos = -1;
    yaleX = Y(:, :, 1:n);
    x = reshape(yaleX, size(yaleX, 1), []);
    labels = s{n};
else
    error('Dataset should be between 1 and 2')
end

x = normc(x);

end
