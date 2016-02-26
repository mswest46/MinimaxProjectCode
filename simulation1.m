
%% r-regular graphs with even/odd number of nodes


addpath('~/Code/BrainConnectivityToolbox');
% r = 2;

clear
n_trials = 1;
num_nodes = 10^7;
pair = cell(1,n_trials);
vertices = cell(1,n_trials);
num_multi_edges = zeros(1,n_trials);
components = cell(1,n_trials);

for i = 1:n_trials
    params = [0,0,.0001,1];
    dist = struct('type','custom','params',params);
    [adjacency_matrix,info] = create_configuration_model(num_nodes,dist);    
    pair{i} = find_max_matching(adjacency_matrix,true,'vazirani');
    vertices{i} = find_vxs_in_all_maximal_matchings(adjacency_matrix,pair{i});
    [components{i},comp_sizes{i}] = get_components(adjacency_matrix);
    num_multi_edges(i) = length(info.multi_edges);
    
end
my_beep

error('yo');
%%

dummy = num_nodes+1;
for i = 1:n_trials
    free = find(pair{i} == dummy);
    disp('free:');
    disp(free);
    disp('comp_sizes');
    disp(comp_sizes{i});
    disp('size of free_comps:');
    disp(comp_sizes{i}(components{i}(free)));
    disp([num2str(max(components{i})),'comps']);
    size_of_free_comps = sum(comp_sizes{i}(components{i}(free)));
    disp(size_of_free_comps);
    1;
end
    
    
%%
% r = 3;
num_nodes = 10^6;
num_vxs = cell(1,20);
num_multi_edges = cell(1,20);

for i = 1:20
    params = [0,0,1];
    dist = struct('type','custom','params',params);
    [adjacency_matrix,info] = create_configuration_model(num_nodes,dist);    
    pair = find_max_matching(adjacency_matrix,true,'vazirani');
    vxs = find_vxs_in_all_maximal_matchings(adjacency_matrix,pair);
    num_vxs(i) = length(vxs);
    num_multi_edges(i) = length(info.mult_edges);
end
my_beep


% maximal matching of size