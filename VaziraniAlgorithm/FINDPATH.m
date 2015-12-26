function path = FINDPATH(high,low,B,find_path_struct)


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



if high == low
    path = high;
    return
end

if ~isnan(bloom(high)) && bloom(high)~=B
    v_start = base(bloom(high));
    parent(v_start) = high;
else 
    v_start = high;
end



vx = v_start;

% while ux ~= low
%     tempv = [tempv,vx];
%     tempu = [tempu,ux];
%     preds = get_unvisited_unerased_predecessors_of(...
%         vx, graph, predecessors, visited_edges, erased);
%     while isempty(preds)
%         %backtracking in the DFS
%         vx = parent(vx);
%         if isnan(vx) % shouldn't happen
%             error('worng');
%         end
%         preds = get_unvisited_unerased_predecessors_of(...
%             vx, graph, predecessors, visited_edges, erased);
%     end
%
%     if bloom(vx) == B || isnan(bloom(vx))
%         badvs = [badvs,vx];
%         badus = [badus,ux];
%         count = count+1;
%         if count>6
%             1;
%         end
%         ux = preds(end);
%         visited_edges(graph.get_e_from_vs(ux,vx)) = true;
%     else
%         ux = base(bloom(vx));
%     end
%
%     % if the vertex we've moved to hasn't already been
%     % visited, hasn't been erased, is higher than low, and
%     % belongs to the same color tree as high, we move to
%     % it. once we do, we mark it 'visited'.
%     if ~visited_vertices(ux) && ~erased(ux) && ...
%             level(ux) >= level(low) && ...
%             ownership(ux) == ownership(high)
%         visited_vertices(ux) = true;
%         parent(ux) = vx;
%         vx = ux;
%     end
% end

while vx ~= low
    
    % suitable predecessors: we only want to travel along a single
    % left/right designation in one call of findpath. in this case, say we
    % are only interested in left. if the current vertex has a 'left'
    % unvisited predecessor, we just head to that one. if the current
    % vertex is in a bloom that is not B, which has a base that is also
    % 'left', we move to it. if it is in a bloom that has a base that is
    % 'right', we want to mark the base as 'visited', but not go to it. if
    % if there are no candidates, we backtrack, else if we are
    % in a suitable bloom we go to the base of the bloom, else if we are in
    % the specified bloom or no bloom at all, we move to one of the
    % unvisited predecessors. in either the base of bloom or the
    % predecessor cases, we mark parents. when we arrive at a new vx we
    % mark it as visited we stop once we get to low?
    
    
    
    if ~isnan(bloom(vx)) && bloom(vx)~=B
        b = base(bloom(vx));
        if ownership(b) == ownership(v_start) && ~visited_vertices(b)
            parent(b) = vx;
            vx = b;
            visited_vertices(b) = true;
        else
            vx = parent(vx); % backtrack here.
        end
    else
        %get the candidates predecessors. 
        preds = predecessors{vx};
        for u = predecessors{vx}
            if erased(u) || visited_vertices(u) || ...
                    (ownership(u)~=ownership(v_start) && ...
                    (~isnan(bloom(vx)) && u~=base(bloom(vx))));
                preds(preds==u) = [];
            end
        end
        if isempty(preds)
            vx = parent(vx);
        else
            ux = preds(1);
            parent(ux) = vx;
            vx = ux;
            visited_vertices(vx) = true;
        end
    end
    
end


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


