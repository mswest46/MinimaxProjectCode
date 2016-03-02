distribution.type = 'custom';
params = [0,0,.5,0,0,0,.2,0,0,0,.2,.1];
distribution.params = size_bias(params);
num_nodes = 100;
for i = 1:4
        adjacency_matrix = create_bipartite_configuration_model(num_nodes,distribution);
        pair = hopcroft_karp(adjacency_matrix);
        bool = check_pair_is_matching(adjacency_matrix,pair);
        assert(bool);
        bool = check_for_aug_path(adjacency_matrix,pair);
        assert(~bool);
    disp([num2str(i), ' of 4 matchings tested']);
end