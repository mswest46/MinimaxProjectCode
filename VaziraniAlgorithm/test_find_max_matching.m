% test_find_max_matching
adjacency_matrix = zeros(12);
row_subs = [1,2,2,3,3,3,4,4,5,5,5 ,6,6,7,7,8,9,9 ,10,10,11,11,12,12];
col_subs = [2,1,3,2,4,5,3,6,3,7,12,4,7,6,5,9,8,10,9 ,11,10,12,11,5 ];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;

pair = [13,3,2,6,7,4,5,13,10,9,12,11];
pair = find_max_matching(adjacency_matrix, pair);
assert(isequal(pair, [2,1,4,3,12,7,6,9,8,11,10,5]));