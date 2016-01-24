function [G_prime,M_prime] = contract(G,M,B)
% removes all edges to non-base vxs in B and replaces with edges to base vx
% of B. 


adjacency_matrix = G.adjacency_matrix;
num_nodes = G.num_nodes;
b = B(end);
B_rem = B; B_rem(B_rem == b) = []; % B without the base, 

% a 1 x num_nodes vector with v true if v connects to any vx in B
new_edges = any(adjacency_matrix(B_rem,:)); 
adjacency_matrix(b,new_edges) = 1;
adjacency_matrix(new_edges,b) = 1;
adjacency_matrix(:,B_rem) = 0;
adjacency_matrix(B_rem,:) = 0;
adjacency_matrix(b,b) = 0;

% there may be a shortcut to this. 
G_prime = create_graph_struct_from_adjacency_matrix(adjacency_matrix);

pair = M.pair;
dummy = G.dummy;

pair(B_rem) = inf; 

exposed_vertices = find(pair==dummy);
matching_size = sum(pair<dummy)/2; % number of edges in matching;
M_edges = zeros(1,matching_size*2);
k = 0;
for i = 1: num_nodes
    if pair(i)<dummy
        k = k+1;
        M_edges(k) = G_prime.get_e_from_vs(i,pair(i));
    end
end
M_edges = unique(M_edges);
M_prime = struct('pair',pair,'edges',M_edges,...
    'exposed_vxs', exposed_vertices);

assert(length(fieldnames(M_prime))==3);


end