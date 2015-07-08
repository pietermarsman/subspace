clean

dir = 'fig/ssc';
mkdir(dir);

dataset = 2;
subsets = 2;
[ x, labels, N, d, n, D, noise, cos ] = get_data(dataset, subsets);

CMat = admmLasso_mat_func(x, false, 5);
[CKSym, CKAbs] = BuildAdjacency(thrC(CMat,1.0));
grps = SpectralClustering(CKSym,subsets);
lim = [min(min([CMat, CKSym, CKAbs])), max(max([CMat, CKSym, CKAbs]))]

clf;
imshow(CMat, lim);
colormap jet
name = [dir, '/CMat'];
savefig(name)
export_fig(name, '-dpng', '-transparent', '-m10')

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

clf;
imshow(zeros(size(CMat, 2), 1), lim);
colorbar()
colormap jet;
name = [dir, '/colorbar'];
savefig(name)
export_fig(name, '-dpng', '-transparent', '-m10')
