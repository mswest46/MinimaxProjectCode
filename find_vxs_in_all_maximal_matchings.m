function vertices_in_all_matchings = find_vxs_in_all_maximal_matchings(...
    adjacency_matrix, pair)

num_nodes = length(adjacency_matrix(:,1));
dummy = num_nodes+1;
vertices_in_all_matchings = pair<dummy;
dummy = num_nodes + 1;
[part1, part2] = bipartition(adjacency_matrix);


checked = zeros(1, num_nodes);
queue = [];

for k = [0,1]
    if k
        part = part1;
    else 
        part = part2;
    end
    
    
    for i = 1:length(part)
        u = part(i);
        if pair(u) == dummy % u is free
            queue = [queue,u];
            
        end
    end
    
    while ~isempty(queue)
        u = queue(end);
        queue = queue(1:end-1);
        neighbors = find(adjacency_matrix(:,u));
        for i = 1:length(neighbors)
            v = neighbors(i);
            if ~checked(pair(v))
                checked(pair(v))=1;
                vertices_in_all_matchings(pair(v)) = 0;
                queue = [queue, pair(v)];
            end
        end
    end
end

disp(['number of vertices in all maximal matchings: ',...
    num2str(sum(vertices_in_all_matchings))]);