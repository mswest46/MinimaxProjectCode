% test_CLASSIFY


% ddfs_mods = CLASSIFY(classify_struct)
    
% graph = classify_struct.graph;
% bridge = classify_struct.bridge;
% predecessors = classify_struct.predecessors;
% level = classify_struct.level;
% erased = classify_struct.erased;
% bloom = classify_struct.bloom;


% ddfs_mods.bloss_or_aug = '';
% ddfs_mods.ownership = zeros(1,num_nodes);
% ddfs_mods.parent = nan(1,num_nodes);
% ddfs_mods.bottleneck = nan;
% ddfs_mods.final_left = nan;
% ddfs_mods.final_right = nan;
% ddfs_mods.init_left = nan;
% ddfs_mods.init_right = nan;


%% 

clear 
%  ~~
% |  |
% 1  1
% |  |

adjacency_matrix = zeros(8);
row_subs = [1,2,3,3,4,4,5,5,6,6,7,7,8,8];
col_subs = [3,4,1,5,2,6,3,7,4,8,5,8,6,7];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;


level = [0,0,1,1,2,2,3,3];
predecessors = {[],[],1,2,3,4,5,6};
erased = false(1,num_nodes);
bloom = nan(1,num_nodes);
bridge = graph.get_e_from_vs(7,8);
base = [];

% close all
% figure
% plot_matching(adjacency_matrix,level,'');
% 

classify_struct = v2struct(graph,level,predecessors,erased,bloom,bridge, base);
ddfs_mods = CLASSIFY(classify_struct);
v2struct(ddfs_mods);

assert(strcmp(bloss_or_aug, 'augment'))
test_own = zeros(1,num_nodes); test_own([1,3,5,7]) = 1; test_own([2,4,6,8]) = 2;
assert(isequal(ownership, test_own));
assert(isequaln(parent, [3,4,5,6,7,8,nan,nan]));
assert(isequaln(bottleneck, nan));
assert(isequal(final_left,1));
assert(isequal(final_right,2));
assert(isequal(init_left,7));
assert(isequal(init_right, 8));


%%
clear 

% blooms

%    __
%   1  1
%   |~ |~
%   |/ |/
%   1  1
%   |  |

adjacency_matrix = zeros(14);
row_subs = [1,2,3,3,4,4,5,5,5,6,6,6 ,7,7, 7,9,9 ,9 ,8,8,10,10,11,11,12,12,13,13,14,14];
col_subs = [3,4,1,5,2,6,3,7,8,4,9,10,5,8,11,6,10,12,5,7,6 ,9 ,7 ,13, 9,14,11,14,12,13];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;
dummy = graph.dummy;


level = [0,0,1,1,2,2,3,3,3,3,4,4,5,5];
predecessors = {[],[],1,2,3,4,5,5,6,6,7,9,11,12};
erased = false(1,num_nodes);
bloom = nan(1,num_nodes); bloom([7,8]) = 1;bloom([9,10]) = 2;
base = [5,6];

bridge = graph.get_e_from_vs(13,14);

classify_struct = v2struct(graph,level,predecessors,erased,bloom,bridge, base);
ddfs_mods = CLASSIFY(classify_struct);
v2struct(ddfs_mods);


%TODO assertinos



