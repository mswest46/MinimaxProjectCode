% test_FINDPATH
% syntax: function path = function path = FINDPATH(high, low, B, erased, graph, level, ownership, bloom_mods)

%% test subfunction
% clear 
% 
% adjacency_matrix = zeros(6);
% row_subs = [1,2,2,3,3,4,4,5,5,6];
% col_subs = [2,1,3,2,4,3,5,4,6,5];
% adjacency_matrix(sub2ind(size(adjacency_matrix),row_subs,col_subs)) = 1;
% graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
% num_nodes = graph.num_nodes;
% erased = false(1,num_nodes); 
% 
% predecessors = {[],1,2,3,[4,6],[]};
% 
% 
% get_unvisited_unerased_predecessors = FINDPATH('-getSubHandles');
% 
% visited = false(1,num_nodes);
% 
% u = get_unvisited_unerased_predecessors(2, graph, predecessors, visited, erased);
% assert(isequal(u,1),'a');
% u = get_unvisited_unerased_predecessors(1, graph, predecessors, visited, erased);
% assert(isempty(u),'b');
% u = get_unvisited_unerased_predecessors(5, graph, predecessors, visited, erased);
% assert(isequal(u,[4,6]),'c');
% 
% visited(graph.get_e_from_vs(6,5)) = true;
% 
% u = get_unvisited_unerased_predecessors(5, graph, predecessors, visited, erased);
% assert(isequal(u,4),'d');

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
left_peak = [];
right_peak = [];
base = [];
predecessors = {[],1,2,3,[4,6],[]};


find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base, left_peak, right_peak);

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
ownership = ones(1,num_nodes); ownership(3) = 2;
bloom = [nan,1,1,nan];
left_peak = 2;
right_peak = 3;
base = 1;
predecessors = {[],1,1,3};

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);

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
ownership = ones(1,num_nodes); ownership([5,7]) = 2;
bloom = [nan,nan,nan,1,1,1,1,nan];
left_peak = 6;
right_peak = 7;
base = 3;
predecessors = {[],1,2,3,3,4,5,7};

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);

path = FINDPATH(high,low,B,find_path_struct);
assert(isequal(path,[8,7,5,3,2,1]));

%%

clear
  
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
ownership = ones(1,num_nodes); ownership([5,7]) = 2;
bloom = [nan,nan,nan,1,1,1,1,nan];
left_peak = 6;
right_peak = 7;
base = 3;
predecessors = {[],1,2,3,3,4,5,4};

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);

path = FINDPATH(high,low,B,find_path_struct);
assert(isequal(path,[8,4,6,7,5,3,2,1]));


%% two blooms

% |_7
% |/5
% | 4
% |_3
% |/1
%   0
% 
adjacency_matrix = zeros(8);
row_subs = [1,1,2,2,2,3,3,4,4,5,5,5,6,6,6,7,7,8];
col_subs = [2,3,1,3,4,1,2,2,5,4,6,7,5,7,8,5,6,6];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;

high = 8;
low = 1;
B = nan;
erased = false(1,num_nodes); 
level = [0,1,1,3,4,5,5,7];
ownership = ones(1,num_nodes); ownership([3,7]) = 2;
bloom = nan(1,num_nodes); bloom([2,3]) = 1; bloom([6,7]) = 2;
bloom_ownership = nan(1,num_nodes);
left_peak = [2,6];
right_peak = [3,7];
base = [1,5];
predecessors = {[],1,1,2,4,5,5,6};

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);

path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[8,6,7,5,4,2,3,1]));

%%

adjacency_matrix = zeros(8);
row_subs = [1,2,2,3,3,3,4,4,4,4,5,5,6,6,7,7,7,8];
col_subs = [2,1,3,2,4,5,3,5,6,7,3,4,4,7,4,6,8,7];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;

high = 8;
low = 1;
B = nan;
erased = false(1,num_nodes); 
level = [0,1,2,3,3,5,5,7];
ownership = [2,2,2,1,2,1,2,2];
bloom = nan(1,num_nodes); bloom([4,5]) = 2; bloom([6,7]) = 1;
left_peak = [6,4];
right_peak = [7,5];
base = [4,3];
predecessors = {[],1,2,3,3,4,4,7};

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);

path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[8,7,6,4,5,3,2,1]));

%%
plot_bool = false;
%% 1

plot_bool = false;

num_nodes = 3;
dummy = num_nodes+1;


row_subs = [2,1,3,2];
col_subs = [1,2,2,3];
level = [0,1,2];
pair = [dummy,3,2];
high = 3;
low = 1;
ownership = [1,1,1];
bloom = nan(1,num_nodes);
left_peak = [];
right_peak = [];
base = [];
predecessors = {[],1,2};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[3,2,1]));

%% 2

plot_bool = false;

num_nodes = 8;
dummy = num_nodes+1;


row_subs = [1,2,2,3,3,3,4,4,5,5,6,6,6,7,7,8];
col_subs = [2,1,3,2,4,5,3,6,3,7,4,7,8,5,6,6];
level = [0,1,2,3,3,4,4,5];
pair = [dummy,3,2,6,7,4,5,dummy];
high = 8;
low = 1;
ownership = [1,1,1,1,2,1,2,1];
bloom = nan(1,num_nodes); bloom([4,5,6,7]) = 1;
left_peak = 6;
right_peak = 7;
base = 3;
predecessors = {[],1,2,3,3,4,5,6};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[8,6,4,3,2,1]));

%% 3

plot_bool = false;

num_nodes = 8;
dummy = num_nodes+1;


row_subs = [1,2,2,3,3,3,4,4,5,5,6,6,7,7,7,8];
col_subs = [2,1,3,2,4,5,3,6,3,7,4,7,8,5,6,7];
level = [0,1,2,3,3,4,4,5];
pair = [dummy,3,2,6,7,4,5,dummy];
high = 8;
low = 1;
ownership = [1,1,1,1,2,1,2,1];
bloom = nan(1,num_nodes); bloom([4,5,6,7]) = 1;
left_peak = 6;
right_peak = 7;
base = 3;
predecessors = {[],1,2,3,3,4,5,7};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[8,7,5,3,2,1]));

%% 4

plot_bool = false;

num_nodes = 8;
dummy = num_nodes+1;

row_subs = [1,2,2,3,3,3,4,4,4,4,5,5,6,6,6,7,7,8];
col_subs = [2,1,3,2,4,5,3,5,6,7,3,4,4,7,8,4,6,6];
level = [0,1,2,3,3,5,5,7];
pair = [dummy,3,2,5,4,7,6,dummy];
high = 8;
low = 1;
ownership = [1,1,1,1,2,1,2,1];
bloom = nan(1,num_nodes); bloom([4,5]) = 1; bloom([6,7]) = 2;
left_peak = [4,6];
right_peak = [5,7];
base = [3,4];
predecessors = {[],1,2,3,3,4,4,6};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[8,6,7,4,5,3,2,1]));


%% 5

plot_bool = false;

num_nodes = 8;
dummy = num_nodes+1;

row_subs = [1,2,2,3,3,3,4,4,4,4,5,5,6,6,7,7,7,8];
col_subs = [2,1,3,2,4,5,3,5,6,7,3,4,4,7,4,6,8,7];
level = [0,1,2,3,3,5,5,7];
pair = [dummy,3,2,5,4,7,6,dummy];
high = 8;
low = 1;
ownership = [1,1,1,1,2,1,2,1];
bloom = nan(1,num_nodes); bloom([4,5]) = 1; bloom([6,7]) = 2;
left_peak = [4,6];
right_peak = [5,7];
base = [3,4];
predecessors = {[],1,2,3,3,4,4,7};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[8,7,6,4,5,3,2,1]));

%% 6

plot_bool = false;

num_nodes = 8;
dummy = num_nodes+1;


row_subs = [1,2,2,3,3,3,4,4,5,5,5,5,6,6,6,7,7,8];
col_subs = [2,1,3,2,4,5,3,5,6,7,3,4,5,7,8,5,6,6];
level = [0,1,2,3,3,5,5,7];
pair = [dummy,3,2,5,4,7,6,dummy];
high = 8;
low = 1;
ownership = [1,1,1,1,2,1,2,1];
bloom = nan(1,num_nodes); bloom([4,5]) = 1; bloom([6,7]) = 2;
left_peak = [4,6];
right_peak = [5,7];
base = [3,5];
predecessors = {[],1,2,3,3,5,5,6};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
dummy = graph.dummy;
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[8,6,7,5,4,3,2,1]));

%% 7 

% 12-13 bloom has been discovered first. 
plot_bool = false;

num_nodes = 14;
dummy = num_nodes+1;

row_subs = [1,2,2,3,3,3,4,4,5,5,6,6,6,7, 7,8,8 ,9, 9,10,10,11,11,11,12,12,12,13,13,14];
col_subs = [2,1,3,2,4,5,3,6,3,7,4,8,9,5,10,6,11,6,12, 7,13, 8,12,14, 9,11,13,10,12,11];
level = [0,1,2,3,3,4,4,5,5,5,6,6,6,7];
pair = [dummy, 3,2,6,7,4,5,11,12,13,8,9,10,dummy];
high = 14;
low = 1;
ownership = [1,1,1,1,2,1,2,1,1,2,1,1,2,1];
bloom = nan(1,num_nodes); bloom([4,5,6,7,9,10,12,13]) = 1; bloom([8,11]) = 2;
left_peak = [12,11];
right_peak = [13,12];
base = [3,3];
predecessors = {[],1,2,3,3,4,5,6,6,7,8,9,10,11};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[14,11,8,6,4,3,2,1]));


%% 7.5

% 11-12 bloom has been discovered first. 

plot_bool = false;

num_nodes = 14;
dummy = num_nodes+1;

row_subs = [1,2,2,3,3,3,4,4,5,5,6,6,6,7, 7,8,8 ,9, 9,10,10,11,11,11,12,12,12,13,13,14];
col_subs = [2,1,3,2,4,5,3,6,3,7,4,8,9,5,10,6,11,6,12, 7,13, 8,12,14, 9,11,13,10,12,11];
level = [0,1,2,3,3,4,4,5,5,5,6,6,6,7];
pair = [dummy, 3,2,6,7,4,5,11,12,13,8,9,10,dummy];
high = 14;
low = 1;
ownership = [1,1,1,1,2,1,2,1,2,2,1,2,2,1];
bloom = nan(1,num_nodes); bloom([8,9,11,12]) = 1; bloom([4,5,6,7,10,13]) = 2;
left_peak = [11,12];
right_peak = [12,13];
base = [6,3];
predecessors = {[],1,2,3,3,4,5,6,6,7,8,9,10,11};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[14,11,8,6,4,3,2,1]));

%% 8

% 12-13 bloom has been discovered first.

plot_bool = false;

num_nodes = 14;
dummy = num_nodes+1;

row_subs = [1,2,2,3,3,3,4,4,5,5,6,6,6,7, 7,8,8 ,9, 9,10,10,11,11,12,12,12,12,13,13,14];
col_subs = [2,1,3,2,4,5,3,6,3,7,4,8,9,5,10,6,11,6,12, 7,13, 8,12,14, 9,11,13,10,12,12];
level = [0,1,2,3,3,4,4,5,5,5,6,6,6,7];
pair = [dummy, 3,2,6,7,4,5,11,12,13,8,9,10,dummy];
high = 14;
low = 1;
ownership = [1,1,1,1,2,1,2,1,1,2,1,1,2,1];
bloom = nan(1,num_nodes); bloom([4,5,6,7,9,10,12,13]) = 1; bloom([8,11]) = 2;
left_peak = [12,11];
right_peak = [13,12];
base = [3,3];
predecessors = {[],1,2,3,3,4,5,6,6,7,8,9,10,12};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[14,12,9,6,4,3,2,1]));

%% 8.5

% 11-12 bloom has been discovered first. 
plot_bool = false;

num_nodes = 14;
dummy = num_nodes+1;

row_subs = [1,2,2,3,3,3,4,4,5,5,6,6,6,7, 7,8,8 ,9, 9,10,10,11,11,12,12,12,12,13,13,14];
col_subs = [2,1,3,2,4,5,3,6,3,7,4,8,9,5,10,6,11,6,12, 7,13, 8,12,14, 9,11,13,10,12,12];
level = [0,1,2,3,3,4,4,5,5,5,6,6,6,7];
pair = [dummy, 3,2,6,7,4,5,11,12,13,8,9,10,dummy];
high = 14;
low = 1;
ownership = [1,1,1,1,2,1,2,1,2,2,1,2,2,1];
bloom = nan(1,num_nodes); bloom([8,9,11,12]) = 1; bloom([4,5,6,7,10,13]) = 2;
left_peak = [11,12];
right_peak = [12,13];
base = [6,3];
predecessors = {[],1,2,3,3,4,5,6,6,7,8,9,10,12};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[14,12,9,6,4,3,2,1]));

%% 9 
%11-12 bridge first. 
plot_bool = false;

num_nodes = 14;
dummy = num_nodes+1;

row_subs = [1,2,2,3,3,3,4,4,5,5,6,6,7,7, 7,8, 8,9, 9,10,10,11,11,12,12,12,12,13,13,14];
col_subs = [2,1,3,2,4,5,3,6,3,7,4,8,5,9,10,6,11,7,12, 7,13, 8,12, 9,11,13,14,10,12,12];
level = [0,1,2,3,3,4,4,5,5,5,6,6,6,7];
pair = [dummy, 3,2,6,7,4,5,11,12,13,8,9,10,dummy];
high = 14;
low = 1;
ownership = [1,1,1,1,2,1,2,1,2,2,1,2,2,1];
bloom = nan(1,num_nodes); bloom([4,5,6,7,8,9,11,12]) = 1; bloom([13,10]) = 2;
left_peak = [11,12];
right_peak = [12,13];
base = [3,3];
predecessors = {[],1,2,3,3,4,5,6,7,7,8,9,10,12};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[14,12,9,7,5,3,2,1]));

%% 9.5 
%12-13 bridge first. 
plot_bool = false;

num_nodes = 14;
dummy = num_nodes+1;

row_subs = [1,2,2,3,3,3,4,4,5,5,6,6,7,7, 7,8, 8,9, 9,10,10,11,11,12,12,12,12,13,13,14];
col_subs = [2,1,3,2,4,5,3,6,3,7,4,8,5,9,10,6,11,7,12, 7,13, 8,12, 9,11,13,14,10,12,12];
level = [0,1,2,3,3,4,4,5,5,5,6,6,6,7];
pair = [dummy, 3,2,6,7,4,5,11,12,13,8,9,10,dummy];
high = 14;
low = 1;
ownership = [1,1,1,1,2,1,2,1,1,2,1,1,2,1];
bloom = nan(1,num_nodes); bloom([9,10,12,13]) = 1; bloom([4,5,6,7,8,11]) = 2;
left_peak = [12,11];
right_peak = [13,12];
base = [7,3];
predecessors = {[],1,2,3,3,4,5,6,7,7,8,9,10,12};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[14,12,9,7,5,3,2,1]));

%% 10 

%11-12 bridge first. 
plot_bool = false;

num_nodes = 14;
dummy = num_nodes+1;

row_subs = [1,2,2,3,3,3,4,4,5,5,6,6,7,7, 7,8, 8,9, 9,10,10,11,11,12,12,12,13,13,13,14];
col_subs = [2,1,3,2,4,5,3,6,3,7,4,8,5,9,10,6,11,7,12, 7,13, 8,12, 9,11,13,14,10,12,13];
level = [0,1,2,3,3,4,4,5,5,5,6,6,6,7];
pair = [dummy, 3,2,6,7,4,5,11,12,13,8,9,10,dummy];
high = 14;
low = 1;
ownership = [1,1,1,1,2,1,2,1,2,2,1,2,2,1];
bloom = nan(1,num_nodes); bloom([4,5,6,7,8,9,11,12]) = 1; bloom([13,10]) = 2;
left_peak = [11,12];
right_peak = [12,13];
base = [3,3];
predecessors = {[],1,2,3,3,4,5,6,7,7,8,9,10,13};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[14,13,10,7,5,3,2,1]));



%% 10.5
 
% 12-13 bridge first. 
plot_bool = false;

num_nodes = 14;
dummy = num_nodes+1;

row_subs = [1,2,2,3,3,3,4,4,5,5,6,6,7,7, 7,8, 8,9, 9,10,10,11,11,12,12,12,13,13,13,14];
col_subs = [2,1,3,2,4,5,3,6,3,7,4,8,5,9,10,6,11,7,12, 7,13, 8,12, 9,11,13,14,10,12,13];
level = [0,1,2,3,3,4,4,5,5,5,6,6,6,7];
pair = [dummy, 3,2,6,7,4,5,11,12,13,8,9,10,dummy];
high = 14;
low = 1;
ownership = [1,1,1,1,2,1,2,1,1,2,1,1,2,1];
bloom = nan(1,num_nodes); bloom([9,10,12,13]) = 1; bloom([4,5,6,7,8,11]) = 2;
left_peak = [12,11];
right_peak = [13,12];
base = [7,3];
predecessors = {[],1,2,3,3,4,5,6,7,7,8,9,10,13};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[14,13,10,7,5,3,2,1]));


%% 11
plot_bool = true;

num_nodes = 16;
dummy = num_nodes + 1;

row_subs = [1,2,3,3,4,4,5,5,5,5,6, 6,7, 7,8, 8,9, 9,10,10,11,11,12,12,13,13,13,14,14,15,15,16,16,16];
col_subs = [3,4,1,5,2,6,3,7,8,9,4,10,5,11,5,12,5,13, 6,14, 7,15, 8,13, 9,12,16,10,16,11,16,13,14,15];
level = [0,0,1,1,2,2,3,3,3,3,4,4,4,4,5,5];
pair = [dummy,dummy,5,6,3,4,11,12,13,14,7,8,9,10,16,15];
high = 16;
low = 2;
ownership = [1,2,1,2,1,2,1,1,2,2,1,1,2,2,1,2];
bloom = nan(1,num_nodes);bloom([8,9,12,13]) = 1;
left_peak = 12;
right_peak = 13;
base = 5;
predecessors = {[],[],1,2,3,4,5,5,5,6,7,8,9,10,11,[13,14]};

adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);

assert(isequal(path,[16,14,10,6,4,2]));

%% 12
plot_bool = true;
num_nodes = 11;
dummy = num_nodes +1;

row_subs = [1,1,2,2,3,3,4,4,5,5,5,6,6, 6,7,7,8,8,9, 9,10,10,11,11];
col_subs = [2,3,1,4,1,5,2,6,3,7,8,4,7,10,5,6,5,9,8,11, 6,11, 9,10];
level = [0,1,1,2,2,3,3,3,4,5,5];
pair = [dummy,4,5,2,3,7,6,9,8,11,10];
high = 10;
low = 1;
ownership = [2,1,2,1,2,1,2,1,1,2,1];
bloom = nan(1,num_nodes); bloom([2,3,4,5,6,7]) = 1; bloom([8,9,10,11]) = 2;
left_peak = [6,11];
right_peak = [7,10];
base = [1,1];
predecessors = {[],1,1,2,3,4,5,5,8,6,9};
adjacency_matrix = zeros(num_nodes);
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
B = nan;
erased = false(1,num_nodes);

if plot_bool
    close all
    plot_matching(adjacency_matrix,level,pair,'');
end

find_path_struct = v2struct(predecessors, graph, erased, ...
    level,ownership,bloom,base,left_peak,right_peak);
path = FINDPATH(high,low,B,find_path_struct);























