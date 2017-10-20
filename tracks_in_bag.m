function [ A ] = tracks_in_bag( bags, f )

A = zeros(length(bags), size(f, 1));

for i = 1:length(bags)
    f1 = bags(i).f(1);
    f2 = bags(i).f(2);
    idx = f(:,2) > f1 & f(:,1) < f2;
    A(i, idx) = 1;
end

end

