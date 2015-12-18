% test_AUGERASE

% function [erased, pair, pred_count] = ...
%     AUGERASE(aug_erase_struct)

% assert(length(fieldnames(aug_erase_struct))==17);
% graph = aug_erase_struct.graph;
% pair = aug_erase_struct.pair;
% erased = aug_erase_struct.erased;
% pred_count = aug_erase_struct.pred_count;
% successors = aug_erase_struct.successors;
% init_left = aug_erase_struct.init_left;
% init_right = aug_erase_struct.init_right;
% final_left = aug_erase_struct.final_left;
% final_right = aug_erase_struct.final_right;
% level = aug_erase_struct.level;
% ownership = aug_erase_struct.ownership;
% bloom = aug_erase_struct.bloom;
% base = aug_erase_struct.base;
% left_peak = aug_erase_stuct.left_peak;
% right_peak = aug_erase_struct.right_peak;
% bloom_ownership = aug_erase_struct.bloom_ownership;
% predecessors = aug_erase_struct.predecessors;

%% no blooms

clear

%  ~~
% |  |
% 1  1
% |  |
% 
% 
% 


adjacency_matrix = zeros(8);
row_subs = [1,2,3,3,4,4,5,5,6,6,7,7,8,8];
col_subs = [3,4,1,5,2,6,3,7,4,8,5,8,6,7];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;
dummy = graph.dummy;

pair = [dummy, dummy, 5,6,3,4,8,7];
erased = false(1,8);
pred_count = [0,0,1,1,1,1,1,1];
successors = {3,4,5,6,7,8,[],[]};
init_left = 7;
init_right = 8;
final_left = 1;
final_right = 2;
level = [0,0,1,1,2,2,3,3];
ownership = [1,2,1,2,1,2,1,2];
bloom = nan(1,num_nodes);
base = [];
left_peak = [];
right_peak = [];
bloom_ownership = nan(1,num_nodes);
predecessors = {[],[],1,2,3,4,5,6};

aug_erase_struct = v2struct(graph,pair,erased,pred_count,successors,...
    init_left,init_right,final_left,final_right,level,ownership,bloom,...
    base,left_peak,right_peak,bloom_ownership,predecessors);
[erased, pair, pred_count] = AUGERASE(aug_erase_struct);

assert(all(erased));
assert(isequal(pair,[3,4,1,2,7,8,5,6]));

%%

% test_AUGERASE

% function [erased, pair, pred_count] = ...
%     AUGERASE(aug_erase_struct)

% assert(length(fieldnames(aug_erase_struct))==17);
% graph = aug_erase_struct.graph;
% pair = aug_erase_struct.pair;
% erased = aug_erase_struct.erased;
% pred_count = aug_erase_struct.pred_count;
% successors = aug_erase_struct.successors;
% init_left = aug_erase_struct.init_left;
% init_right = aug_erase_struct.init_right;
% final_left = aug_erase_struct.final_left;
% final_right = aug_erase_struct.final_right;
% level = aug_erase_struct.level;
% ownership = aug_erase_struct.ownership;
% bloom = aug_erase_struct.bloom;
% base = aug_erase_struct.base;
% left_peak = aug_erase_stuct.left_peak;
% right_peak = aug_erase_struct.right_peak;
% bloom_ownership = aug_erase_struct.bloom_ownership;
% predecessors = aug_erase_struct.predecessors;

%% blooms

clear

%    __
%   1  1
%   |~ |~
%   |/ |/
%   1  1
%   |  |
% 


adjacency_matrix = zeros(14);
row_subs = [1,2,3,3,4,4,5,5,5,6,6,6 ,7,7, 7,9,9 ,9 ,8,8,10,10,11,11,12,12,13,13,14,14];
col_subs = [3,4,1,5,2,6,3,7,8,4,9,10,5,8,11,6,10,12,5,7,6 ,9 ,7 ,13, 9,14,11,14,12,13];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;
dummy = graph.dummy;

pair = [dummy, dummy, 5,6,3,4,8,7,10,9,13,14,11,12];
erased = false(1,num_nodes);
pred_count = [0,0,1,1,1,1,1,1,1,1,1,1,1,1];
successors = {3,4,5,6,[7,8],[9,10],11,[],12,[],13,14,[],[]};
init_left = 13;
init_right = 14;
final_left = 1;
final_right = 2;
level = [0,0,1,1,2,2,3,3,3,3,4,4,5,5];
ownership = [1,2,1,2,1,2,1,1,2,2,1,2,1,2];
bloom = nan(1,num_nodes); bloom([7,8]) = 1; bloom([9,10]) = 2;
base = [5,6];
left_peak = [7,9];
right_peak = [8,10];
bloom_ownership = nan(1,num_nodes); bloom_ownership([7,9]) = 1; ...
    bloom_ownership([8,10]) = 2;
predecessors = {[],[],1,2,3,4,5,5,6,6,7,9,11,12};

% close all
% figure;
% plot_matching(adjacency_matrix,level,pair);
% pause;

aug_erase_struct = v2struct(graph,pair,erased,pred_count,successors,...
    init_left,init_right,final_left,final_right,level,ownership,bloom,...
    base,left_peak,right_peak,bloom_ownership,predecessors);
[erased, pair, pred_count] = AUGERASE(aug_erase_struct);

assert(all(erased));
assert(isequal(pair,[3,4,1,2,8,10,11,5,12,6,7,9,14,13]));

% 
% 
%  figure;
% plot_matching(adjacency_matrix,level,pair);