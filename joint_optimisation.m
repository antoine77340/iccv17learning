function [restemp,pred] = joint_optimisation(X)

load('data_block.mat');
load('bags.mat');
load('Z_total.mat');
load('track_map.mat');
load('scene_cast.mat');

Z = [Z;0.1*ones(1,40)];
tframes = tframes_total;

GTa = 14*ones(size(X,1),1);
P = max(GTa);
N = size(X,1);
resultA = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% action clustering %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

params = init_action_params();
params.neg_bag = false;
[restemp, pred] = weak_square_loss(params, merge_bag, tframes, X, GTa, Z,[],movie_block,movie_bag,track_map,0);

end

