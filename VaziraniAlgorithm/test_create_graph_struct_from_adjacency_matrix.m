% test_create_graph_struct_from_adjacency_matrix

row_subs = [1,1,2,3,5,6,6,8,8,8];
col_subs = [1,2,1,8,6,8,5,3,6,8];

num_nodes =  10;
adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix),row_subs,col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
assert(length(fieldnames(graph)) == 8);
assert(graph.num_nodes == 10);
assert(graph.num_edges == 4);
assert(isequal(graph.edge_indices, [11;55;73;76]));
assert(isequal(graph.neighbors{8},[3;6]));

[i,j] = graph.get_vs_from_e(3);
assert( isequal([i,j], [3,8]));

e = graph.get_e_from_vs(3,8);
assert(isequal(e,3));
e = graph.get_e_from_vs(8,3);
assert(isequal(e,3));