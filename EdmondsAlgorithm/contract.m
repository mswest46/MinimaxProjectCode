function [G_prime,M_prime] = contract(G,M,B)
% every edge attached to a vx in B should be redirected to min(B)


adjacency_matrix = G.adjacency_matrix;
b = root(B);
B_rem = B; B_rem(B_rem == b) = [];
% a 1 x num_nodes vector with v true if v connects to any vx in B
new_edges = any(adjacency_matrix(B_rem,:)); 
adjacency_matrix(b,new_edges) = 1;
adjacency_matrix(new_edges,b) = 1;
adjacency_matrix(:,B_rem) = 0;
adjacency_matrix(B_rem,:) = 0;
G_prime = create_graph_struct_from_adjacency_matrix(adjacency_matrix);

pair = M.pair;

pair(B_rem) = dummy; 
M_prime = pair;


end