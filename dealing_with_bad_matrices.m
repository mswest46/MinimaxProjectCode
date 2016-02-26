k = 1;
filename = strcat('~/Code/MinimaxProjectCode/testing_matrices/matrix',num2str(k),'.mat');
load(filename);
num_nodes = size(adjacency_matrix,1);
dummy = num_nodes +1;

%% 
pair = find_max_matching(adjacency_matrix,true,'vazirani');
matching_size = sum(pair<dummy);
disp(['matching_size ', num2str(matching_size)]);
check_pair_is_matching(adjacency_matrix,pair)
[aug_path_exists,aug_path] = check_for_aug_path(adjacency_matrix,pair);
disp(aug_path_exists);
disp(length(aug_path));