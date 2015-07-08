clean

dir = 'fig/hssc';
mkdir(dir);

range = [-.2, .4];
dataset = 2;
subsets = 3;
[ x, labels, N, d, n, D, noise, cos ] = get_data(dataset, subsets);

alpha = 5
max_rep = 50;
verbose = true;

N = size(x, 2);
idx = randperm(N, N);
subsets = 2; % ceil(N / s);
s = N / subsets;

repInd = [];
hssc_repInd = [];
hssc_C = [];
C = zeros(N);

for i = [1:subsets]
    subset_start = round(s*(i-1)) + 1;
    subset_end = round(s*i);
    subset_idx = idx(subset_start:subset_end);
    [subset_rep, subset_C] = rssc(x(:, subset_idx), alpha, 0, false);
    
    % Show subset C
    clf;
    imshow(subset_C, range);
    colormap jet
    name = [dir, '/CMatSubset', num2str(i)];
    savefig(name)
    export_fig(name, '-dpng', '-transparent', '-m10')
    
    hssc_repInd = [hssc_repInd, subset_idx(subset_rep)];
    hssc_C(subset_idx, subset_idx) = subset_C;
end

% Show subset C
clf;
imshow(hssc_C, range);
colormap jet
name = [dir, '/HSSCCMat'];
savefig(name)
export_fig(name, '-dpng', '-transparent', '-m10')

if size(hssc_repInd, 2) >= size(x, 2)
    if verbose
        alpha = alpha * .5;
        warning(sprintf('Could not reduce number of representatives. Dividing alpha by 2.\nSize Y: %g. Alpha: %d', size(x, 2), alpha))
    end
    
end
size(hssc_repInd, 2)
if size(hssc_repInd, 2) > max_rep
    [repInd2, C2_] = hssc(x(:, hssc_repInd), alpha, max_rep, verbose);
    C(hssc_repInd, :) = C2_ * hssc_C(hssc_repInd, :);
    repInd = hssc_repInd(repInd2);
else
    repInd = hssc_repInd;
    C = hssc_C;
end

% Show subset C
clf;
imshow(C, range);
colormap jet
name = [dir, '/CMat', ];
savefig(name)
export_fig(name, '-dpng', '-transparent', '-m10')

clf;
imshow(zeros(size(C, 2), 1), range);
colorbar()
colormap jet;
name = [dir, '/colorbar'];
savefig(name)
export_fig(name, '-dpng', '-transparent', '-m10')