% A = [1,2;1,5;2,5;2,3;5,4;3,4;4,6;7,8];
% O = sparse(A(:,1), A(:,2), 1, 8, 8);
% O = full(O+O');
% 
% % C = bron_kerbosch([], 1:6, [], O, 0);
% 
% C = connex_components(O);
function bag = get_uniqueness_bag(tframes)

O = overlap(tframes, tframes);
O = (O+O')/2;
A = (O>0) - eye(size(O));

C = all_max_cliques(A);

bag = struct('set', C);

% U = triu(A);
% [row,col] = find(U);
% 
% for i = 1:length(row)
%     bag(i).set = [row(i), col(i)];
% end

end

% 
% MC = all_max_cliques(O);

% tframes = track_frames(facedets);
% 
% splits = unique(tframes(:));
% 
% trackid     = zeros(0, 1);
% interval    = zeros(0, 2);
% 
% for i = 1:size(tframes, 1)
%     idx = find(splits > tframes(i,1) & splits < tframes(i, 2));
%     fprintf('%d ', idx);
%     fprintf('\n');
%     
%     trackid = cat(1, trackid, i*ones(length(idx)+1, 1));
%     
%     f1 = [tframes(i, 1); splits(idx)+1];
%     f2 = [splits(idx)-1; tframes(i, 2)];
%     f = [f1,f2];
%     
%     interval = cat(1, interval, f);
% end
% 
% len = interval(:, 2) - interval(:, 1);
% idx = len>=10;
% 
% trackid = trackid(idx);
% interval = interval(idx, :);