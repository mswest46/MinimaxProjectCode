% find vxs in all max matchings for TREE degree distribution p1 = .9, pk = .1
% for k = 3:10. requires size biasing.


num_nodes = 10^6;
n_pk = 8;
n_trials = 10;

data1 = cell(n_pk,n_trials);



for j = 1:n_pk
    k = j+3;
    for i = 1:n_trials
        params = zeros(1,11);params([2,k]) = [.9,.1];
        biased_params = size_bias(params);
        dist = struct('type','custom','params',biased_params);
        [adjacency_matrix,info] = create_configuration_model(num_nodes,dist);
        pair = find_max_matching(adjacency_matrix,true,'vazirani');
        vertices = find_vxs_in_all_maximal_matchings(adjacency_matrix,pair);
        num_nodes = length(adjacency_matrix(1,:));
        percent_v_in_all = sum(vertices)/num_nodes;
        D = struct('params',biased_params,'adjacency_matrix',adjacency_matrix,...
            'pair',pair,'vxs_in_all_matchings',vertices,'num_v_in_all', percent_v_in_all,...
            'multi_edges',info.multi_edges);
        data1{j,i} = D;
    end
end

save('~/Data/minimax_project_data/simulation4/data1.mat','data1','-v7.3');
my_beep;
error('yo')
%%

% find vxs in all max matchings for TREE degree distribution p2 = .9, pk = .1
% for k = 3:10. requires size biasing.


num_nodes = 10^6;
n_pk = 8;
n_trials = 10;

data2 = cell(n_pk,n_trials);



for j = 1:n_pk
    k = j+3;
    for i = 1:n_trials
        params = zeros(1,11);params([3,k]) = [.9,.1];params = size_bias(params);
        dist = struct('type','custom','params',params);
        [adjacency_matrix,info] = create_configuration_model(num_nodes,dist);
        pair = find_max_matching(adjacency_matrix,true,'vazirani');
        vertices = find_vxs_in_all_maximal_matchings(adjacency_matrix,pair);
        num_nodes = length(adjacency_matrix(1,:));
        percent_v_in_all = sum(vertices)/num_nodes;
        D = struct('distribution',dist,'adjacency_matrix',adjacency_matrix,...
            'pair',pair,'vxs_in_all_matchings',vertices,'percent_v_in_all', percent_v_in_all,...
            'multi_edges',info.multi_edges);
        data2{j,i} = D;
    end
end

save('~/Data/minimax_project_data/simulation4/data2.mat','data');