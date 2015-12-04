function [max_matching_found, bridges, levels, predecessors, ...
    predecessors_count] = SEARCH(adjacency_matrix, pair)

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


predecessors = zeros(num_nodes);
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


while ~bridge_found
    
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
            free_neighbors = neighbors(neighbors ~= pair(u));
            for i = 1: length(free_neighbors)
                v = free_neighbors(i);
                if odd_level(v) >= search_level+1
                    % what if odd_level is already assigned?
                    % Answer: it is already assigned if it is <=
                    % search_level + 1. However, we still include it in
                    % ancestry list.
                    odd_level(v) = search_level+1;
                    predecessors(u,v) = 1;
                    if even_level(v) < inf
                        bridge_found = 1;
                        bridges_position = bridges_position + 1;
                        bridges(:,bridges_position) = [u;v];
                        
                        
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
                even_level(v) = search_level + 1;
                predecessors(u,v) = 1;
                
                if odd_level(v) < inf
                    bridge_found = 1;
                    bridges_position = bridges_position + 1;
                    bridges(:,bridges_position) = [u;v];
                end
            end
        end
    end
end


levels.even_level = even_level;
levels.odd_level = odd_level;

for i = 1: length(bridges(1,:))-1
    for j = i+1: length(bridges(1,:))
        if (bridges(1,i) == bridges(2,j) && bridges(2,i) == bridges(1,j))
            bridges(:,i) = [0;0];
        end
    end
end
bridges(:, ~any(bridges,1)) = [];

predecessors_count = sum(predecessors);

if max_matching_found
    disp('max matching found');
    return
end


% disp([num2str(length(bridges(1,:))), ' bridges found in level ',...
%     num2str(search_level)]);

end


