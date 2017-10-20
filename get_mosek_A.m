function [ A, blc, buc ] = get_mosek_A( linear_constraint, B, alpha,alpha_2, n, P)


caca = 0;


nXi = sum(cat(1, linear_constraint.slack));
nC = length(linear_constraint);

A_subi = [];
A_subj = [];
A_subv = [];


% adding the row sum to one constraint
for i = 1:n
    A_subi = cat(1, A_subi, i*ones(P,1));
    A_subj = cat(1, A_subj, n*(0:(P-1))'+i);
    A_subv = cat(1, A_subv, ones(P,1));
end

blc = ones(n, 1);
buc = ones(n, 1);

ti = cell(nXi, 1);
tj = cell(nXi, 1);
tv = cell(nXi, 1);
tl = cell(nXi, 1);
tu = cell(nXi, 1);

% adding the linear constraints
for i = 1:nC
    sample = linear_constraint(i).sample;
    class = linear_constraint(i).class;
    slack = linear_constraint(i).slack;
    idx = find(kron(class, sample));
    weights = linear_constraint(i).weights;

    ti{i} = (n+i) * ones(length(idx), 1);
    tj{i} = idx;
    %tv{i} = ones(length(idx), 1);
    tv{i} = weights;
    
    if slack~=0
        ti{i} = [ti{i}; n+i];
        tj{i} = [tj{i}; (n*P)+i];
        tv{i} = [tv{i}; slack];
    end
    
    value = linear_constraint(i).val;
    
    if strcmp(linear_constraint(i).type, 'geq')
        tl{i} = value;
        tu{i} = inf;
    elseif strcmp(linear_constraint(i).type, 'leq')
        tl{i} = -inf;
        tu{i} = value;
    else
        tl{i} = value;
        tu{i} = value;
    end
end

ti = cell2mat(ti);
tj = cell2mat(tj);
tv = cell2mat(tv);
tl = cell2mat(tl);
tu = cell2mat(tu);

A_subi = cat(1, A_subi, ti);
A_subj = cat(1, A_subj, tj);
A_subv = cat(1, A_subv, tv);
blc = cat(1, blc, tl);
buc = cat(1, buc, tu);


A_C = sparse(A_subi, A_subj, A_subv, n+nC, 2*(n*P) + nXi);

% adding the norm auxiliary variable
Bs = sparse(B);
Is = sparse(eye(P));
A_N = cat(2, kron(Is, Bs), sparse(n*P, nXi), -sparse(1:(n*P), 1:(n*P), 1));

A = cat(1, A_C, A_N);


blc = cat(1, blc, zeros(n*P, 1));
buc = cat(1, buc, zeros(n*P, 1));

end

