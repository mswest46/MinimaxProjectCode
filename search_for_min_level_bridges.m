function [max_matching_found, search_level, bridges, levels, predecessors] = ...
    search_for_min_level_bridges(adjacency_matrix, pair)

% SEARCH - determines whether matching is maximal, assigns levels to nodes,
% finds minimum level bridge, and determines predecessors.
%
% Syntax:  [max_matching_found, bridges, levels, predecessors, ...
%   predecessors_count] = SEARCH(adjacency_matrix, pair)
%
% Inputs:
%    adjacency_matrix - sparse matrix describing the graph. 
%    pair - vector describing the matching. 
%
% Outputs:
%    max_matching_found - a boolean indicating whether maximal matching
%    found
%    bridges - a list of bridges found in search_level TODO format
%    levels - the odd and even levels of the nodes
%    predecessors - a matrix representing the directed graph of
%    predecessors


% TODO: the anomolies bit.

num_nodes = length(adjacency_matrix(:,1));
dummy = num_nodes+1;

% initialize all levels to inf
even_level = inf(1,num_nodes);
odd_level = inf(1,num_nodes);


bridges = zeros(2,num_nodes);
bridges_position = 0;
% contains the pairs of bridges. currently doubles up for bridges found in
% the same level.

nzmax = num_nodes; % temporary guess, not sure yet. 
predecessors = spalloc(num_nodes, num_nodes, nzmax); 
% predecessors = zeros(num_nodes);
% NB that this is not going to be a symmetric matrix! Let's say that the jth column
% contains the predecessors of vx j. so we access j's predecessors with
% predecessors(:,j), and set i to be predecessor of j with
% predecessors(i,j) = 1. Might be more memory efficient to have
% predecessors in an array with preallocated size. TODO


search_level = -1;
bridge_found = 0;
max_matching_found = 0;

% set the free vertices to even_level 0 and add these to the DFS queue.
even_level(pair == dummy)=0;

while ~aug_path_exists
    
    %increment search_level
    search_level = search_level+1;
    
    if ~mod(search_level,2) % search_level is even
        queue = find(even_level == search_level);
        if isempty(queue)
            max_matching_found = 1;
            break
        end
        for u = queue
            neighbors = find(adjacency_matrix(u,:)); 
            % all the vertices adjacent to u.
            free_neighbors = neighbors(neighbors ~= pair(u));
            % only the vertices along unmatched edges. 
            for i = 1: length(free_neighbors)
                v = free_neighbors(i);
                if odd_level(v) >= search_level+1 
                % so we're not going back down to some predecessor of u?
                    if even_level(v) < inf
                        bridge_found = 1; 
                        % we will terminate after this level
                        bridges_position = bridges_position + 1;
                        % for data storing purposes. 
                        bridges(:,bridges_position) = [u;v];
                    else
                        odd_level(v) = search_level+1; 
                        predecessors(u,v) = 1; % don't assign if bridge!!
                    end
                end
            end
        end
        
    else % odd search_level. will be searching along matched edges
        queue = find(odd_level == search_level);
        if isempty(queue)
            max_matching_found = 1;
            break
        end
        for u = queue
            v = pair(u);
            if v ~= dummy % i.e. v is not free
                if odd_level(v) < inf
                    bridge_found = 1;
                    bridges_position = bridges_position + 1;
                    bridges(:,bridges_position) = [u;v];
                else % v has inf odd_level
                    even_level(v) = search_level + 1;
                    predecessors(u,v) = 1;
                end
            end
        end
    end
end

levels.even_level = even_level;
levels.odd_level = odd_level;

bridges(:, ~any(bridges,1)) = []; %remove zeros in bridges. 

end


