% these are large, overnight tests
clear

distribution.type = 'custom';
num_nodes = 100000;
dummy = num_nodes +1;

for i = 1
  
    params = rand(1,10);
    params = params/sum(params);
    distribution.params = size_bias(params);
    
    try
        adjacency_matrix = create_configuration_model(num_nodes,distribution);
        pair = vaziraniMatching(adjacency_matrix);
        bool = check_pair_is_matching(adjacency_matrix,pair);
        assert(bool);
        bool = check_for_aug_path(adjacency_matrix,pair);
        assert(~bool);
    catch
        save('~/Desktop/bad.mat','adjacency_matrix');
        error('yo')
    end
    
    disp([num2str(i), ' of 200 matchings tested']);
end


