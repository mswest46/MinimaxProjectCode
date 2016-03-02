function pair = hopcroft_karp(adjacency_matrix,pair)

[part1, ~] = bipartition(adjacency_matrix); % part1 is a num_nodes length array;. 
num_nodes = length(adjacency_matrix(:,1));
dummy = num_nodes+1;
if ~exist('pair','var')
    pair = dummy*ones(1,num_nodes);
end
% pair is an array which contains the matching information. everything
% initially is free, so we say it is paired with dummy.
matching_size = 0;
dispstat('','init');

G.neighbors = cell(1,num_nodes);
for i = find(part1);
    G.neighbors{i} = find(adjacency_matrix(:,i))';
end
G.A = adjacency_matrix;
G.part1 = part1;
G.part1Inds = find(part1);
G.dummy = dummy;
G.pair = pair;



while true
    % reset layer 
    G.layer = nan(1,num_nodes+1);
    [G, done] = BFS(G);
    % BFS performs a breadth first search on our graph, and assigns layers
    % to the vertices corresponding to distances from free vertices. It
    % returns done==true if we don't have any augmenting paths
    if done
        disp(['number of vertices in the matching: ',...
            num2str(sum(G.pair<dummy))]);
        break
    end
    for u = G.part1Inds;
        if pair(u) == dummy
            % u is free
            [augment, G] = DFS(G, u);
            if augment
                % u is in an augmenting path. increment the matching size
                % by one for display purposes.
                matching_size = matching_size + 2;
                dispstat([num2str(100*matching_size/num_nodes),...
                    '% of nodes matched']);
            end
        end
    end
end

pair = G.pair;

end


function [G,done] = BFS(G)

% only for part1 tho! TODO
free = G.part1 & G.pair == G.dummy;
G.layer(free) = 0;
G.layer(~free) = inf;
G.layer(G.dummy) = inf;
Q = find(free);
while ~isempty(Q)
    u = Q(end);
    Q = Q(1:end -1); % this is LIFO and should be FIFO
    if G.layer(u) < G.layer(G.dummy)
        % because dummy starts at inf, once dummy has changed to something
        % less than inf we know we've found some minimal augmenting paths
        neighbors = G.neighbors{u};
        for v = neighbors
            if G.layer(G.pair(v)) == inf
                % otherwise, we've already labelled this bad boy.
                G.layer(G.pair(v)) = G.layer(u) + 1;
                Q = [Q,G.pair(v)];
            end
        end
    end
    
end
% the breadth first search failed to reach a free vree vertex in part2
% (i.e. failed to hit dummy in part1);
done = (G.layer(G.dummy)==inf);
end

function [bool,G] = DFS(G,u)

if ~(u == G.dummy)
    neighbors = G.neighbors{u};
    for v = neighbors
        if (G.layer(G.pair(v)) == G.layer(u) + 1) % we are moving along augmenting path.
            [bool, G] = DFS(G,G.pair(v));
            if ~bool
                1;
            end
            if bool
                % we have eventually hit an augmenting path and we are
                % augmenting back up the chain of DFS calls.
                G.pair(v) = u;
                G.pair(u) = v;
                return
            end
        end
    end
    % we only get here when there are no aug paths from u to free vx.
    G.layer(u) = inf; % we do this so we don't check it again for other u
    bool = false;
    return
else % we are at dummy vertex so havre found augmenting path.
    bool = true;
end

end

