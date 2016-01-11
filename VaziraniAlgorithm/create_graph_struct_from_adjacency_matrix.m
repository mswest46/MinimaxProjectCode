function graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix)

assert(issymmetric(adjacency_matrix));
graph.adjacency_matrix = adjacency_matrix;
num_nodes = length(adjacency_matrix(:,1));
graph.num_nodes = num_nodes;
% linear indices of the edges in our adjacency matrix. we will refer to an
% edge by its placement in this vector. for example, edge 3 will have
% linear index edge_indices(3) in adjacency_matrix.
new_adj_mat = triu(adjacency_matrix,1);
graph.edge_indices = find(new_adj_mat);
graph.num_edges = length(graph.edge_indices);
graph.dummy = num_nodes + 1;
neighbors = cell(1,num_nodes); % a cell containing the neighbors of each vx
for i = 1: num_nodes
    neighbors{i} = find(adjacency_matrix(:,i));
    neighbors{i}(neighbors{i}==i) = [];
end
nodes = cell(1,num_nodes);
for i = 1: num_nodes
    nodes{i} = struct('index',i,'right_parent',nan,'asdf',nan,...
        'ownership',0);
end
graph.nodes = nodes;
graph.neighbors = neighbors;
graph.get_vs_from_e = @ get_vertices_from_edge;
graph.get_e_from_vs = @ get_edge_from_vertices;

[row_subs, col_subs] = ind2sub([num_nodes,num_nodes],graph.edge_indices);
edge_look_up = sparse(row_subs,col_subs,1:graph.num_edges,num_nodes,num_nodes);

[v1,v2] = ind2sub([num_nodes,num_nodes],graph.edge_indices);
edge_index_to_vertex_indices = [v1,v2]';

% these functions are taking the most time. maybe can do this from memory
% instead.

    function [v1, v2] = get_vertices_from_edge(edge_no)
        vx_indices = edge_index_to_vertex_indices(:,edge_no);
        v1 = vx_indices(1);
        v2 = vx_indices(2);
%         [v1,v2] = ind2sub([num_nodes,num_nodes], graph.edge_indices(edge_no));
    end


% function edge_num = get_edge_from_vertices(v1,v2)
% if v1<v2
%     edge_num = find(graph.edge_indices==sub2ind(size(graph.adjacency_matrix), v1, v2));
% else % v2 < v1
%     edge_num = find(graph.edge_indices==sub2ind(size(graph.adjacency_matrix), v2, v1));
% end
% end
    function edge_num = get_edge_from_vertices(v1,v2)
        if v2<v1 % make sure the first index is smaller than the second.
            temp = v2;
            v2 = v1;
            v1 = temp;
        end
     
        edge_num = edge_look_up(v1,v2);
    end




end
