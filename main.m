
% path to the mosek toolbox folder
mosek_path = '/meleze/data0/amiech/CVPR2017/actor-action/mosek2/7/toolbox/r2009b';

% path to the mosek licence folder
mosek_license = '/meleze/data0/amiech/CVPR2017/actor-action/mosek2/mosek.lic';

% path to the cvx_setup.m file
cvx_path = '/meleze/data0/amiech/CVPR2017/actor-action/cvx/cvx_setup.m'; 


addpath(mosek_path);
setenv('MOSEKLM_LICENSE_FILE', mosek_license);
run(cvx_path);


load('X.mat');
Z =  joint_optimisation(X);
