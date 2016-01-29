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
assert(length(fieldnames(find_path_struct))==10);
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
% handle this edge case before doing anything. TODO get rid of this?
if ~isnan(bloom(high)) && bloom(high)~=B
    v_start = base(bloom(high));
    parent(v_start) = high;
else
    v_start = high;
end

P = ownership(v_start);

COA = v_start;
history = [];

while COA~=low
    % we only ever move to unvisited vertices. sometimes we end up in the
    % right bloom with wrong parity, but we backtrack. it's ok to end up in
    % wrong bloom with wrong parity, becuase we might end up in right bloom
    % with right parity if we continue on down the base trail.
    
    
    visited_vertices(COA) = true;
    
    if in_same_bloom(COA,B,bloom) && ~has_same_parity(COA,P,ownership)
        % we are within B but have gotten to the wrong parity.
        % backtrack.
        COA = parent(COA);
    elseif in_same_bloom(COA,B,bloom) && has_same_parity(COA,P,ownership)
        % we are within B and in the right parity
        preds = get_possible_predecessors(COA,predecessors,erased,visited_vertices);
        if ~isempty(preds)
            % unvisited, unerased predecessors exist. move along one.
            u = preds(1);
            parent(u) = COA;
            COA = u;
        else
            % all predecessors have been erased or visited. backtrack.
            COA = parent(COA);
        end
    elseif ~in_same_bloom(COA,B,bloom)
        % we have reached a bloom other than B. We move along to the base
        % if it has not already been visited.
        u = base(bloom(COA));
        if ~visited_vertices(u)
            parent(u) = COA;
            COA = u;
        else
            % backtrack.
            COA = parent(COA);
        end
    end
end


% mark COA visited so we don't have to check it again.

% if COA is in bloom B with wrong parity, back track to parent. (we
% will have gotten here either via moving to base of bloom or via
% moving to predecessor with wrong parity).

% if COA is in bloom B with right parity, get possible predecessors. If possible
% predecessors not empty, move to one of them. If not, back up to parent
% of COA.

% if COA is in a different bloom from B, move to the base of that
% bloom if the base is unvisited, and otherwise backtrack.

%     while isempty(preds)
%         preds = get_possible_predecessors(vx);
%         vx = parent(vx);
%     end
%     for i = 1:length(preds)
%         u = preds(i);
%         if ~in_same_bloom(u,B);
%             [final, base_trail] = trace_bases(u,B);
%             if final==low || has_same_parity(final,P,ownership)
%                 parents = insert_base_trail_into_parents(u,base_trail,parents);
%             end
%
%         elseif in_same_bloom(u,B,bloom) && has_same_parity(u,P,ownership);
%             % we are travelling within B along the correct parity
%             parent(u) = vx;
%             vx = u;
%             break;
%
%         end
%         visited(u) = true;
%     end
% end

% while vx ~= low
%     if vx == 377734
%         1;
%         my_tree_plot(parent);
%     end
%
%     history = [history,vx];
%
%     % suitable predecessors: we only want to travel along a single
%     % left/right designation in one call of findpath. in this case, say we
%     % are only interested in left. if the current vertex has a 'left'
%     % unvisited predecessor, we just head to that one. if the current
%     % vertex is in a bloom that is not B, which has a base that is also
%     % 'left', we move to it. if it is in a bloom that has a base that is
%     % 'right', we want to mark the base as 'visited', but not go to it. if
%     % if there are no candidates, we backtrack, else if we are
%     % in a suitable bloom we go to the base of the bloom, else if we are in
%     % the specified bloom or no bloom at all, we move to one of the
%     % unvisited predecessors. in either the base of bloom or the
%     % predecessor cases, we mark parents. when we arrive at a new vx we
%     % mark it as visited. we stop once we get to low
%
%     if ~isnan(bloom(vx)) && bloom(vx)~=B
%         % jump to base of bloom if base hasn't been visited and has the
%         % correct ownership. we are only interested in the ownership of
%         % v_start because if high is in a bloom, we will emerge at that
%         % bloom's base regardless of the ownership of high
%         b = base(bloom(vx));
%         b_star = base_star(bloom(vx),bloom,base);
%         if ownership(b_star) == ownership(v_start) && ~visited_vertices(b)
%             parent(b) = vx;
%             vx = b;
%             visited_vertices(b) = true;
%         else
%             % the search is depth first, so if we've visited b before and
%             % not found an augmenting path, we don't need to visit b again.
%             % and if the base of b belongs to the other 'left/right' we
%             % want no part.
%             vx = parent(vx);
%         end
%     else
%         %get the candidates predecessors.
%         preds = predecessors{vx};
%         for u = predecessors{vx}
%             % many cases here. we obviously don't want to look at erased
%             % vertices or visited vertices (depth first means we've
%             % exhausted these). We don't want to look at predecessors with
%             % the wrong left/right as well, unless we are in the bloom B
%             % and we are jumping to its base, which of course will have a
%             % different mark. TODO double check that this is always going
%             % to be B, and clean up if possible. TODO make this only a
%             % single predecessor. TODO maybe do all of this work at the
%             % beginning and put into a cell to avoid repeating it.
%             if erased(u) || visited_vertices(u) || ...
%                     (ownership(u)~=ownership(v_start) && ...
%                     (~isnan(bloom(vx)) && u~=base(bloom(vx))));
%                 preds(preds==u) = [];
%             end
%         end
%         if isempty(preds) % backtrack.
%             vx = parent(vx);
%         else % travel down
%             ux = preds(1);
%             parent(ux) = vx;
%             vx = ux;
%             visited_vertices(vx) = true;
%         end
%     end
%
% end
%

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

function preds = get_possible_predecessors(vx,predecessors,erased,visited)
preds = [];
for i = 1:length(predecessors{vx});
    ux = predecessors{vx}(i);
    if erased(ux)
        continue
    elseif visited(ux)
        continue
    end
    preds = [preds,ux];
end
end

function [final,base_trail] = trace_bases(start,B,bloom,low)
% moves along bases of blooms until we return to base B or to low vx.
vx = start;
base_trail = [];
while ~(bloom(vx) == B || vx == low)
    base_trail = [base_trail,vx];
    vx = base(bloom(vx));
end

final = vx;
end

function bool = in_same_bloom(ux,B,bloom)
bool = (isnan(bloom(ux)) && isnan(B)) || ...
    (~isnan(bloom(ux)) && ~isnan(B) && bloom(ux) == B);
end

function bool = has_same_parity(ux,P,ownership)
bool = (P ==  ownership(ux));
end


