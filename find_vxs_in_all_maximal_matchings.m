function [vertices_in_all_matchings,persistence] = find_vxs_in_all_maximal_matchings(...
    adjacency_matrix, pair)

% Given a matching and an adjacency matrix, finds the vertices v that are
% not in all maximum matchings and also the distance from a free vertex to
% v for each losing vertex. We explore the graph with a FIFO queue, so that
% whenever we reach a vertex we reach it via the shortest path. We put the
% length of this path in the persistence vector

dispstat('','init');
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);

num_nodes = graph.num_nodes;
dummy = graph.dummy;
% start with assumption that all vertices in this matching are in all
% matchings
vertices_in_all_matchings = pair<dummy;
checked = ~vertices_in_all_matchings; % free vertices are 'checked' already
temp = find(checked); % start with free vertices.
persistence = inf(1,num_nodes);
persistence(temp) = 0;
% at each step we move two steps -- unmatched, matched -- and there is an
% even alternating path from a free vx to terminal vx, so we mark the
% terminal vx as not in all matchings. 


queue = zeros(1,num_nodes);
queue(1:length(temp)) = temp;
r_spot = 1;
w_spot = length(temp)+1;

while r_spot<w_spot
    u = queue(r_spot);
    r_spot = r_spot+1;
    neighbors = graph.neighbors{u};
    for i = 1:length(neighbors)
        v = neighbors(i);
        if pair(v) ~= dummy && ~checked(pair(v)) % we don't double check things. 
            checked(pair(v))=1;
            vertices_in_all_matchings(pair(v)) = false;
            persistence(pair(v)) = persistence(u)+2;
            queue(w_spot) = pair(v);
            w_spot = w_spot+1;
        end
    end
end
    
dispstat(['percent of vertices in all maximal matchings: ',...
    num2str(100*sum(vertices_in_all_matchings)/num_nodes)]);