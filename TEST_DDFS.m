%% make a test graph for exposition purposes. 

num_nodes = 14;

adjacency_matrix = zeros(num_nodes);

row_sub = [1,2,2,3,3,3 ,3 ,4,4,5,5,6,6,6,7,8,8,9,9 ,9 ,10,10,11,11,12,12,13,13,14,14];
col_sub = [2,1,3,2,4,12,10,3,5,4,6,5,7,8,6,6,9,8,10,11,9 ,3 ,14,9 ,3 ,13,12,14,13,11];
height = [7,6,5,3,2,1,0,2 ,3,4,5,6,7,6];
x_pos = [1,1,3,1,2,3,3,4,5,4,6,4,5,6];
xy = [x_pos; height]';
adjacency_matrix(sub2ind([num_nodes,num_nodes], row_sub, col_sub)) = 1;

DDFS(adjacency_matrix, height,  1, 13, xy);             