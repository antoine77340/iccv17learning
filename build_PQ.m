function [P] = build_PQ(X,lambda)


n = size(X,1);
d = size(X,2);

Id = eye(d);

%Pn = In - ones(n)/n;

%B = X.' * Pn * X + n * lambda * Id;
B = X.' * X + n * lambda * Id;


fprintf('matrix inversion ... \n');
tic;
B = inv(B);
toc;
fprintf('done !\n');
%save('B.mat','B');

%PP = B * X.' * Pn;
%load('B.mat');
P = B * X.';

%Q = 1/n * Pn * X;
%Q = 1/n * X;


end

