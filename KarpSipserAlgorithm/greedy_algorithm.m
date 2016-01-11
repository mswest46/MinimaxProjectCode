function [pair,core] = greedy_algorithm(adjacency_matrix)

G = create_graph_struct_from_adjacency_matrix(adjacency_matrix);


% graph has been constructed from create_graph_struct.

num_nodes = G.num_nodes;
dummy = G.dummy;
pair = dummy*ones(1,num_nodes);
removed_vxs = false(1,num_nodes);
pendants = false(1,num_nodes);
neighbors = G.neighbors;
phase = 1;
matching_size = 0;
dispstat('','init');
shortcut_pendant = nan;

for i = 1:num_nodes
    if isempty(neighbors{i})
        removed_vxs(i) = true;
    elseif length(neighbors{i}) == 1;
        pendants(i) = true;
        shortcut_pendant = i;
    end
    
end

while ~all(removed_vxs) % the graph still has some vxs.
    if ~isnan(shortcut_pendant) && pendants(shortcut_pendant)
        v = shortcut_pendant;
    else
        v = find(pendants,1);
    end
    if ~isempty(v)
        u = neighbors{v}; % there is only one
    else
        if phase ==1
            phase = 2;
            core = removed_vxs;
        end
        v = find(~removed_vxs,1);
        u = neighbors{v}(randi(length(neighbors{v}),1));
    end
    
    pair(u) = v; pair(v) = u; % pair these
    
    % display things.
    matching_size = matching_size + 2;
    if mod(matching_size,num_nodes/1000)==0
        dispstat([num2str(100*matching_size/num_nodes),...
            '% of nodes matched']);
    end
    
    
    % chain reaction erase from this edge.
    queue = [u,v];
    %     queue = zeros(1,1000);
    %     q_spot = 2; % last entry
    while ~isempty(queue) % q_spot>0
        % o = queue(q_spot);
        % q_spot = q_spot-1;
        o = queue(end);
        queue = queue(1:end-1);
        removed_vxs(o) = true;
        if pendants(o)
            pendants(o) = false;
        end
        
        for i = 1:length(neighbors{o})
            w = neighbors{o}(i);
            if ~removed_vxs(w)
                neighbors{w}(neighbors{w}==o) = [];
                if isempty(neighbors{w}) % we will put this in removal queue.
                    queue = [queue,w];
                elseif length(neighbors{w}) == 1;
                    pendants(w) = true;
                    shortcut_pendant = w;
                end
            end
        end
    end
end

matching_size = sum(pair<dummy);
dispstat(['greedy algorithm matched ', num2str(100*matching_size/num_nodes),...
    '% of nodes'], 'keepthis');
end

% if degree 1 vx exists, pick one at random, match its edge, remove it
% from graph, remove its neighbor. decrement the neighbor count of the
% neighbor's neighbors by one. if any of these have no neighbors,
% remove them as well.

% otherwise, if a non removed vx with neighbor count greater than one
% exists, remove an edge at random from such a vx at random, remove
% both vxs on this edge, and chain reaction remove vxs with zero
% neighbors remaining




