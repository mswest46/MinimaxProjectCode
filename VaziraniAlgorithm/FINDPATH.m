function path = FINDPATH(high,low,B,find_path_struct)

% finds an alternating path within the ownership tree from high to low

% for testing subfumctions.
if ischar(high) && strcmp(high, '-getSubHandles')
    path = @get_unvisited_unerased_predecessors_of;
    return
end

if high == 311 && low == 611
    1;
end

% simplest case.
if high == low
    path = high;
    return
end

% unpacking find_path_struct.
assert(length(fieldnames(find_path_struct))==9);
graph = find_path_struct.graph;
vertices = find_path_struct.vertices;
bloom = find_path_struct.bloom;
base = find_path_struct.base;
% also in here but not used until open are:
% even_level
% odd_level
% left_peak
% right_peak
predecessors = find_path_struct.predecessors;

num_edges = graph.num_edges;
num_nodes = graph.num_nodes;

%initialization.
visited_vertices = false(1,num_nodes);
% parent = zeros(1,num_nodes);


% when we start out inside a bloom, it will mess with backtracking. So we
% handle this edge case before doing anything. TODO get rid of this?
if ~isnan(bloom(high)) && bloom(high)~=B
    v_start = base(bloom(high));
%     vertices(v_start).findpath_parent = high;
    parent(v_start) = high;
else
    v_start = high;
end

P = vertices(v_start).ownership;

COA = v_start;
history = [];

while COA~=low
    % we only ever move to unvisited vertices. sometimes we end up in the
    % right bloom with wrong parity, but we backtrack. it's ok to end up in
    % wrong bloom with wrong parity, becuase we might end up in right bloom
    % with right parity if we continue on down the base trail.
    
    
    visited_vertices(COA) = true;
    
    if in_same_bloom(COA,B,bloom) && ~has_same_parity(COA,P,vertices)
        % we are within B but have gotten to the wrong parity.
        % backtrack.
%         COA = vertices(COA).findpath_parent;

        COA = parent(COA);
    elseif in_same_bloom(COA,B,bloom) && has_same_parity(COA,P,vertices)
        % we are within B and in the right parity
        preds = get_possible_predecessors(COA,predecessors,vertices,visited_vertices);
        if ~isempty(preds)
            % unvisited, unerased predecessors exist. move along one.
            u = preds(1);
%             vertices(u).findpath_parent = COA;

            parent(u) = COA;
            COA = u;
        else
            % all predecessors have been erased or visited. backtrack.
            COA = parent(COA);
%             COA = vertices(COA).findpath_parent;

        end
    elseif ~in_same_bloom(COA,B,bloom)
        % we have reached a bloom other than B. We move along to the base
        % if it has not already been visited.
        u = base(bloom(COA));
        if ~visited_vertices(u)
%             vertices(u).findpath_parent = COA;

            parent(u) = COA;
            COA = u;
        else
            % backtrack.
%             COA = vertices(COA).findpath_parent;

            COA = parent(COA);
        end
    end
end




% create path from high to low via parent pointers.
vx = low;
path = low;
while vx ~= high
%     vx = vertices(vx).findpath_parent;
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

function preds = get_possible_predecessors(vx,predecessors,vertices,visited)
preds = [];
for i = 1:length(predecessors{vx});
    ux = predecessors{vx}(i);
    if vertices(ux).erased
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

function bool = has_same_parity(ux,P,vertices)
bool = (P ==  vertices(ux).ownership);
end


