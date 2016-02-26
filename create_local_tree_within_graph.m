function [is_tree,sub_adj_mat,degree_vec]=create_local_tree_within_graph(adjacency_matrix,v,dist)

% finds the distance dist neighborhood of v with G and lets us know if its a
% tree or not. 
num_nodes = size(adjacency_matrix,1);
degree_vec = nan(1,num_nodes);
in_hood = false(1,num_nodes);
parent = zeros(1,num_nodes);
d_vec = zeros(1,num_nodes);
queue = v; % needs to be fifo, so that we do all of the same distance ones first. 
is_tree = true;
while ~isempty(queue) 
    u = queue(end);
    queue = queue(1:end-1);
    if in_hood(u)
        is_tree = false;
        continue
    end
    in_hood(u) = true;
    if d_vec(u)>=dist % this way we don't look at the children of nodes a distance dist away. 
        continue
    end
    children = find(adjacency_matrix(u,:));
    children(children == parent(u)) = [];
    degree_vec(u) = length(children);
    parent(children) = u;
    d_vec(children) = 1+d_vec(u);
    queue = [children,queue]; %fifo i think. 
end

sub_adj_mat = adjacency_matrix(in_hood,in_hood);

end