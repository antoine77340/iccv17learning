function result = get_blocks(track_blocks, n, P)

result = [];
%{
for i=1:n_blocks
    current_block = track_blocks(i);

   % for j=current_block
    result = cat(1,result,(current_block+n*(0:P-1))');
   % end
end
%}

for i=0:P-1
    result = cat(2,result,track_blocks+n*i);
end

end
