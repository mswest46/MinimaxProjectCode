% test_SEARCH

%% initial call with no pairing

clear 

adjacency_matrix = zeros(12);
row_subs = [1,2,2,3,3,3,4,4,5,5,5 ,6,6,7,7,8,9,9 ,10,10,11,11,12,12];
col_subs = [2,1,3,2,4,5,3,6,3,7,12,4,7,6,5,9,8,10,9 ,11,10,12,11,5 ];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;
dummy = graph.dummy;

search_mods.search_level = -1;
search_mods.even_level = inf(1,num_nodes);
search_mods.odd_level = inf(1,num_nodes);
search_mods.predecessors = cell(1,num_nodes);
search_mods.successors = cell(1,num_nodes);
search_mods.pred_count = zeros(1,num_nodes);
search_mods.bridges = cell(1,num_nodes);
search_mods.anomalies = cell(1,num_nodes);
search_mods.candidates = cell(1,num_nodes);
search_mods.initial_flag = true;
search_mods.index_fun = @ (search_level) search_level + 1;

bloom = nan(1,num_nodes);
pair = dummy * ones(1,num_nodes);
erased = false(1,num_nodes);

search_struct = v2struct(graph,pair,search_mods,bloom, erased);

search_mods = SEARCH(search_struct);

%% initial call with pairing

clear 

adjacency_matrix = zeros(12);
row_subs = [1,2,2,3,3,3,4,4,5,5,5 ,6,6,7,7,8,9,9 ,10,10,11,11,12,12];
col_subs = [2,1,3,2,4,5,3,6,3,7,12,4,7,6,5,9,8,10,9 ,11,10,12,11,5 ];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;
dummy = graph.dummy;

height = inf(1,num_nodes); height([1,8]) = 0; ...
    height([3,10]) = 2; height([6,7,12]) = 4;  height([2,9]) = 1;...
    height([4,5,11]) = 3;


close all;
figure;
plot_matching(adjacency_matrix,height,'');

search_mods.search_level = -1;
search_mods.even_level = inf(1,num_nodes);
search_mods.odd_level = inf(1,num_nodes);
search_mods.predecessors = cell(1,num_nodes);
search_mods.successors = cell(1,num_nodes);
search_mods.pred_count = zeros(1,num_nodes);
search_mods.bridges = cell(1,num_nodes);
search_mods.anomalies = cell(1,num_nodes);
search_mods.candidates = cell(1,num_nodes);
search_mods.initial_flag = true;
search_mods.index_fun = @ (search_level) search_level + 1;

bloom = nan(1,num_nodes);
pair = [dummy, 3,2,6,7,4,5,dummy,10,9,12,11];
erased = false(1,num_nodes);

search_struct = v2struct(graph,pair,search_mods,bloom, erased);

search_mods = SEARCH(search_struct);



assert(search_mods.search_level == 4, 'a');
assert(search_mods.bridges{5} == graph.get_e_from_vs(6,7), 'b');

assert(search_mods.candidates{search_mods.index_fun(5)}==5}