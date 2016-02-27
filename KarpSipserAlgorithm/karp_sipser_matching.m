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

K = 1000;
k = 1;
j = 0;
shortcut_pendants = nan(1,K);
shortcut_core = nan(1,K);
num_pendants = 0;
num_vxs_remaining = num_nodes;

% run through all the vertices, check to see which ones are isolated, and
% which ones have single neighbor (are pendant).
for i = 1:num_nodes
    if isempty(neighbors{i})
        removed_vxs(i) = true;
        num_vxs_remaining = num_vxs_remaining-1;
    elseif length(neighbors{i}) == 1;
        no_pendants = false;
        num_pendants = num_pendants + 1;
        pendants(i) = true;
        if k <= K
            shortcut_pendants(k) = i;
            k = k+1;
        end
    else % is is not pendant or isolated. 
        if j <= K
            j = j+1;
            shortcut_core(j) = i;
        end
        
    end
    
    s_short_core = j;
    
end

while num_vxs_remaining>0 % the graph still has some vxs.
    
    
    if num_pendants > 0
        pendant_chosen = false;
        % select an element from shortcut_pendants that is still a pendant.
        for i = 1:K
            if ~isnan(shortcut_pendants(i)) && pendants(shortcut_pendants(i))
                v = shortcut_pendants(i);
                pendant_chosen = true;
                break
            end
        end
        if ~pendant_chosen
            % we have no pendants in the shortcut pendants. Everything in
            % shortcuts has been removed. leave space for new shortcut
            % pendants. 
            temp = nan(1,K);
            shortcut_pendants = find(pendants,min(num_pendants,K));
            temp(1: length(shortcut_pendants)) = shortcut_pendants;
            shortcut_pendants = temp;
            v = shortcut_pendants(1);
        end
        u = neighbors{v};
    else
        if phase == 1
            phase = 2;
            core = ~removed_vxs;
        end
        while s_short_core>0 && removed_vxs(shortcut_core(s_short_core)) 
            s_short_core = s_short_core - 1; 
        end
        
        if s_short_core == 0 % we have no vertices in the shortcut list, refill
            shortcut_core = find(~removed_vxs,K);
            s_short_core = length(shortcut_core);
            temp = nan(1,K);
            temp(1:s_short_core) = shortcut_core;
            shortcut_core = temp;
        end
           
        v = shortcut_core(s_short_core);
        s_short_core = s_short_core - 1;
        u = neighbors{v}(1);
    end
    
    pair(u) = v; pair(v) = u; % pair these
    
    % display things.
    matching_size = matching_size + 2;
        dispstat([num2str(round(100*matching_size/num_nodes)),...
            '% of nodes matched']);
    
    % chain reaction erase from this edge.
    queue = [u,v];
    %     queue = zeros(1,1000);
    %     q_spot = 2; % last entry
    while ~isempty(queue) 
        % pop o off the queue, remove and de-pendant it. 
        o = queue(end);
        queue = queue(1:end-1);
        removed_vxs(o) = true;
        num_vxs_remaining = num_vxs_remaining - 1;
        if pendants(o)
            pendants(o) = false;
            num_pendants = num_pendants - 1;
        end
        
        % remove o from its neighbors' neighbors lists. 
        for i = 1:length(neighbors{o})
            w = neighbors{o}(i);
            neighbors{w}(neighbors{w}==o) = [];
            if isempty(neighbors{w}) % we will put this in removal queue.
                queue = [queue,w];
            elseif length(neighbors{w}) == 1; % put in pendants list.
                pendants(w) = true;
                num_pendants = num_pendants+1;
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
                
            end
            
        end
    end
end

matching_size = sum(pair<dummy);
dispstat(['KS algorithm matched ', num2str(100*matching_size/num_nodes),...
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




