clear

addpath('~/Code/MinimaxProjectCode/VaziraniAlgorithm');

load('~/Data/bad_graphs/matrix11.mat');

%%

pair = find_max_matching(adjacency_matrix,true,'vazirani');

% aug_path_exists = check_for_aug_path(adjacency_matrix,pair);
% 
% is_matching = check_pair_is_matching(adjacency_matrix,pair);