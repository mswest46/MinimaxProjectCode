close all;

addpath('~/Code/MinimaxProjectCode/ExternalPackages/rtree-2.1/rtree');

offspringDistribution = struct('type', 'custom', 'params', [0, 0, 1]);
terminalNodeDistribution = struct('type', 'uniform', 'params', [0, 1]);

rootValues = zeros(1, 100);

for i = 1:10000
    if (mod(i, 100) == 0)
        disp(i)
    end
    
    tree = create_tree(10, offspringDistribution, terminalNodeDistribution, false);
    rootValues(i) = solve_minimax_tree(tree, 'alpha_beta');
end

hist(rootValues);