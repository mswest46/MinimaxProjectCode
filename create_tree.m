
function tree = create_tree(numberGeneration, offspringDistribution, ... 
    terminalNodeDistribution, plot)

% CREATE_TREE - returns a Galton-Watson tree of given height in TODO format 
% with the branching probabilities given by offspringDistribution and
% terminal node values from terminalNodeDistribution
%
% Inputs:
%    numberGeneration - cutoff for tree height. Should be an even number
%    offspringDistribution - a structure with a 'type' field, and a 'params'
%    field.
%    terminalNodeDistribution - a structure with a 'type' field, and a 'params'
%    field.
%
% Outputs:
%    tree - a structure containing TODO arrays
%
% Example: 
%    tree1 = create_tree(10, 'geometric')
%    returns TODO
%    tree1 = create_tree(10, [0,0,1])
%    returns TODO
% Based on code by: R.Gaigalas, I.Kaj

parents = 0; % convention: root node has parent 0
extinct = 0; % tree not extinct
numberKids = 1; % root nodes is a child


for generation = 1:numberGeneration
    
    % kids in previous generation are now parents, with indices
    % parentIndices. sample is an array representing the number of kids the
    % parents have. We reset the total number of kids.
    numberParents = numberKids;
    parentIndices = length(parents) - numberKids + 1: length(parents);
    sample = random_sample(offspringDistribution, numberParents);
    numberKids = 0;
    
    for j = 1:max(sample)
        parentsWithJChildren = parentIndices(sample == j);
        disp(parentsWithJChildren);
        if ~isempty(parentsWithJChildren)
            parents = [parents repmat(parentsWithJChildren, 1, j)]; %TODO avoid changing array size
            numberKids = numberKids + length(parentsWithJChildren) * j;
        end
    end
    
    if (numberKids == 0)
        extinct = 1;
        break
    end
    
    if generation == numberGeneration;
        % assign values to the terminal nodes
        values = NaN(1, length(parents));
        value_sample = random_sample(terminalNodeDistribution, numberKids);
        values(length(parents) - numberKids + 1: length(parents))=value_sample;
        
    end
    
end

tree.parents = parents;
tree.values = values;
       

if (extinct)
    fprintf('Extinct in generation %d\n', generation);
else
    fprintf('Stopped in generation %d\n', numberGeneration);
end

if plot
    close all;
    addpath('~/Code/MinimaxProjectCode/ExternalPackages/rtree-2.1/rtree');
    
    index = find(~isnan(tree.values), 1);
    [x,y] = trimtreelayout(tree.parents);
    x = x(index:end);
    y = y(index:end);
    labels = strtrim(cellstr(num2str(tree.values(index:end)'))');
    figure;
    trimtreeplot(tree.parents);
    text(x,y+.02,labels);


end
