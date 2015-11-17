%% make a test graph for exposition purposes. 
clear
close all;

num_nodes = 14;
adjacency_matrix1 = zeros(num_nodes);
row_sub = [1,2,2,3,3,3 ,3 ,4,4,5,5,6,6,6,7,8,8,9,9 ,9 ,10,10,11,11,12,12,13,13,14,14];
col_sub = [2,1,3,2,4,12,10,3,5,4,6,5,7,8,6,6,9,8,10,11,9 ,3 ,14,9 ,3 ,13,12,14,13,11];
height = [7,6,5,3,2,1,0,2 ,3,4,5,6,7,6];
x_pos = [1,1,3,1,2,3,3,4,5,4,6,4,5,6];
xy = [x_pos; height]';
adjacency_matrix1(sub2ind([num_nodes,num_nodes], row_sub, col_sub)) = 1;
run1 = DDFS(adjacency_matrix1,  height,  1, 13, xy);             

%%
num_nodes = 10;
adjacency_matrix2 = zeros(num_nodes);
row_sub = [1,2,2,3,3,4,4,5,5,6,6,6,6,7,7,8,8,8 ,9,10];
col_sub = [3,4,5,1,6,2,6,2,8,3,4,7,8,6,9,5,6,10,7,8 ];
height = [4,4,3,3,3,2,1,1,0,0];
x_pos = [1,3,1,2,3,2,1,2,1,2];
xy = [x_pos; height]';
adjacency_matrix2(sub2ind([num_nodes,num_nodes], row_sub, col_sub)) = 1;
run2 = DDFS(adjacency_matrix2, height, 1, 2, xy);

%%
num_nodes = 12;
adjacency_matrix3 = zeros(num_nodes);
row_sub = [1,1,2,2,3,3,3,4,4,5,5,6,6,7,7,7,8,8 ,9,9,9, 9,10,10,11,11,11,12];
col_sub = [2,3,1,5,1,6,7,7,8,2,9,3,9,3,4,9,4,10,5,6,7,11,8 ,11, 9,10,12,11];
height = [5,4,4,4,3,3,3,3,2,2,1,0];
x_pos = [1,1,2,4,1,2,3,4,2,3,2,2];
xy = [x_pos; height]';
adjacency_matrix3(sub2ind([num_nodes,num_nodes], row_sub, col_sub)) = 1;
run3 = DDFS(adjacency_matrix3, height, 1, 4, xy);

%%
num_nodes = 9;
adjacency_matrix4 = zeros(num_nodes);
row_sub = [1,1,2,3,3,4,4,5,5,6,6,7,7,7,8,8,8,9];
col_sub = [3,7,4,1,6,2,5,4,7,3,8,1,5,8,6,7,9,8];
height = [5,5,4,4,3,2,2,1,0];
x_pos = [2,4,1,4,3,1,2,2,2];
xy = [x_pos; height]';
adjacency_matrix4(sub2ind([num_nodes,num_nodes], row_sub, col_sub)) = 1;
run4 = DDFS(adjacency_matrix4, height, 1, 2, xy);


