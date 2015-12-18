function path = FINDPATH(high,low,B,find_path_struct)

count = 0;
badvs = [];
badus = [];
tempv = [];
tempu = [];

if ischar(high) && strcmp(high, '-getSubHandles')
    path = @get_unvisited_unerased_predecessors_of;
    return
end
% finds an alternating path within the ownership tree from high to low


% unpacking
assert(length(fieldnames(find_path_struct))==10);
graph = find_path_struct.graph;
erased = find_path_struct.erased;
level = find_path_struct.level;
ownership = find_path_struct.ownership;
bloom = find_path_struct.bloom;
base = find_path_struct.base;
% left_peak
% right_peak
% bloom_ownership
predecessors = find_path_struct.predecessors;

num_edges = graph.num_edges;
num_nodes = graph.num_nodes;

%initialization.
visited_edges = zeros(1,num_edges);
visited_vertices = false(1,num_nodes);
parent = nan(1,num_nodes);

if high == 7 && low == 5
    1;
end

if high == low
    path = high;
    return
end

vx = high;
ux = nan;

while ux ~= low
    tempv = [tempv,vx];
    tempu = [tempu,ux];
    edges = get_unvisited_unerased_predecessors_of(...
        vx, graph, predecessors, visited_edges, erased); %MUST CHANGE TO EDGES NOT VERTICES VISITED
    while isempty(edges)
        %backtracking in the DFS
        vx = parent(vx);
        if isnan(vx) % shouldn't happen
            error('worng');
        end
        edges = get_unvisited_unerased_predecessors_of(...
            vx, graph, predecessors, visited_edges, erased);
    end
    
    if bloom(vx) == B || isnan(bloom(vx))
        badvs = [badvs,vx];
        badus = [badus,ux];
        count = count+1;
        if count>6
            1;
        end
        ux = edges(end);
        visited_edges(graph.get_e_from_vs(ux,vx)) = true;
    else
        ux = base(bloom(vx));
    end
    
    % if the vertex we've moved to hasn't already been
    % visited, hasn't been erased, is higher than low, and
    % belongs to the same color tree as high, we move to
    % it. once we do, we mark it 'visited'.
    if ~visited_vertices(ux) && ~erased(ux) && ...
            level(ux) >= level(low) && ... 
            ownership(ux) == ownership(high)
        visited_vertices(ux) = true;
        parent(ux) = vx;
        vx = ux;
    end
    
end


% at this point, we have ux = low, with parent pointers all
% the way up to high.


% create path from high to low.

vx = low;
path = low;
while vx ~= high
    vx = parent(vx);
    path = [vx, path];
end

opened = false;
for l = 1: length(path) - 1
    if ~isnan(bloom(path(l))) && bloom(path(l)) ~= B
        sub_path = OPEN(path(l), find_path_struct);
        new_path = [path(1:l-1),sub_path, path(l+2:end)];
        opened = true;
    end
end
if opened
    path = new_path;
end
end



function vxs = get_unvisited_unerased_predecessors_of ...
    (v, graph, predecessors, visited, erased)

vxs = [];
if ~isempty(predecessors{v})
    for u = predecessors{v}
        if ~erased(u) && ~visited(graph.get_e_from_vs(u,v))
            vxs = [vxs, u];
        end
    end
end

end

