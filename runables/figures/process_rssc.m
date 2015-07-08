clean

dir = 'fig/rssc';
mkdir(dir);

range = [-.2, .4]
dataset = 2;
subsets = 3;
[ x, labels, N, d, n, D, noise, cos ] = get_data(dataset, subsets);

alpha = 6;
r = 0;
verbose = false;
[repInd, C] = rssc(x, alpha, r, verbose);
length(repInd)

clf;
imshow(C, range);
colormap jet
name = [dir, '/CMat'];
savefig(name)
export_fig(name, '-dpng', '-transparent', '-m10')

clf;
imshow(zeros(size(C, 2), 1), range);
colorbar()
colormap jet;
name = [dir, '/colorbar'];
savefig(name)
export_fig(name, '-dpng', '-transparent', '-m10')