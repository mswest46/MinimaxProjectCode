function pair = vazirani_matching2(adjacency_matrix, pair)


% initialize
phase_no = 0; % number of augmentation phases. just for debugging purposes.
dispstat('','init'); % for progress updating.
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
dummy = graph.dummy;
num_nodes = graph.num_nodes;
augmentation_occurred=true;

while augmentation_occurred;
    [augmentation_occurred,pair] = SEARCH2(graph,pair);
end