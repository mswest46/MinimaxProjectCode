function pair = greedy_algorithm(graph)

% graph has been constructed from create_graph_struct.

num_nodes = graph.num_nodes;
dummy = graph.dummy;
pair = dummy*ones(1,num_nodes);
matched = false(1,num_nodes);
degree1_vxs = find(sum(graph.adjacency_matrix) == 1);

% phase 1: only go after nodes of degree 1
for i = 1: length(degree1_vxs)
    u = degree1_vxs(i);
    if ~matched(u)
        for v = graph.neighbors{u}'
            if ~matched(v)
                matched(v) = true;
                matched(u) = true;
                pair(u) = v;
                pair(v) = u;
                break
            end
        end
    end
end
% phase 2: go after general nodes.
for i = 1: num_nodes
    if ~matched(i)
        for v = graph.neighbors{i}'
            if ~matched(v)
                matched(v) = true;
                matched(i) = true;
                pair(i) = v;
                pair(v) = i;
                break
            end
        end
    end
end



