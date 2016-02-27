function [pair,core] = find_max_matching(adjacency_matrix, KS, algorithm)

% finds a maximum matching in the graph G represented by the
% adjacency_matrix. KS is a boolean indicating whether we should run KS
% greedy algorithm before fine-tuning. algorithm is a string taking values
% in 'karp-sipser', 'vazirani', 'edmonds'. Respectively, we should find max
% matching via the karp-sipser (in which case matching will not be
% maximal), vazirani (which is broken right now), or edmonds algorithms. 

assert(nargin==3);
assert(islogical(KS));
assert(strcmp(algorithm, 'karp-sipser') || ...
    strcmp(algorithm, 'vazirani') || ...
    strcmp(algorithm, 'edmonds') || ...
    strcmp(algorithm, 'maxWeightMatching') || ...
    strcmp(algorithm, 'vazirani2'));
    

addpath('~/Code/MinimaxProjectCode/KarpSipserAlgorithm/');
addpath('~/Code/MinimaxProjectCode/EdmondsAlgorithm/');
addpath('~/Code/MinimaxProjectCode/VaziraniAlgorithm/');
addpath('~/Code/MinimaxProjectCode/maxWeightMatching/');
addpath('~/Code/VM');

dispstat('','init');
dispstat(['finding maximum matching with ', algorithm, ' algorithm'],...
    'keepthis');

%%
core = '';
if KS
    [pair,core] = karp_sipser_matching(adjacency_matrix);
else
    pair = '';
end    

switch algorithm
    case 'karp-sipser'
        [pair,core] = karp_sipser_algorithm(adjacency_matrix);
    case 'vazirani'
        pair = vazirani_matching(adjacency_matrix,pair);
    case 'vazirani2'
        pair = vazirani_matching2(adjacency_matrix,pair);
    case 'edmonds'
        pair = edmonds_matching(adjacency_matrix,pair);
    case 'maxWeightMatching'
        [row_subs, col_subs] = ind2sub(size(adjacency_matrix),...
            find(adjacency_matrix));
        inedges = [row_subs,col_subs,ones(length(row_subs),1)];
        pair = maxWeightMatching(inedges);
end

end

