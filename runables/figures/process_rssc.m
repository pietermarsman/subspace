clear all;
close all;

dir = 'fig/rssc';
mkdir(dir);

N = 30;
d = 3;
S = 3;
D = 100;
cos = 0.0;
noise = 0.0;
[~, ~, x, labels] = linear_subspace(N, d, S, D, cos, noise);

alpha = 6;
r = 0;
verbose = false;
[repInd, C] = rssc(x, alpha, r, verbose);
length(repInd)

clf;
imshow(C, [min(min(C)), max(max(C))]);
colormap jet
name = [dir, '/CMat'];
savefig(name)
export_fig(name, '-dpng', '-transparent', '-m10')
