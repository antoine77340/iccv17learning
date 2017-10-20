function results = weak_square_loss(params, bags, tframes, K, GTf, T,scene_cast,movie_block,movie_bag,mapper,movie)

[Y, linear_constraint,sample_blocks,slack_blocks] = build_action_bags(params, movie_block,movie_bag,bags, K, GTf, tframes,T,mapper );
%
alpha       = params.alpha;
alpha_2     = params.alpha_2;
kapa        = params.kapa;
lambda      = params.lambda;

fprintf('init data done ! \n');
% fixing parameters of the minimization program
[n, P]  = size(Y);     % number of tracks / number of classes
nConst  = sum(cat(1, linear_constraint.slack));


%%% Create the block-separable linear constraints
for i=1:length(sample_blocks)  
    blocks{i} = get_blocks(sample_blocks{i}, n, P);
    blocks{i} = cat(2,blocks{i},(n*P+slack_blocks{i}));
end

[prob2.a, prob2.blc, prob2.buc]     = get_mosek_A_fw(linear_constraint, alpha,alpha_2, n, P);
[prob2.blx,~]                 = get_mosek_lx_fw(n, P, nConst,[]);


n_blocks = length(blocks);
for i=1:n_blocks
    [prob(i).a, prob(i).blc, prob(i).buc] = get_blockmosek_A(prob2,blocks{i});  
    [prob(i).blx,~] = get_blockmosek_lx(prob2,blocks{i});
end

%%%%%

Z = linbcfwopt(K,lambda,nConst,P,kapa,blocks,sample_blocks,slack_blocks,prob,params.n_iter);

results = Z;
end
