clear; 
close all;

mat = zeros(7);
idx = sub2ind([7,7], [1,2,3,3,4,5,5,6,6,7], [5,6,5,7,6,1,3,2,4,3]);
mat(idx) = 1;

[matching_size, matching_matrix] = hopcroft_karp(mat)

for i = 1:length(mat(:,1))
    small_mat = mat;
    small_mat(:,i) = [];
    small_mat(i,:) = [];
    [small_matching(i), ~] = hopcroft_karp(small_mat);
    
end

find(small_matching<matching_size)