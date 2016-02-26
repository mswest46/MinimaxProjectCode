function pair = vazirani_matching(adjacency_matrix, pair)


% initialize
phase_no = 0; % number of augmentation phases. just for debugging purposes.
dispstat('','init'); % for progress updating.
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
dummy = graph.dummy;
num_nodes = graph.num_nodes;
augmentation_occurred=true;
if nargin<2 || isempty(pair)
    pair = dummy*ones(1,num_nodes);
end
vertices = prep_vertices_for_vaz(num_nodes, pair);

while augmentation_occurred;
    phase_no = phase_no + 1;
    [augmentation_occurred,vertices] = SEARCH(graph,vertices);
    pair = [vertices.pair];
    matching_size = sum(pair<dummy);
    if matching_size == num_nodes || matching_size == num_nodes-1
        break
    end
end

matching_size = sum(pair<dummy);
dispstat([num2str(100*matching_size/num_nodes),...
    '% of nodes matched']);
