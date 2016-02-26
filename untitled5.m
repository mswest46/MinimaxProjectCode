num_nodes = 10^6+1;

params = zeros(1,13);params([2,3,6]) = [.001,.6,.4];
dist = struct('type', 'custom','params',params);
adjacency_matrix = create_configuration_model(num_nodes,dist);

pair = find_max_matching(adjacency_matrix,true,'vazirani');
vxs = find_vxs_in_all_maximal_matchings(adjacency_matrix,pair);