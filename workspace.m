!synclient HorizTwoFingerScroll=0
 
addpath(genpath('runables'))
addpath('fig')
addpath('misc')
addpath('utils')
addpath('datasets')

rmpath('libraries/figures')
rmpath('libraries/SMRS_v1.0')
rmpath('libraries/SSC_1.0')
rmpath('libraries/SSC_ADMM_v1.1')
rmpath(genpath('libraries/SSSC_code&Data_CVPR2013'))

addpath('libraries/figures')
addpath('libraries/SMRS_v1.0')
% addpath('libraries/SSC_1.0')
addpath('libraries/SSC_ADMM_v1.1')
addpath(genpath('libraries/SSSC_code&Data_CVPR2013'))

rng shuffle;

clean
