function  [part1,part2] = bipartition(adjacency_matrix)
num_nodes = length(adjacency_matrix);
partsArray = -1*ones(1,num_nodes);
partsArray(1) = 0;
queue = 1;
count = 1;
while ~isempty(queue) || (count<num_nodes)
    if isempty(queue)
        u = find(partsArray==-1,1);
        queue = u;
        partsArray(u) = 0;
        count = count + 1;
    end
    u = queue(end);
    queue = queue(1:end-1);
    neighbors = find(adjacency_matrix(:,u));
    for i = 1:length(neighbors);
        v = neighbors(i);
        if partsArray(v) < 0
            partsArray(v) = 1 - partsArray(u);
            count = count+1;
            queue = [queue, v];
        elseif partsArray(v) == partsArray(u)
            error('this graph is not bipartite');
        end
    end
end

1;

part1=(partsArray==0);
part2=(partsArray==1);
assert(all(part1|part2));
end
