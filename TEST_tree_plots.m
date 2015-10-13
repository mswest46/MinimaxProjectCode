close all;

addpath('~/Code/MinimaxProjectCode/ExternalPackages/rtree-2.1/rtree')

offspringDistribution = struct('type', 'custom', 'params', [0, 0, 1]);
terminalNodeDistribution = struct('type', 'uniform', 'params', [0, 1]);

tree = create_tree(6, offspringDistribution, terminalNodeDistribution);
index = find(~isnan(tree.values), 1);
[x,y] = trimtreelayout(tree.parents);
x = x(index:end);
y = y(index:end);
labels = strtrim(cellstr(num2str(tree.values(index:end)'))');
figure;
trimtreeplot(tree.parents);
text(x,y+.02,labels);

[value,solved_tree] = solve_minimax_tree(tree, 'alpha_beta');
[x,y] = trimtreelayout(tree.parents);
figure;
trimtreeplot(solved_tree.parents);
labels = strtrim(cellstr(num2str(solved_tree.values'))');
text(x,y+.02,labels);