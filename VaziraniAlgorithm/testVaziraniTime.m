clear

time = zeros(1,5);
for i = 1:5
    distribution.type = 'custom';
    num_nodes = 500000;
    p = .8;
    params = [0,p,0,1-p];
    distribution.params = size_bias(params);
    tic;
    adjacency_matrix = create_configuration_model(num_nodes,distribution);
    pair = find_max_matching(adjacency_matrix,true','vazirani');
    time(i) = toc
end

save('~/Data/Dissertation/int2QueueTime.mat','time');