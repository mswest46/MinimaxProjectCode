function aug_path = check_for_aug_path(adjacency_matrix, pair)
% brute force for testing purposes.


graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
num_nodes = graph.num_nodes;
num_edges = graph.num_edges;
dummy = graph.dummy;

aug_path = false;

free = pair==dummy;
free_vxs = find(free);
for init_v = free_vxs;
    used_edges = false(1,num_edges);
    parent = zeros(1,num_nodes);
    path = init_v;
    v = init_v;
    while ~free(v) || v == init_v
        if v == 33
            1;
        end
        option = get_forward_opts(v, graph, pair, path, used_edges);
        if isempty(option)
            if v == init_v
                break
            else
                v = parent(v);
                path(end) = [];
            end
        else % forwards possibilities
            
            parent(option) = v;
            used_edges(graph.get_e_from_vs(option,v)) = 1;
            path = [path,option];
            v = option;
            % remove edge
        end
    end
    
    if free(v) && v~=init_v
        aug_path = true;
        break
    end
end
end


function option = get_forward_opts(v, graph, pair, path,used_edges)
option = [];
if pair(v) == graph.dummy || pair(v) == path(end-1)
    % arrived via matched edge
    temp_opts = graph.neighbors{v};
    temp_opts(temp_opts == pair(v)) = [];
    for i = 1: length(temp_opts)
        u = temp_opts(i);
        if ~used_edges(graph.get_e_from_vs(u,v)) && ...
                all(path~=u)
            option = u;
            break
        end
    end
        
else
    if ~used_edges(graph.get_e_from_vs(v,pair(v))) && ...
            all(path~=pair(v))
        option = pair(v);
    end
end
end


% if we arrive at a node via matched edge, we have that all the unmatched,
% unused edges leading to veritces not in the path are forward
% possibilities. if instead we arrived via an unmatched edge, the only
% forward possibility is the matched edge, if the terminal vertex is not in
% the path, and if the edge has not already been searched.