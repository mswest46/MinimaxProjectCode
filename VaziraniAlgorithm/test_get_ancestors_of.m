%    __
%   1  1
%   |~ |~
%   |/ |/
%   1  1
%   |  |

clear

adjacency_matrix = zeros(14);
row_subs = [1,2,3,3,4,4,5,5,5,6,6,6 ,7,7, 7,9,9 ,9 ,8,8,10,10,11,11,12,12,13,13,14,14];
col_subs = [3,4,1,5,2,6,3,7,8,4,9,10,5,8,11,6,10,12,5,7,6 ,9 ,7 ,13, 9,14,11,14,12,13];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;
predecessors = {[],[],1,2,3,4,5,5,6,6,7,9,11,12};



vxs = [13,14];

ancestors = get_ancestors_of(vxs,predecessors, num_nodes);
assert(isequal(ancestors,[1,2,3,4,5,6,7,9,11,12,13,14]));