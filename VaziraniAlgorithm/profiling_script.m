%% for profiling purposes

% clear
% 
% distribution.type = 'custom';
% params = [0,.3,.6,0,0,0,0,0,0,0,.1];
% distribution.params = size_bias(params);
% num_nodes = 10^6;
% 
% adjacency_matrix = create_configuration_model(num_nodes,distribution);
% pair = find_max_matching(adjacency_matrix);

%% investigating the get edges from vertices function

clear

distribution.type = 'custom';
params = [0,0,.9,0,0,0,0,0,0,0,.1];
distribution.params = size_bias(params);

times = zeros(1,6);
lp_time = cell(1,6);
for k = 1:6
    tic;
    num_nodes = 10^k;
    adjacency_matrix = create_configuration_model(num_nodes, distribution);
    pair = find_max_matching(adjacency_matrix);
    times(k) = toc;
end

