function ddfs_mods = ...
    CLASSIFY(classify_struct)

assert(length(fieldnames(classify_struct))==7);
graph = classify_struct.graph;
bridge = classify_struct.bridge;
predecessors = classify_struct.predecessors;
level = classify_struct.level;
erased = classify_struct.erased;
bloom = classify_struct.bloom;
base = classify_struct.base;

num_nodes = graph.num_nodes;

% OUTPUTTED:
ddfs_mods.bloss_or_aug = '';
ddfs_mods.ownership = zeros(1,num_nodes);
ddfs_mods.parent = nan(1,num_nodes);
ddfs_mods.bottleneck = nan;
ddfs_mods.final_left = nan;
ddfs_mods.final_right = nan;
ddfs_mods.init_left = nan;
ddfs_mods.init_right = nan;


num_nodes = graph.num_nodes;
num_edges = graph.num_edges;

[init_left, init_right] = graph.get_vs_from_e(bridge);
ownership = zeros(1,num_nodes); % 1 for left, 2 for right.
parent = nan(1,num_nodes); % we start with no knowledge about the trees.
bloom_discovered = false;
used_edges = false(1,num_edges);

if init_left == 206 && init_right == 655 
    1;
end

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
    ownership(bloom==bloom(init_left)) = 1;
else
    left_COA = init_left;
end
if ~isnan(bloom(init_right))
    right_COA = base_star(bloom(init_right), bloom, base);
        ownership(bloom==bloom(init_right)) = 2;
else
    right_COA = init_right;
end

ownership(left_COA) = 1;
ownership(right_COA) = 2;
DCV = nan;
barrier = right_COA;

% DDFS
while ~(level(left_COA) == 0 && level(right_COA) == 0) && ...
        ~bloom_discovered  % we haven't gotten to a bloom or free vxs.
    
    if level(left_COA) >= level(right_COA)
        LEFT_DFS;
    else
        RIGHT_DFS;
    end
end

if bloom_discovered
    ownership(DCV) = 0;
end

if bloom_discovered
    ddfs_mods.bloss_or_aug = 'blossom';
else
    ddfs_mods.bloss_or_aug = 'augment';
end
ddfs_mods.ownership = ownership;
ddfs_mods.parent = parent;
ddfs_mods.bottleneck = DCV;
ddfs_mods.final_left = left_COA;
ddfs_mods.final_right = right_COA;
ddfs_mods.init_left = init_left;
ddfs_mods.init_right = init_right;



    function LEFT_DFS
        edges = get_unused_unerased_predecessors_of(left_COA, predecessors);
        while ~isempty(edges)
            % return statement means we'll actually return when we
            % find an unowned predecessor
            pred = edges(end);
            edges = edges(1:end-1);
            used_edges(graph.get_e_from_vs(left_COA,pred)) = true;
            if ~isnan(bloom(pred))
                ownership(bloom==bloom(pred)) = 1;
                pred = base_star(bloom(pred), bloom, base); % jump to base.
                
                
            end
            if ~ownership(pred)
                ownership(pred) = 1; %left claims
                parent(pred) = left_COA;
                left_COA = pred;
                return
            end
        end
        % we only get here when there are no unowned, unerased
        % predecessors of left_COA via unused edges.
        if left_COA == init_left
            bloom_discovered = true;
        else
            left_COA = parent(left_COA); %backtrack
        end
    end

    function RIGHT_DFS
        edges = get_unused_unerased_predecessors_of(right_COA, predecessors);
        while ~isempty(edges)
            pred = edges(end);
            edges = edges(1:end-1);
            used_edges(graph.get_e_from_vs(right_COA, pred)) = true;
            if ~isnan(bloom(pred))
                pred = base_star(bloom(pred), bloom, base);
                ownership(bloom==bloom(pred)) = 2;
            end
            if ~ownership(pred)
                ownership(pred) = 2;
                parent(pred) = right_COA;
                right_COA = pred;
                return
            else
                if pred == left_COA
                    DCV = pred;
                end
            end
        end
        if right_COA == barrier;
            right_COA = DCV;
            barrier = DCV;
            ownership(right_COA) = 2;
            left_COA = parent(left_COA);
        else
            right_COA = parent(right_COA);
        end
    end

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

