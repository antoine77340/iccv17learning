function res = linbcfwopt(X,lambda,nConst,k,kapa,blocks,block_square,slack_block,prob,n_iter)

X = full(X);   
X = double(X);
X = cat(2,X,100*ones(size(X,1),1));
n = size(X,1);

n_iter

T = zeros(n*k+nConst,1);

params.MSK_IPAR_LOG = 0;
n_blocks = length(blocks);
for i=1:n_blocks
    prob(i).c = rand(length(blocks{i}),1);
    [~,res] = mosekopt('minimize echo(0)',prob(i),params);
    Ti = res.sol.itr.xx;
    T(blocks{i}) = Ti;
end



fprintf('building P ...\n');

P = build_PQ(X,lambda);
fprintf('done ! ...\n');


% Init a Z in the convex hull
fprintf('Begin LINBCFW iterations ...\n');
gap = 10*ones(length(blocks),1);

samples = rand(n_iter+1,1);
Z = reshape(T(1:n*k),n,k);

fprintf('init W ...\n');

W = P*Z;

total = size(X,1);
display_loss_value = 0;
gap_values = [];
e_time = [];
epoch_update = 10;
gap_update = epoch_update*total;
tic;

fprintf('building blocks ...\n');
for i=1:n_blocks
    fprintf('preparing block: %d \n',i);
    X_block{i} = X(block_square{i},:);
end
fprintf('done ! \n');
c = 0;
%clear X;
for i=1:n_blocks
    i
    P_block{i} = P(:,block_square{i});
end

clear P;

display = 10;
n_blocks
tic;
for i=1:n_iter
   if mod(i,1000) == 0
        
        fprintf('updating gap block ...\n');
        Z = reshape(T(1:n*k),n,k);
        for j=1:n_blocks
            fprintf('block : %d\n',j);
            current_block = blocks{j};
            current_block_square = block_square{j};
            current_slack_block = slack_block{j};

                
            % computing gradient with the trick 
            grad = Z(current_block_square,:) - X_block{j}*W;
            grad = reshape(grad,[],1);

            %add slacks to the gradient
            if length(current_slack_block) > 0
                slacks = T(n*k+1:end); 
                grad = cat(1,grad,n*kapa*slacks(current_slack_block));
            end
           
            prob(j).c = grad;
           
            [~,Tmin] = mosekopt('minimize echo(0)',prob(j));
            Tmin = Tmin.sol.itr.xx;

            diff = T(current_block)-Tmin;

            gap(j) = diff'*grad;
            gap(j) = 1/n*gap(j);  
        end
        total_gap = sum(gap);
        gap_values = [gap_values; total_gap];
        tt = toc;
        e_time = [e_time;tt];
        fprintf('Gap: %.4e  ------------------------------------\n',total_gap);
        %{
        Z = reshape(T(1:n*k),n,k);
        aux2 = Z.*(Z-X*(P*Z));
        d_slacks = T(n*k+1:end);

        loss = sum(aux2(:))/n + kapa*norm(d_slacks)^2;
        toc;
        %}
    end

    %adaptatively sampling a block
    r = samples(i+1);
    
    prob_distribution = [0;cumsum(gap(:))/sum(gap)];
    [~,j] = histc(r,prob_distribution);
    
    current_block = blocks{j};
    current_block_square = block_square{j};
    current_slack_block = slack_block{j};
   
    if mod(i,display) == 0
        fprintf(sprintf('iteration: %02d \t',i));
    end
 
     
    Z = reshape(T(current_block(1:end-length(current_slack_block))),[],k);   
    
    % computing gradient with the trick 
    grad = Z - X_block{j}*W;
    c = c + size(X_block{j},1);

    grad = reshape(grad,[],1);

    %add slacks to the gradient
    if length(current_slack_block) > 0
        slacks = T(n*k+1:end); 
        grad = cat(1,grad,n*kapa*slacks(current_slack_block));
    end
   
    prob(j).c = grad;
    [~,Tmin] = mosekopt('minimize echo(0)',prob(j));
    Tmin = Tmin.sol.itr.xx;
    diff = T(current_block)-Tmin;

    gap(j) = diff'*grad;
    gap(j) = 1/n*gap(j);
  
    
    diff_square = reshape(diff(1:end-length(current_slack_block)),[],k);
     
    
    if length(current_slack_block) > 0
        d_slacks = diff(end+1-length(current_slack_block):end);
        n_slacks = kapa*norm(d_slacks)^2;
    else
        n_slacks = 0;
    end

    precomp = (P_block{j}*diff_square);
    aux = diff_square.*(diff_square-X_block{j}*precomp);   
    aux = 1/n*sum(aux(:)) + n_slacks;
   
    %aux = compute_loss(diff);

    gamma_rate = min(1,gap(j)/aux);
    %gamma_rate = 2*66/(n_iter+2*66);    

    W = W - gamma_rate*precomp;  

    T(current_block) = T(current_block) -  gamma_rate*diff;
 
    if mod(i,display) == 0
        if display_loss_value
            T_current = T(current_block);
            T_square = reshape(T_current(1:end-length(current_slack_block)),[],k);
                         
            if length(current_slack_block) > 0
                d_slacks = T_current(end+1-length(current_slack_block):end);
                n_slacks = kapa*norm(d_slacks)^2;
            else
                n_slacks = 0;
            end

            block_loss = T_square.*(T_square-X(current_block_square,:)*(P(:,current_block_square)*T_square));   
            block_loss = 1/n*sum(block_loss(:)) + n_slacks;

            fprintf('Block gap %d value: %.3e - gamma: %.3e - block loss: %.3e\n',j,gap(j),gamma_rate,block_loss);
       else           
           fprintf('Block gap %d value: %.3e - gamma: %.3e\n',j,gap(j),gamma_rate);
       end
    end
end
res = reshape(T(1:n*k),n,k);

end
