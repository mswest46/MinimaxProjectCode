% test_FINDPATH
% syntax: function path = function path = FINDPATH(high, low, B, erased, graph, level, ownership, bloom_mods)

%% test subfunction
clear 

num_nodes = 6;
erased = false(1,num_nodes); 

predecessors = {[],1,2,3,[4,6],[]};


get_unvisited_unerased_predecessors = FINDPATH('-getSubHandles');

visited = false(1,num_nodes);

u = get_unvisited_unerased_predecessors(2, predecessors, visited, erased);
assert(isequal(u,1),'a');
u = get_unvisited_unerased_predecessors(1, predecessors, visited, erased);
assert(isempty(u),'b');
u = get_unvisited_unerased_predecessors(5, predecessors, visited, erased);
assert(isequal(u,[4,6]),'c');

visited(6) = true;

u = get_unvisited_unerased_predecessors(5, predecessors, visited, erased);
assert(isequal(u,4),'d');

%% test with simple path, single backtrack
clear 

adjacency_matrix = zeros(6);
row_subs = [1,2,2,3,3,4,4,5,5,6];
col_subs = [2,1,3,2,4,3,5,4,6,5];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;

high = 5;
low = 1;
B = nan;
erased = false(1,num_nodes); 
level = [0,1,2,3,4,3];
ownership = ones(1,num_nodes);
bloom = nan(1,num_nodes);
bloom_ownership = nan(1,num_nodes);
left_peak = [];
right_peak = [];
base = [];
predecessors = {[],1,2,3,[4,6],[]};


find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,bloom_ownership,base, left_peak, right_peak);

path = FINDPATH(high,low,B,find_path_struct);
assert(isequal(path, [5,4,3,2,1]));

%% test with single call to open. 

% our bloom is 2,3, with base 1. bloom_number is 1. 
  
% __|
% \/

clear 

adjacency_matrix = zeros(4);
row_subs = [1,1,2,2,3,3,3,4];
col_subs = [2,3,1,3,1,2,4,3];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;

high = 4;
low = 1;
B = nan;
erased = false(1,num_nodes); 
level = [0,1,1,2];
ownership = ones(1,num_nodes);
bloom = [nan,1,1,nan];
bloom_ownership = [nan,1,2,nan];
left_peak = 2;
right_peak = 3;
base = 1;
predecessors = {[],1,1,3};

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,bloom_ownership,base,left_peak,right_peak);

path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path, [4,3,2,1]));
%%
  
% __|
% | |
%  \/
%  |
%  |
clear 

adjacency_matrix = zeros(8);
row_subs = [1,2,2,3,3,3,4,4,5,5,6,6,7,7,7,8];
col_subs = [2,1,3,2,4,5,3,6,3,7,4,7,5,6,8,7];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;

high = 8;
low = 1;
B = nan;
erased = false(1,num_nodes); 
level = [0,1,2,3,3,4,4,5];
ownership = ones(1,num_nodes);
bloom = [nan,nan,nan,1,1,1,1,nan];
bloom_ownership = [nan,nan,nan,1,2,1,2,nan];
left_peak = 6;
right_peak = 7;
base = 3;
predecessors = {[],1,2,3,3,4,5,7};

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,bloom_ownership,base,left_peak,right_peak);

path = FINDPATH(high,low,B,find_path_struct);
assert(isequal(path,[8,7,5,3,2,1]));

%%

  
%   __
% \| |
%   \/
%   |
%   |

adjacency_matrix = zeros(8);
row_subs = [1,2,2,3,3,3,4,4,4,5,5,6,6,7,7,8];
col_subs = [2,1,3,2,4,5,3,6,8,3,7,4,7,5,6,4];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;

high = 8;
low = 1;
B = nan;
erased = false(1,num_nodes); 
level = [0,1,2,3,3,4,4,4];
ownership = ones(1,num_nodes);
bloom = [nan,nan,nan,1,1,1,1,nan];
bloom_ownership = [nan,nan,nan,1,2,1,2,nan];
left_peak = 6;
right_peak = 7;
base = 3;
predecessors = {[],1,2,3,3,4,5,4};

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,bloom_ownership,base,left_peak,right_peak);

path = FINDPATH(high,low,B,find_path_struct);
assert(isequal(path,[8,4,6,7,5,3,2,1]));