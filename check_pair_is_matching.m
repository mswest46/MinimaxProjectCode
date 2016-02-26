function matching = check_pair_is_matching(adjacency_matrix,pair)

matching = true;
num_nodes = length(adjacency_matrix(1,:));
dummy = num_nodes+1;
for j = 1: num_nodes
    if length(find(pair==j,2))>1 % double matched a vertex
        matching = false;
        disp('double match');
        break
    end
    if pair(j)~=dummy && adjacency_matrix(j,pair(j))==0 % paired with something that is not an edge
        matching = false;
        disp('pair is not edge')
        break
    end
    if pair(j) ~= dummy && pair(pair(j))~=j
        matching = false;
        disp('not symmetric');
        break
    end
    
end
assert(matching);