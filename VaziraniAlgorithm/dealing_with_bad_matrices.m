clear

k = 1;
filename = strcat('~/Code/MinimaxProjectCode/matrix',num2str(k),'.mat');
load(filename);
filename = strcat('~/Code/MinimaxProjectCode/aug_path',num2str(k),'.mat');
load(filename);
filename = strcat('~/Code/MinimaxProjectCode/pair',num2str(k),'.mat');
load(filename);
num_nodes = size(adjacency_matrix,1);
dummy = num_nodes +1;

%% 
% pair = find_max_matching(adjacency_matrix,true,'vazirani');
% matching_size = sum(pair<dummy);
% disp(['matching_size ', num2str(matching_size)]);
% check_pair_is_matching(adjacency_matrix,pair)
% [aug_path_exists,aug_path] = check_for_aug_path(adjacency_matrix,pair);
% disp(aug_path_exists);
% disp(length(aug_path));
%  save('~/Code/MinimaxProjectCode/aug_path1.mat', 'aug_path');
% save('~/Code/MinimaxProjectCode/pair1.mat', 'pair');

%%

new_pair = find_max_matching(adjacency_matrix,true,'vazirani');
old_m = sum(pair<dummy);
new_m = sum(new_pair<dummy);


%%
[aug_path_exists,aug_path] = check_for_aug_path(adjacency_matrix,new_pair);
my_beep;

