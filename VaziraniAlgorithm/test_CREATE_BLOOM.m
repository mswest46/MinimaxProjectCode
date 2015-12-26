% test_CREATE_BLOOM

%  search_level = create_bloom_struct.search_level;
%  bloom_number = create_bloom_struct.bloom_number;
%  bloom = create_bloom_struct.bloom;
%  bloom_ownership = create_bloom_struct.bloom_ownership;
%  left_peak = create_bloom_struct.left_peak;
%  right_peak = create_bloom_struct.right_peak;
%  base = create_bloom_struct.base;
%  bottleneck = create_bloom_struct.bottleneck;
%  init_right = create_bloom_struct.init_right;
%  init_left = create_bloom_struct.init_left;
%  ownership = create_bloom_struct.ownership;
%  even_level = create_bloom_struct.even_level;
%  odd_level = create_bloom_struct.odd_level;
%  candidates = create_bloom_struct.candidates;
%  anomalies = create_bloom_struct.anomalies;
%  bridges = create_bloom_struct.bridges;


clear

adjacency_matrix = zeros(12);
row_subs = [1,2,2,3,3,3,4,4,5,5,5 ,6,6,7,7,8,9,9 ,10,10,11,11,12,12];
col_subs = [2,1,3,2,4,5,3,6,3,7,12,4,7,6,5,9,8,10,9 ,11,10,12,11,5 ];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;
dummy = graph.dummy;

search_level = 4;
bloom_number = 0;
bloom = nan(1,num_nodes);
bloom_ownership = zeros(1,num_nodes);
left_peak = [];
right_peak = [];
base = [];
bottleneck = 3;
init_right = 7;
init_left = 6;
ownership = zeros(1,num_nodes); ownership([4,6]) = 1;...
    ownership([5,7]) = 2;
marked_vertices = (ownership>0);
old_even_level = inf(1,num_nodes); old_even_level([1,8]) = 0; ...
    old_even_level([3,10]) = 2; old_even_level([6,7,12]) = 4; ...
    even_level = old_even_level;
old_odd_level = inf(1,num_nodes); old_odd_level([2,9]) = 1;...
    old_odd_level([4,5,11]) = 3; odd_level = old_odd_level;

candidates = cell(1,num_nodes);
anomalies = cell(1,num_nodes);
anomalies{5} = 12;
bridges = cell(1,num_nodes);


level = min(old_odd_level, old_even_level);

create_bloom_struct = v2struct(graph, search_level, bloom_number,bloom,bloom_ownership,...
    left_peak,right_peak,base,bottleneck,init_left,init_right,ownership, marked_vertices,...
    even_level, odd_level, candidates, anomalies, bridges);

[bloom_number, bloom, base, left_peak,right_peak, bloom_ownership, ...
    odd_level, even_level, candidates, bridges] = ...
    CREATE_BLOOM(create_bloom_struct);


assert(bloom_number == 1, '1');
assert(isequal(bloom([4,5,6,7]),[1,1,1,1]), '2');
assert(base == 3, '3');
assert(left_peak ==6, '4');
assert(right_peak == 7, '5');
assert(isequal(bloom_ownership,ownership), '6');
nol = old_odd_level; nol([6,7]) = 5; 
assert(isequal(odd_level, nol),'7');
nel = old_even_level; nel([4,5]) = 6;
assert(isequal(nel, even_level),'8');
assert(isequal(candidates{7},[4,5]),'10'); % matlab indexing...
assert(isequal(bridges{6}, graph.get_e_from_vs(5,12)),'11');


