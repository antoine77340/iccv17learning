function [ lx,ux] = get_mosek_lx( n, P, nXi,IC )

lx1 = - inf(n*P, 1);
lx2 = zeros(n*P, 1);
lx3 = zeros(nXi, 1);
ux = inf(2*n*P+nXi,1);
IC = find(cat(1,IC,zeros(n*P+nXi,1)));
ux(IC) = 0;
lx = cat(1, lx2, lx3, lx1);
%ux = 0
end
