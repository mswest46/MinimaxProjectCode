function pair = hopcroft_karp(adjacency_matrix)

[part1, ~] = bipartition(adjacency_matrix);
num_nodes = length(adjacency_matrix(:,1));
dummy = num_nodes+1;
pair = dummy*ones(1,num_nodes);
% pair is an array which contains the matching information. everything
% initially is free, so we say it is paired with dummy.
matching_size = 0; %mantained only for display purposes.
dispstat('','init');

while true
    [layer, done] = BFS(adjacency_matrix, part1, num_nodes, dummy, pair);
    % BFS performs a breadth first search on our graph, and assigns layers
    % to the vertices corresponding to distances from free vertices. It
    % returns done==true if we don't have any augmenting paths
    if done
        disp(['number of vertices in the matching: ',...
            num2str(sum(pair<dummy))]);
        break
    end
    for i = 1: length(part1);
        u = part1(i);
        if pair(u) == dummy
            % u is free
            [augment, inner_pair, inner_layer] = DFS(...
                adjacency_matrix, pair, layer, dummy, u);
            if augment
                % u is in an augmenting path. increment the matching size
                % by one for display purposes.
                matching_size = matching_size + 2;
                
                dispstat([num2str(100*matching_size/num_nodes),...
                    '% of nodes matched']);
                
                pair = inner_pair;
                layer = inner_layer;
            end
        end
    end
end
end


function [layer,done] = BFS(adjacency_matrix, part1,num_nodes,dummy,pair)

% this queue system involves resizing the array all the time. that's silly.

queue = zeros(1,num_nodes);
q_location = 0; % the last nonempty element.
layer = nan(1,num_nodes+1);
for i = 1: length(part1)
    % determine which vertices are free and which are not in the current
    % matching
    u = part1(i);
    if pair(u) == dummy
        layer(u) = 0;
        q_location = q_location+1;
        queue(q_location) = u;
    else
        layer(u) = inf;
    end
    layer(dummy) = inf;
end

free = find(pair == dummy);
layer(free) = 0;
layer(~free) = inf;
Q = free;


while q_location>0
    u = queue(q_location);
    q_location = q_location-1;
    if layer(u) < layer(dummy)
        % because dummy starts at inf, once dummy has changed to something
        % less than inf we know we've found some minimal augmenting paths
        neighbors = find(adjacency_matrix(:,u));
        for i = 1: length(neighbors)
            v = neighbors(i);
            if layer(pair(v)) == inf
                % otherwise, we've already labelled this bad boy.
                layer(pair(v)) = layer(u) + 1;
                q_location = q_location + 1;
                queue(q_location) = pair(v);
            end
        end
    end
    
end
done = layer(dummy)==inf;
% if layer(dummy)=inf then every neighbor of every u in our queue is in the
% matching.
end

function [bool,pair,layer] = DFS(adjacency_matrix,pair,layer,dummy,u)

if ~(u == dummy)
    % otherwise we have reached a free vx and so we've completing an
    % augmenting path.
    neighbors = find(adjacency_matrix(:,u));
    for i = 1:length(neighbors)
        v = neighbors(i);
        if layer(pair(v)) == layer(u) + 1
            [bool, pair, layer] = DFS(...
                adjacency_matrix,pair,layer,dummy,pair(v));
            if bool
                pair(v) = u;
                pair(u) = v;
                return
                % returns to parent function
            end%
        end
    end
    % we only get here when there are no aug paths from u to free vx.
    layer(u) = inf; % we do this so we don't check it again for other u
    bool = false;
    return
    % returns to parent function.
else
    % we are at dummy vertex.
    bool = true;
end

end

