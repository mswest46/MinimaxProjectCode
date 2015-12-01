function path = FINDPATH(...
    adjacency_matrix, high_vx, low_vx, ownership, height)

num_nodes = length(adjacency_matrix(:,1));
node_visited = zeros(1,num_nodes);
color = ownership(high_vx);
parent = zeros(1,num_nodes);

queue = high_vx;

while ~isempty(queue)
    v = queue(end);
    queue = queue(1:end-1);
    if v == low_vx
        1;
        break
    end
    unused_neighbors = find(adjacency_matrix(v,:) & ~node_visited);
    same_color_children = unused_neighbors(...
        height(unused_neighbors) < height(v) & ...
        ownership(unused_neighbors) == color &...
        height(unused_neighbors) >= height(low_vx));
    parent(same_color_children) = v;
    queue = [queue, same_color_children];
end

path = [];
v = low_vx;
while v ~= high_vx
    path = [path, parent(v)];
    v = parent(v);
end

end