function path = FINDPATH(high,low,B,find_path_struct)

% finds an alternating path within the ownership tree from high to low

% for testing subfumctions. 
if ischar(high) && strcmp(high, '-getSubHandles')
    path = @get_unvisited_unerased_predecessors_of;
    return
end

% simplest case. 
if high == low
    path = high;
    return
end

% unpacking find_path_struct. 
assert(length(fieldnames(find_path_struct))==9);
graph = find_path_struct.graph;
erased = find_path_struct.erased;
ownership = find_path_struct.ownership;
bloom = find_path_struct.bloom;
base = find_path_struct.base;
% also in here but not used until open are: 
% level
% left_peak
% right_peak
predecessors = find_path_struct.predecessors;

num_edges = graph.num_edges;
num_nodes = graph.num_nodes;

%initialization.
visited_vertices = false(1,num_nodes);
parent = zeros(1,num_nodes);

% when we start out inside a bloom, it will mess with backtracking. So we
% handle this edge case before doing anything. 
if ~isnan(bloom(high)) && bloom(high)~=B
    v_start = base(bloom(high));
    parent(v_start) = high;
else 
    v_start = high;
end

vx = v_start;
history = [];
while vx ~= low
    if vx == 377734
        1;
        my_tree_plot(parent);
    end
     
    history = [history,vx];
    
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
    % mark it as visited. we stop once we get to low
    
    if ~isnan(bloom(vx)) && bloom(vx)~=B 
        % jump to base of bloom if base hasn't been visited and has the
        % correct ownership. we are only interested in the ownership of
        % v_start because if high is in a bloom, we will emerge at that
        % bloom's base regardless of the ownership of high
        b = base(bloom(vx));
        b_star = base_star(bloom(vx),bloom,base);
        if ownership(b_star) == ownership(v_start) && ~visited_vertices(b)
            parent(b) = vx;
            vx = b;
            visited_vertices(b) = true;
        else
            % the search is depth first, so if we've visited b before and
            % not found an augmenting path, we don't need to visit b again.
            % and if the base of b belongs to the other 'left/right' we
            % want no part.
            vx = parent(vx); 
        end
    else
        %get the candidates predecessors. 
        preds = predecessors{vx};
        for u = predecessors{vx}
            % many cases here. we obviously don't want to look at erased
            % vertices or visited vertices (depth first means we've
            % exhausted these). We don't want to look at predecessors with
            % the wrong left/right as well, unless we are in the bloom B
            % and we are jumping to its base, which of course will have a
            % different mark. TODO double check that this is always going
            % to be B, and clean up if possible. TODO make this only a
            % single predecessor. TODO maybe do all of this work at the
            % beginning and put into a cell to avoid repeating it. 
            if erased(u) || visited_vertices(u) || ...
                    (ownership(u)~=ownership(v_start) && ...
                    (~isnan(bloom(vx)) && u~=base(bloom(vx))));
                preds(preds==u) = [];
            end
        end
        if isempty(preds) % backtrack. 
            vx = parent(vx);
        else % travel down
            ux = preds(1);
            parent(ux) = vx;
            vx = ux;
            visited_vertices(vx) = true;
        end
    end
    
end


% create path from high to low via parent pointers. 
vx = low;
path = low;
while vx ~= high
    vx = parent(vx);
    path = [vx, path];
end

path_length = length(path);
new_path = path;

% calls to open for subpaths
% TODO probably a better way to deal with the changing size of the array instead
% of using find
for l = 1: path_length-1 % -1 because free vx is not in bloom
    if ~isnan(bloom(path(l))) && bloom(path(l)) ~= B
        sub_path = OPEN(path(l), find_path_struct);
        insert = find(new_path==path(l));
        new_path = [new_path(1:insert-1),sub_path,new_path(insert+2:end)];

    end
end
path = new_path;

end

function b = base_star(B, bloom, base)
b = base(B);
while ~isnan(bloom(b))
    b = base(bloom(b));
end
end

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

