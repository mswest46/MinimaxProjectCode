clear
clc

k = 1;
filename = strcat('~/Code/MinimaxProjectCode/testing_matrices/matrix',num2str(k),'.mat');
load(filename);
num_nodes = size(adjacency_matrix,1);
dummy = num_nodes +1;

og_pair = find_max_matching(og_adjacency_matrix,true,'vazirani');
pair = find_max_matching(adjacency_matrix,true,'vazirani');

og_matching_size = sum(og_pair<dummy);
matching_size = sum(pair<dummy);

disp(['og_matching_size ',num2str(og_matching_size)]);
disp(['matching_size ', num2str(matching_size)]);

% matching has one more edge than og_matching;

%%
check_pair_is_matching(adjacency_matrix,pair)

% pair is a matching. 

%%
check_pair_is_matching(og_adjacency_matrix,og_pair);

% og_pair is also a matching. 

%%
[aug_path_exists,aug_path] = check_for_aug_path(adjacency_matrix,pair);
disp(aug_path_exists);
disp(length(aug_path));
% aug_path exists of size 34. 

%%

% why are we not finding the aug_path? 

pair = vazirani_matching(adjacency_matrix,pair);




%%

[aug_path_exists,aug_path] = check_for_aug_path(og_adjacency_matrix,og_pair);

disp(aug_path_exists);
disp(length(aug_path));

% aug_path exists of length 108
%%
[aug_path_exists, aug_path] = check_for_aug_path(adjacency_matrix,pair);
[og_aug_path_exists, og_aug_path] = check_for_aug_path(og_adjacency_matrix,og_pair);

if aug_path_exists
    disp('aug path exists in permuted matrix');
    a = vazirani_matching(adjacency_matrix,pair);
end
if og_aug_path_exists
    disp('aug path exists in og matrix');
    a = vazirani_matching(og_adjacency_matrix,og_pair);
end

pause;

if aug_path_exists
    a = vazirani_matching(adjacency_matrix,pair);
end
if og_aug_path_exists
    a = vazirani_matching(og_adjacency_matrix,og_pair);
end

% run an initial search on matrix in question. we should get a bunch of
% bridges that lead to potential blossooms, but that don't leed to any
% aug_paths. 

% run a second search