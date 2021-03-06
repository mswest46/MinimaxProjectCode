
clear

distribution.type = 'custom';
params = [0,0,.9,0,0,0,0,0,0,0,.1];
distribution.params = size_bias(params);
num_nodes = 1000000;
adjacency_matrix = create_configuration_model(num_nodes,distribution);

%%
dummy = num_nodes+1;
pair = karp_sipser_matching(adjacency_matrix);
matching = true;
for j = 1: num_nodes
    if length(find(pair==j,2))>1 % double matched a vertex
        matching = false;
        break
    end
    if pair(j)~=dummy && adjacency_matrix(j,pair(j))==0 % paired with something that is not an edge
        matching = false;
        break
    end
    if pair(j) ~= dummy && pair(pair(j))~=j
        matching = false;
        break
    end
end
assert(matching);