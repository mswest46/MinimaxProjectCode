function ddfs_mods = ...
    CLASSIFY(classify_struct)

assert(length(fieldnames(classify_struct))==8);
graph = classify_struct.graph;
bridge = classify_struct.bridge;
predecessors = classify_struct.predecessors;
level = classify_struct.level;
erased = classify_struct.erased;
bloom = classify_struct.bloom;
base = classify_struct.base;
ownership = classify_struct.ownership;
input_ownership = ownership;


num_nodes = graph.num_nodes;
num_edges = graph.num_edges;

[init_left, init_right] = graph.get_vs_from_e(bridge);
left_parent = nan(1,num_nodes); % we start with no knowledge about the trees.
right_parent = nan(1,num_nodes);
marked_vertices = false(1,num_nodes);
bloom_discovered = false;
used_edges = false(1,num_edges);



% OUTPUTTED in case of early return
ddfs_mods.bloss_or_aug = '';
ddfs_mods.marked_vertices = false(1,num_nodes);
ddfs_mods.ownership = ownership;
ddfs_mods.left_parent = left_parent;
ddfs_mods.right_parent = right_parent;
ddfs_mods.bottleneck = nan;
ddfs_mods.final_left = nan;
ddfs_mods.final_right = nan;
ddfs_mods.init_left = init_left;
ddfs_mods.init_right = init_right;



% one of the top vxs has been erased
if erased(init_left) || erased(init_right)
    return
end
% we already found this bloom.
if ~isnan(bloom(init_left)) && (bloom(init_left) == bloom(init_right))
    return
end

% one of the top vxs in a bloom already.
if ~isnan(bloom(init_left))
    left_COA = base_star(bloom(init_left), bloom, base);
    left_parent(left_COA) = init_left;
else
    left_COA = init_left;
end
if ~isnan(bloom(init_right))
    right_COA = base_star(bloom(init_right), bloom, base);
    right_parent(right_COA) = init_right;
else
    right_COA = init_right;
end

% the base of init_right and init_left blooms is the same. 
if right_COA == left_COA 
    return
end

ownership(left_COA) = 1;
ownership(right_COA) = 2;
DCV = nan;
barrier = right_COA;
% DDFS

stop_when = bloom_discovered || ...
    (level(left_COA)==0 && level(right_COA) == 0 && left_COA~=right_COA);
    
if init_left ==4 && init_right == 8
    1;
end

while ~ stop_when  % we haven't gotten to a bloom or free vxs.
    
    if level(left_COA) >= level(right_COA)
        LEFT_DFS;
    else
        RIGHT_DFS;
    end

stop_when = bloom_discovered || ...
    (level(left_COA)==0 && level(right_COA) == 0 && left_COA~=right_COA);
end

if bloom_discovered
    ownership(DCV) = 0;
end

if bloom_discovered
    ddfs_mods.bloss_or_aug = 'blossom';
else
    ddfs_mods.bloss_or_aug = 'augment';
end

marked_vertices = (ownership > 0 & input_ownership == 0); % new markings
if any(~isnan(bloom) & marked_vertices)
    error('hey')
end

ddfs_mods.ownership = ownership;
ddfs_mods.marked_vertices = marked_vertices;
ddfs_mods.left_parent = left_parent;
ddfs_mods.right_parent = right_parent;
ddfs_mods.bottleneck = DCV;
ddfs_mods.final_left = left_COA;
ddfs_mods.final_right = right_COA;
ddfs_mods.init_left = init_left;
ddfs_mods.init_right = init_right;


    function LEFT_DFS
        if left_COA == right_COA
            % we should set bottleneckage in motion
            DCV = left_COA;
            right_COA = right_parent(right_COA);
            ownership(left_COA) = 1;
        else
            preds = get_unused_unerased_predecessors_of(left_COA,predecessors);
            if isempty(preds) 
                if left_COA == init_left
                    bloom_discovered = true;
                else
                    left_COA = left_parent(left_COA); % backtrack
                end
            elseif left_COA==init_left && ~isnan(bloom(init_left));
                bloom_discovered= true;
            else
                u = preds(1);
                edge_for_marking = graph.get_e_from_vs(left_COA, u);
                if ~isnan(bloom(u))
                    u = base_star(bloom(u), bloom, base); % move to base.
                end
                if ~ownership(u) || (u == right_COA && right_COA~=DCV)
                    used_edges(edge_for_marking) = true;
                    ownership(u) = 1; % left claims u
                    left_parent(u) = left_COA;
                    left_COA = u;
                else %u is owned.
                    used_edges(edge_for_marking) = true;
                end
            end
        end
    end


%     function LEFT_DFS
%         edges = get_unused_unerased_predecessors_of(left_COA, predecessors);
%         while ~isempty(edges)
%             % return statement means we'll actually return when we
%             % find an unowned predecessor
%             pred = edges(end);
%             edges = edges(1:end-1);
%             used_edges(graph.get_e_from_vs(left_COA,pred)) = true;
%             if ~isnan(bloom(pred))
%
%                 pred = base_star(bloom(pred), bloom, base); % jump to base.
%
%
%             end
%             if ~ownership(pred)
%                 ownership(pred) = 1; %left claims
%                 parent(pred) = left_COA;
%                 left_COA = pred;
%                 return
%             elseif pred==right_COA
%                 DCV = pred;
%             end
%         end
%         % we only get here when there are no unowned, unerased
%         % predecessors of left_COA via unused edges.
%         if left_COA == init_left
%             bloom_discovered = true;
%         else
%             left_COA = parent(left_COA); %backtrack
%         end
%     end

    function RIGHT_DFS
        preds = get_unused_unerased_predecessors_of(right_COA,predecessors);
        if isempty(preds)
            if right_COA == barrier
                % we have backtracked to barrier, return to DCV and update
                barrier = DCV;
                right_COA = DCV; % reclaim DCV
                ownership(right_COA) = 2;
                left_COA = left_parent(left_COA);
            else
                right_COA = right_parent(right_COA);
            end
        elseif right_COA==init_right && ~isnan(bloom(init_right)); % edge case
            % we have backtracked to barrier, return to DCV and update
                barrier = DCV;
                right_COA = DCV; % reclaim DCV
                ownership(right_COA) = 2;
                left_COA = left_parent(left_COA);
            
        else
            u = preds(1);
            edge_for_marking = graph.get_e_from_vs(right_COA, u);
            if ~isnan(bloom(u))
                u = base_star(bloom(u), bloom, base); % move to base.
            end
            if ~ownership(u) || u == left_COA
                used_edges(edge_for_marking) = true;
                ownership(u) = 2; % left claims u
                right_parent(u) = right_COA;
                right_COA = u;
            else % u is owned already
                used_edges(edge_for_marking) = true;
            end
            
            
            
        end
    end

%
% u = find(adjacency_matrix(:,green_position),1);
%         if isempty(u)
%             if green_position == barrier
%                 % green returns to DCV and takes ownership, red does its
%                 % backtrack thang, and barrier moves to DCV
%                 barrier = DCV;
%                 green_position = DCV;
%                 ownership(green_position) = 2;
%                 red_position = parent(red_position);
%             else % BACKTRACK
%                 green_position = parent(green_position);
%             end
%
%     function RIGHT_DFS
%         edges = get_unused_unerased_predecessors_of(right_COA, predecessors);
%         while ~isempty(edges)
%             pred = edges(end);
%             edges = edges(1:end-1);
%             used_edges(graph.get_e_from_vs(right_COA, pred)) = true;
%             if ~isnan(bloom(pred))
%                 pred = base_star(bloom(pred), bloom, base);
%             end
%             if ~ownership(pred)
%                 ownership(pred) = 2;
%                 parent(pred) = right_COA;
%                 right_COA = pred;
%                 return
%             else
%                 if pred == left_COA
%                     DCV = pred;
%                 end
%             end
%         end
%         if right_COA == barrier;
%             right_COA = DCV;
%             barrier = DCV;
%             ownership(right_COA) = 2;
%             left_COA = parent(left_COA);
%         else
%             right_COA = parent(right_COA);
%         end
%     end

    function edges = get_unused_unerased_predecessors_of(vx, predecessors)
        edges = [];
        for pred = predecessors{vx}
            e = graph.get_e_from_vs(vx,pred);
            if ~used_edges(e) && ~erased(pred)
                edges = [edges,pred];
            end
        end
        
    end
end

function b = base_star(B, bloom, base)
b = base(B);
while ~isnan(bloom(b))
    b = base(bloom(b));
end
end

