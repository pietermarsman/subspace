function [ mat ] = rep2mat( rep, N )
%REP2VEC Summary of this function goes here
%   Detailed explanation goes here

matcell = cellfun(@(x) full(ind2vec(x, N)), rep, 'UniformOutput', false);
matcell = cellfun(@(x) repmat(linspace(1, 2, size(x, 2)), size(x, 1), 1) .* x, matcell, 'UniformOutput', false);
mat = cell2mat(cellfun(@(x) sum(x, 2)', matcell, 'UniformOutput', false));
mat = mat - 1;

end

