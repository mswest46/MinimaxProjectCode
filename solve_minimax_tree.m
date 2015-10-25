function [rootValue, tree] = solve_minimax_tree(tree, algorithm)

% solve_minimax_tree - returns the value of the root node for the given
% tree using the given algorithm. Also returns the terminal node the
% algorithm reaches. 
%
% Inputs:
%    tree - An struct representing a tree 
%    algorithm - A string specifying the algorithm for solving the tree
%
% Outputs:
%    rootValue - the value of the root node as determined by the specified
%    algorithm 
%    terminalNode - the node the algorithm reaches 
%
% Example: 
%    exampleTree is TODO
%    [rootValue, terminalNode] = solve_minimax_tree(exampleTree, 'alpha_beta')
%    returns [TODO, TODO]


switch algorithm
    case 'minimax'        
        rootValue = minimax(tree, 1, true);
    case 'alpha_beta'
        rootValue = alpha_beta(tree, 1, -inf, inf, true);
    otherwise
        disp('specify a valid algorithm');
end
end



function value = minimax(tree, node, maxPlayer)

if ~isnan(tree.values(node))
    value = tree.values(node);
    return
end

if maxPlayer
    children = childrenOf(tree, node);
    bestValue = -inf;
    for i = 1:length(children)
        child = children(i);
        val = minimax(tree, child, false);
        bestValue = max(bestValue, val);
    end
else
    bestValue = inf;
    children = childrenOf(tree, node);
    for i = 1:length(children)
        child = children(i);
        val = minimax(tree, child, true);
        bestValue = min(bestValue, val);
    end
end

value = bestValue;
       
end

function value = alpha_beta(tree, node, alpha, beta, maxPlayer)

if ~isnan(tree.values(node))
    value = tree.values(node);
    return
end

if maxPlayer
    children = childrenOf(tree, node);
    bestValue = -inf;
    for i = 1:length(children)
        child = children(i);
        val = alpha_beta(tree, child, alpha, beta, false);
        bestValue = max(bestValue, val);
        alpha = max(alpha, bestValue);
        if (alpha >= beta)
            break
        end
    end
else
    children = childrenOf(tree, node);
    bestValue = inf;
    for i = 1:length(children)
        child = children(i);
        val = alpha_beta(tree, child, alpha, beta, true);
        bestValue = min(bestValue, val);
        beta = min(beta, bestValue);
        if (alpha >= beta)
            break
        end
    end
end

value = bestValue;

end


function children = childrenOf(tree, node)
children = find(tree.parents==node);
end



    

        
        