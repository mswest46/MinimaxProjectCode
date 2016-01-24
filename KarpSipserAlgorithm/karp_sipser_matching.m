function [pair,core] = karp_sipser_matching(adjacency_matrix)

% the karp-sipser algorithm for finding large matchings in a graph G.
% returned is a pair vector representing the matching and core, which is
% the set of unmatched vertices left once the algorithm starts making
% potentially 'incorrect' decisions. 

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
core = false(1,num_nodes);
% shortcut_pendant = nan;
% backup_pendant = nan;

K = 1000;
k = 1;
shortcut_pendants = nan(1,K);

for i = 1:num_nodes
    if isempty(neighbors{i})
        removed_vxs(i) = true;
    elseif length(neighbors{i}) == 1;
        pendants(i) = true;
        if k <= K
            shortcut_pendants(k) = i;
        end
    end
    
end

while ~all(removed_vxs) % the graph still has some vxs.
    no_pendants = false;
    pendant_chosen = false;
    
    for i = 1:K
        if ~isnan(shortcut_pendants(i)) && pendants(shortcut_pendants(i))
            v = shortcut_pendants(i);
            pendant_chosen = true;
            break
        end
    end
    
    if ~pendant_chosen
        % we have no pendants in the shortcut pendants. As in, all the
        % shortcut pendants are not pendants.
        temp = nan(1,K);
        shortcut_pendants = find(pendants,K);
        if isempty(shortcut_pendants)
            no_pendants = true;
        end
        temp(1: length(shortcut_pendants)) = shortcut_pendants;
        shortcut_pendants = temp;
        if ~no_pendants
            v = shortcut_pendants(1);
        end
        
    end
    
    
    %     if ~isnan(shortcut_pendant) && pendants(shortcut_pendant)
    %         v = shortcut_pendant;
    %     elseif ~isnan(backup_pendant) && pendants(backup_pendant)
    %         v = backup_pendant;
    %     else
    %         v = find(pendants,1);
    %     end
    
    if ~no_pendants
        u = neighbors{v}; % there is only one
    else
        if phase == 1
            phase = 2;
            core = ~removed_vxs;
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
                    
                    
                    % this gives runs thru our pendant list until there's
                    % an empty slot, at which point we replace. not sure
                    % what optimal K is.
                    for k = 1:K
                        if isnan(shortcut_pendants(k)) || ...
                                ~pendants(shortcut_pendants(k))
                            if k == K
                                dispstat('full','keepthis')
                            end
                            shortcut_pendants(k) = w;
                            break
                        end
                    end
                    
                    %                     if isnan(shortcut_pendant) || ~pendants(shortcut_pendant)
                    %                         shortcut_pendant = w;
                    %                     elseif isnan(backup_pendant) || ~pendants(backup_pendant)
                    %                         backup_pendant = w;
                    %                     end
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




