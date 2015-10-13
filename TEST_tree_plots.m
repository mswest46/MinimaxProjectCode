close all;

addpath('~/Code/MinimaxProjectCode/ExternalPackages/rtree-2.1/rtree');

offspringDistribution = struct('type', 'custom', 'params', [0, 0, 1]);
terminalNodeDistribution = struct('type', 'uniform', 'params', [0, 1]);

rootValues = zeros(1, 100);

for i = 1:100
    tree = create_tree(16, offspringDistribution, terminalNodeDistribution, false);
    rootValues(i) = solve_minimax_tree(tree, 'alpha_beta');
end

hist(rootValues);