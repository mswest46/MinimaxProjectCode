function [ddfs_mods,vertices] = ...
    CLASSIFY(classify_struct,vertices)

% unpack classify_struct.
graph = classify_struct.graph;
bridge = classify_struct.bridge;
predecessors = classify_struct.predecessors;
even_level = classify_struct.even_level;
odd_level = classify_struct.odd_level;
bloom = classify_struct.bloom;
base = classify_struct.base;

num_nodes = graph.num_nodes;
num_edges = graph.num_edges;
level = @ (v) min(even_level(v),odd_level(v));

marked = [];


% initialize part 1
[init_left, init_right] = graph.get_vs_from_e(bridge);
% left_parent = zeros(1,num_nodes);
% right_parent = zeros(1,num_nodes);
bloom_discovered = false;
used_edges = false(1,num_edges);



%
% ancestors = get_ancestors_of([init_left,init_right],predecessors,num_nodes);
% num_ancs = length(ancestors);
% % left_parent = zeros(1,num_ancs);
% % right_parent = zeros(1,num_ancs);
% index_of_ancestors = zeros(1,num_nodes);
% index_of_ancestors(ancestors) = 1:num_ancs;

% in case of early return, pack ddfs_mods. TODO eliminate some of these.
ddfs_mods.bloss_or_aug = '';
% ddfs_mods.left_parent = left_parent;
% ddfs_mods.right_parent = right_parent;
ddfs_mods.graph = graph;
ddfs_mods.bottleneck = nan;
ddfs_mods.final_left = nan;
ddfs_mods.final_right = nan;
ddfs_mods.init_left = init_left;
ddfs_mods.init_right = init_right;
ddfs_mods.marked = [];

% one of the top vxs has been erased
if vertices(init_left).erased || vertices(init_right).erased
    return
end
% we already found this bloom.
if ~isnan(bloom(init_left)) && (bloom(init_left) == bloom(init_right))
    return
end

% one of the top vxs in a bloom already.
if ~isnan(bloom(init_left))
    left_COA = base_star(bloom(init_left), bloom, base);
    check_valid(left_COA);
    vertices(left_COA).left_parent = init_left;
    
%     left_parent(index_of_ancestors(left_COA)) = init_left;
    
else
    left_COA = init_left;
    check_valid(left_COA);
end
if ~isnan(bloom(init_right))
    right_COA = base_star(bloom(init_right), bloom, base);
    check_valid(right_COA);
    vertices(right_COA).right_parent = init_right;
else
    right_COA = init_right;
    check_valid(right_COA);
end

% the base of init_right and init_left blooms is the same.
if right_COA == left_COA
    return
end

% initialize part 2
vertices(left_COA).ownership = 1;
vertices(right_COA).ownership = 2;
marked = [marked,left_COA,right_COA];

DCV = nan;
barrier = right_COA;

% condition for stopping: if we've discovered a bloom or we've reached two
% different free vertices.
stop_when = bloom_discovered || ...
    (level(left_COA)==0 && level(right_COA) == 0 && left_COA~=right_COA);


% run DDFS
while ~stop_when

    1;
    if level(left_COA) >= level(right_COA)
        LEFT_DFS;
    else
        RIGHT_DFS;
    end
    
    % reset the condition
    stop_when = bloom_discovered || ...
        (level(left_COA)==0 && level(right_COA) == 0 && left_COA~=right_COA);
end
if bloom_discovered
    ddfs_mods.bloss_or_aug = 'blossom';
    vertices(DCV).ownership = 0;
    marked(marked==DCV) = [];
else
    ddfs_mods.bloss_or_aug = 'augment';
end


% pack ddfs_mods.
% ddfs_mods.left_parent = left_parent;
% ddfs_mods.right_parent = right_parent;
ddfs_mods.bottleneck = DCV;
ddfs_mods.final_left = left_COA;
ddfs_mods.final_right = right_COA;
ddfs_mods.init_left = init_left;
ddfs_mods.init_right = init_right;
ddfs_mods.marked = unique(marked);


    function LEFT_DFS
        if left_COA == right_COA
            % we should set bottleneckage in motion
            DCV = left_COA;
            check_valid(DCV);
            right_COA = vertices(right_COA).right_parent;
            check_valid(right_COA);
            vertices(left_COA).ownership = 1;
            marked = [marked,left_COA];
        else
            preds = get_unused_unerased_predecessors_of(left_COA,predecessors);
            if isempty(preds)
                if left_COA == init_left
                    bloom_discovered = true;
                else
                    left_COA = vertices(left_COA).left_parent;
%                     left_COA = left_parent(index_of_ancestors(left_COA));
                end
            elseif left_COA==init_left && ~isnan(bloom(init_left));
                bloom_discovered= true;
            else
                u = preds(1);
                edge_for_marking = graph.get_e_from_vs(left_COA, u);
                if ~isnan(bloom(u))
                    u = base_star(bloom(u), bloom, base); % move to base.
                end
                if ~vertices(u).ownership || (u == right_COA && right_COA~=DCV)
                    used_edges(edge_for_marking) = true;
                    vertices(u).ownership = 1; % left claims u
                    marked = [marked,u];
                    vertices(u).left_parent = left_COA;
%                     left_parent(index_of_ancestors(u)) = left_COA;
                    left_COA = u;
                    check_valid(left_COA);
                else %u is owned.
                    used_edges(edge_for_marking) = true;
                end
            end
        end
    end

    function RIGHT_DFS
        
        preds = get_unused_unerased_predecessors_of(right_COA,predecessors);
        if isempty(preds)
            if right_COA == barrier
                % we have backtracked to barrier, return to DCV and update
                barrier = DCV;
                right_COA = DCV; % reclaim DCV
                check_valid(right_COA);
                vertices(right_COA).ownership = 2;
                marked = [marked,right_COA];
                left_COA = vertices(left_COA).left_parent;
                check_valid(left_COA);
%                 left_COA = left_parent(index_of_ancestors(left_COA));
            else
                right_COA = vertices(right_COA).right_parent;
                check_valid(right_COA);
            end
        elseif right_COA==init_right && ~isnan(bloom(init_right)); % edge case
            % we have backtracked to barrier, return to DCV and update
            barrier = DCV;
            right_COA = DCV; % reclaim DCV
            check_valid(right_COA);
            vertices(right_COA).ownership = 2;
            marked = [marked,right_COA];
            left_COA = vertices(left_COA).left_parent;
            check_valid(left_COA);
%             left_COA = left_parent(index_of_ancestors(left_COA));
        else
            u = preds(1);
            edge_for_marking = graph.get_e_from_vs(right_COA, u);
            if ~isnan(bloom(u))
                % TODO time
                u = base_star(bloom(u), bloom, base); % move to base.
                %
            end
            if ~vertices(u).ownership || u == left_COA
                used_edges(edge_for_marking) = true;
                vertices(u).ownership = 2; % left claims u
                marked = [marked,u];
                vertices(u).right_parent = right_COA;
                right_COA = u;
                check_valid(right_COA);
            else % u is owned already
                used_edges(edge_for_marking) = true;
            end
        end
    end

    function preds = get_unused_unerased_predecessors_of(vx, predecessors)
        preds = [];
        for pred = predecessors{vx}
            e = graph.get_e_from_vs(vx,pred);
            if ~used_edges(e) && ~vertices(pred).erased
                preds = [preds,pred];
            end
        end
        
    end
end


% TODO improve this using the algorithm mentioned in thingy.
function b = base_star(B, bloom, base)
b = base(B);
while ~isnan(bloom(b))
    b = base(bloom(b));
end

end

function check_valid(v)

if v==0 || isnan(v)
    1;
end

end



