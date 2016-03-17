% test_find_vxs_in_all_maximal_matchings


%% ._._._._._.
clear

num_nodes = 6;
adjacency_matrix = zeros(num_nodes);
row_subs = [1,2,2,3,3,4,4,5,5,6];
col_subs = [2,1,3,2,4,3,5,4,6,5];
adjacency_matrix(sub2ind(size(adjacency_matrix),row_subs,col_subs)) = 1;
pair = find_max_matching(adjacency_matrix,true,'vazirani');
[vxs_in_all,persistence] = find_vxs_in_all_maximal_matchings(adjacency_matrix,pair);
assert(isequal(find(vxs_in_all), [1,2,3,4,5,6]));


%% ._._._._.
clear

num_nodes = 5;
adjacency_matrix = zeros(num_nodes);
row_subs = [1,2,2,3,3,4,4,5];
col_subs = [2,1,3,2,4,3,5,4];
adjacency_matrix(sub2ind(size(adjacency_matrix),row_subs,col_subs)) = 1;
pair = find_max_matching(adjacency_matrix,true,'vazirani');
[vxs_in_all,persistence] = find_vxs_in_all_maximal_matchings(adjacency_matrix,pair);
assert(isequal(find(vxs_in_all), [2,4]));

%% ._._.
%     /|


num_nodes = 5;
adjacency_matrix = zeros(num_nodes);
row_subs = [1,2,2,3,3,3,4,5];
col_subs = [2,1,3,2,4,5,3,3];
adjacency_matrix(sub2ind(size(adjacency_matrix),row_subs,col_subs)) = 1;
pair = find_max_matching(adjacency_matrix,true,'vazirani');
[vxs_in_all,persistence] = find_vxs_in_all_maximal_matchings(adjacency_matrix,pair);
assert(isequal(find(vxs_in_all), [1,2,3]));
