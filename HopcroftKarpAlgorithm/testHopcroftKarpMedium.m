distribution.type = 'custom';
params = [0,.6,0,.4];
distribution.params = size_bias(params);
num_nodes = 1000000;
for i = 1:4
        adjacency_matrix = create_bipartite_configuration_model(num_nodes,distribution);
        pair = find_max_matching(adjacency_matrix,true,'hopcroft-karp');
        bool = check_pair_is_matching(adjacency_matrix,pair);
        assert(bool);
        bool = check_for_aug_path(adjacency_matrix,pair);
        assert(~bool);
    disp([num2str(i), ' of 4 matchings tested']);
end