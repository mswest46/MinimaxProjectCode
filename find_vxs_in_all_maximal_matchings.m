function vertices_in_all_matchings = find_vxs_in_all_maximal_matchings(...
    adjacency_matrix, pair)

dispstat('','init');
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);

num_nodes = graph.num_nodes;
dummy = graph.dummy;
% start with assumption that all vertices in this matching are in all
% matchings
vertices_in_all_matchings = pair<dummy;
checked = ~vertices_in_all_matchings; % free vertices are 'checked' already
temp = find(checked); % start with free vertices.

% at each step we move two steps -- unmatched, matched -- and there is an
% even alternating path from a free vx to terminal vx, so we mark the
% terminal vx as not in all matchings. 


queue = zeros(1,num_nodes);
queue(1:length(temp)) = temp;
q_spot = length(temp);

while q_spot>0
    u = queue(q_spot);
    q_spot = q_spot-1;
%     u = queue(end);
%     queue = queue(1:end-1);
    neighbors = graph.neighbors{u};
    for i = 1:length(neighbors)
        v = neighbors(i);
        if pair(v) ~= dummy && ~checked(pair(v)) % we don't double check things. 
            checked(pair(v))=1;
            vertices_in_all_matchings(pair(v)) = false;
            q_spot = q_spot+1;
            queue(q_spot) = pair(v);
%             queue = [queue, pair(v)];
        end
    end
end

if sum(vertices_in_all_matchings) > num_nodes
    error('huh?');
end
    
dispstat(['percent of vertices in all maximal matchings: ',...
    num2str(100*sum(vertices_in_all_matchings)/num_nodes)]);