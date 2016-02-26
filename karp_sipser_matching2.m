function [pair,core] = karp_sipser_matching2(adjacency_matrix)

% the karp-sipser algorithm for finding large matchings in a graph G.
% returned is a pair vector representing the matching and core, which is
% the set of unmatched vertices left once the algorithm starts making
% potentially 'incorrect' decisions. 

G = create_graph_struct_from_adjacency_matrix(adjacency_matrix);

% graph has been constructed from create_graph_struct.

num_nodes = G.num_nodes;
num_edges = G.num_edges;
dummy = G.dummy;
pair = dummy*ones(1,num_nodes);
removed_vxs = false(1,num_nodes);
pendants = false(1,num_nodes);
neighbors = G.neighbors;
phase = 1;
matching_size = 0;
dispstat('','init');
core = false(1,num_nodes);

% run through all the vertices, check to see which ones are isolated, and
% which ones have single neighbor (are pendant). 
num_pendants = 0;
for i = 1:num_nodes
    if isempty(neighbors{i})
        removed_vxs(i) = true;
    elseif length(neighbors{i}) == 1;
        pendants(i) = true;
        num_pendants = num_pendants + 1;
    end
end

while edges_remain
    if num_pendants>0
        p = pendants(end);
        p_neighbor = neighbors{p};
        edge = [p,p_neighbor]; 
    else 
        
        % select an edge at random. 
        
    end
    
    % remove x and y from the graph, 
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
                    
                end
            end