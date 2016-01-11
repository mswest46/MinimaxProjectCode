%% Solve trees

trees_file = '~/Data/Trees/Sample001/trees.mat';
trees = importdata(trees_file);

temp = size(trees);
numTrees = temp(2);
values = zeros(numTrees, 1);
for i = 1: numTrees
    disp(i);
    values(i) = solve_minimax_tree(trees(i), 'alpha_beta');
end

disp(mean(values));