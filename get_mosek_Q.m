function [ qosubi, qosubj, qoval ] = get_mosek_Q(Y, nXi, kapa )

[n, P] = size(Y);

Znx = sparse(n*P, nXi);
Znn = sparse(n*P, n*P);

IXi = kapa / 2 * sparse(1:nXi, 1:nXi, 1);

IY = 1 / 2 * sparse(1:(n*P), 1:(n*P), 1);
Q = [Znn, Znx, Znn; Znx', IXi, Znx'; Znn, Znx,IY];


[qosubi, qosubj, qoval] = find(Q);

end

