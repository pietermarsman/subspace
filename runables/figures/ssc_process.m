clear all;
close all;

dir = 'fig/ssc';
mkdir(dir);

N = 30;
d = 10;
S = 3;
D = 100;
cos = 0.0;
noise = 0.0;

[~, ~, x, labels] = linear_subspace(N, d, S, D, cos, noise);

CMat = admmLasso_mat_func(x, false, 5);
[CKSym, CKAbs] = BuildAdjacency(thrC(CMat,1.0));
grps = SpectralClustering(CKSym,S);

clf;
imshow(CMat, [min(min(CMat)), max(max(CMat))]);
colormap jet
name = [dir, '/CMat'];
savefig(name)
export_fig(name, '-dpng', '-transparent', '-m10')

lim = [min(min([CKSym, CKAbs])), max(max([CKSym, CKAbs]))];
clf;
imshow(CKSym, lim);
colormap jet
name = [dir, '/CKSym'];
savefig(name)
export_fig(name, '-dpgn', '-transparent', '-m10')

clf;
imshow(CKAbs, lim);
colormap jet
name = [dir, '/CKAbs'];
savefig(name)
export_fig(name, '-dpng', '-transparent', '-m10')
