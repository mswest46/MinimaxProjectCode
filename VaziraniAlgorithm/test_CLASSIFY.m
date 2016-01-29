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
ownership = zeros(1,num_nodes);
bloom = nan(1,num_nodes);
bridge = graph.get_e_from_vs(7,8);
base = [];

% close all
% figure
% plot_matching(adjacency_matrix,level,'');
% 

classify_struct = v2struct(graph,level,predecessors,erased,bloom,bridge, base, ownership);
ddfs_mods = CLASSIFY(classify_struct);
v2struct(ddfs_mods);

assert(strcmp(bloss_or_aug, 'augment'))
test_own = zeros(1,num_nodes); test_own([1,3,5,7]) = 1; test_own([2,4,6,8]) = 2;
assert(isequal(ownership, test_own));
assert(isequal(left_parent, [3,0,5,0,7,0,0,0]));
assert(isequal(right_parent, [0,4,0,6,0,8,0,0]));
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
ownership = zeros(1,num_nodes);ownership([7,9]) = 1; ownership([8,10]) = 2;
bloom = nan(1,num_nodes); bloom([7,8]) = 1;bloom([9,10]) = 2;
base = [5,6];

bridge = graph.get_e_from_vs(13,14);

classify_struct = v2struct(graph,level,predecessors,erased,bloom,bridge, base, ownership);
ddfs_mods = CLASSIFY(classify_struct);
v2struct(ddfs_mods);

assert(strcmp(bloss_or_aug, 'augment'))
test_own = zeros(1,num_nodes); test_own([13,11,5,3,1]) = 1; ...
    test_own([14,12,6,4,2]) = 2; test_own([7,9]) = 1; test_own([8,10]) = 2;
assert(isequal(ownership, test_own));
assert(isequaln(bottleneck, nan));
assert(isequal(final_left,1));
assert(isequal(final_right,2));
assert(isequal(init_left,13));
assert(isequal(init_right, 14));





%%

% a graph in which two disjoint blossoms have the same point. 
clear 


adjacency_matrix = zeros(10);
row_subs = [1,2,2,2,2,2,3,3,4,4,5,5,6,6 ,7,7,8,8,8,9,9,9 ,10,10];
col_subs = [2,1,3,4,5,6,2,7,2,8,2,9,2,10,3,8,4,7,9,5,8,10, 6, 9];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs,col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;
num_edges = graph.num_edges;
level = [0,1,2,2,2,2,3,3,3,3];
predecessors = {[],1,2,2,2,2,3,4,5,6};
erased = false(1,num_nodes);
bloom = nan(1,num_nodes);bloom([3,4,7,8]) = 1;bloom([5,6,9,10]) = 2;
base = [2,2];
bridge = graph.get_e_from_vs(8,9);
ownership = zeros(1,num_nodes);ownership([3,7,5,9]) = 1; ownership([4,8,6,10]) = 2;
test_own = ownership;

classify_struct = v2struct(graph,level,predecessors,erased,bloom,bridge, base, ownership);
ddfs_mods = CLASSIFY(classify_struct);
v2struct(ddfs_mods);

assert(isempty(bloss_or_aug))
%%

% a graph in which we augment an existing blossom.


adjacency_matrix = zeros(7);
row_subs = [1,1,2,2,3,3,4,4,4,5,5,5,6,6,7,7];
col_subs = [2,3,1,4,1,5,2,5,6,3,4,7,4,7,5,6];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs,col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;
num_edges = graph.num_edges;
level = [0,1,1,2,2,3,3];
predecessors = {[],1,1,2,3,4,5};
erased = false(1,num_nodes);
bloom = nan(1,num_nodes);bloom([2,3,4,5]) = 1;
base = 1;
bridge = graph.get_e_from_vs(6,7);
ownership = zeros(1,num_nodes);ownership([2,4]) = 1; ownership([3,5]) = 2;
test_own = ownership;

classify_struct = v2struct(graph,level,predecessors,erased,bloom,bridge, base, ownership);
ddfs_mods = CLASSIFY(classify_struct);
v2struct(ddfs_mods);

assert(strcmp(bloss_or_aug, 'blossom'))
test_own(6) = 1;test_own(7) = 2;
assert(isequal(ownership, test_own));
test_lp = zeros(1,num_nodes); test_lp(1) = 6;
test_rp = zeros(1,num_nodes); test_rp(1) = 7;
assert(isequaln(left_parent, test_lp));
assert(isequaln(right_parent, test_rp));
assert(isequaln(bottleneck, 1));
assert(isequal(init_left,6));
assert(isequal(init_right, 7));

%%

% a graph in which we start searching from within an existing bloom and
% find an aug_path

%  _____
%  | | |
%  \/  |

adjacency_matrix = zeros(8);
row_subs = [1,1,2,2,3,3,4,4,5,5,5,6,6,7,7,8];
col_subs = [2,3,1,4,1,5,2,5,3,4,6,5,7,6,8,7];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs,col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;
num_edges = graph.num_edges;
level = [0,1,1,2,2,2,1,0];
predecessors = {[],1,1,2,3,7,8,[]};
erased = false(1,num_nodes);
bloom = nan(1,num_nodes);bloom([2,3,4,5]) = 1;
base = 1;
bridge = graph.get_e_from_vs(5,6);
ownership = zeros(1,num_nodes);ownership([2,4]) = 1; ownership([3,5]) = 2;
test_own = ownership;

classify_struct = v2struct(graph,level,predecessors,erased,bloom,bridge, base, ownership);
ddfs_mods = CLASSIFY(classify_struct);
v2struct(ddfs_mods);






%% 

% a graph in which the DCV is the base of a preexisting blossom.


