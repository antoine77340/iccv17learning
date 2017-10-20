function [Y, linear_constraint,blocks,slack_blocks] = build_action_bags(params, movie_block,movie_bag,bags, X, GT, tframes,T ,mapping)
% the variable with the opposite latent variable is called here T but its
% true value depend on the direction of optimization

N = size(X, 1);
P  = max(GT);

blocks = movie_block;
n_movies = length(movie_block);
% checking which track is in which bag
A = tracks_in_bag(bags, tframes);

eS = zeros(N, 1);
eC = zeros(P, 1);


for i=1:n_movies
    mask = sum(A(movie_bag{i},:),1) == 0;
    unconstrained_tracks{i} = intersect(find(mask),movie_block{i});
    %block2 = unconstrained_tracks;
    %block1 = find(sum(A(:,movie_block{1}),1) > 0);
    %n_unconstrained_tracks = length(unconstrained_tracks);
end
% number of bags
I = size(A,1);


k = 1;

decay = 0;

ls = linspace(0,1,decay+2);

% switching from frame position to track indexgt
linear_constraint = struct();

slack_blocks = movie_bag;

I = size(A,1);

for i = 1:I
    sidx = find(A(i, :)>0);
    cidx = bags(i).action; 
    
    if length(sidx) >= 0
        
        if decay > 0
            msidx = min(sidx);
            Msidx = max(sidx);

            lsidx = msidx - (1:decay);
            rsidx = Msidx + (1:decay);
            sidx = [lsidx sidx rsidx];
    
        end
    
        linear_constraint(k).sample = eS;
        linear_constraint(k).sample(sidx) = 1;
        linear_constraint(k).class = eC;
        linear_constraint(k).class(cidx) = 1;
        linear_constraint(k).type = 'geq';
        linear_constraint(k).val = params.alpha;
        linear_constraint(k).slack = 1;
        
        if decay > 0
            linear_constraint(k).weights = [ls(2:end-1)';ones(length(sidx)-2*decay,1);ls(end-1:-1:2)'];
        else
            if bags(i).people > 0
                linear_constraint(k).weights = T(mapping(sidx),bags(i).people);
            else
                linear_constraint(k).weights = ones(length(sidx),1);
            end
        end

        k = k+1;
    end
end

    
%% WEAK-SUPERVISION CONSTRAINT FOR BACKGROUND %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:n_movies
    linear_constraint(k).sample = eS;
    linear_constraint(k).sample(unconstrained_tracks{i}) = 1;
    linear_constraint(k).class = eC;
    linear_constraint(k).class(1) = 1;
    linear_constraint(k).type = 'geq';
    linear_constraint(k).val = params.alpha_2*length(unconstrained_tracks{i});
    linear_constraint(k).slack = 0;
    linear_constraint(k).weights = ones(length(unconstrained_tracks{i}),1);
    k = k+1;
end

Y = full(sparse(1:length(GT), GT, 1));

end
