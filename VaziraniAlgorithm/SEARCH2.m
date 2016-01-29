function [augmentation_occurred,pair] = SEARCH2(graph,pair)

% initialize
% search_level = 0. level(0) candidates go in. other
% search/classify/augerase/create_bloom vars.

num_nodes = graph.num_nodes;

search_level = 0;
even_level = inf(1,num_nodes);
odd_level = inf(1,num_nodes);
predecessors = cell(1,num_nodes);
successors = cell(1,num_nodes);
pred_count = zeros(1,num_nodes);
bridges = cell(1,num_nodes);
anomalies = cell(1,num_nodes);
candidates = cell(1,num_nodes);
augmentation_occurred = false;
erased = false(1,num_nodes);
bloom = nan(1,num_nodes);
bloom_number = 0; % the highest index of the blooms already existing.
base = []; % the base of the existing blooms
left_peak = []; % the left peak of the existing blooms.
right_peak = []; % the right peak of the existing blooms.
ownership = zeros(1,num_nodes); % 1 means left, 2 means right, 0 means unowned.


candidates{index(0)} = find(pair==graph.dummy);
even_level(pair == graph.dummy) = 0;


% continue until augmentation occurs or candidates level i is empty
while ~augmentation_occurred && ~isempty(candidates{index(search_level)})
    cands2search = candidates{index(search_level)};
    if search_level == 5
        1;
    end
    if mod(search_level,2)==0 %search_level is even.
        for v = cands2search
            neighbors = graph.neighbors{v}';
            targets = neighbors;
            for i = 1: length(neighbors)
                if erased(neighbors(i))
                    targets(targets==neighbors(i)) = [];
                end
            end
            targets(targets==pair(v)) = [];
            for u = targets
                if even_level(u) < inf
                    j = (even_level(u) +...
                        even_level(v)) / 2;
                    b = graph.get_e_from_vs(u,v);
                    bridges{index(j)} = [bridges{index(j)},b];
                else                     
                    if odd_level(u) == inf
                        odd_level(u) = search_level+1;
                    end
                    if odd_level(u) == ...
                            search_level+1
                        pred_count(u) = ...
                            pred_count(u) + 1;
                        predecessors{u} = ...
                            [predecessors{u}, v];
                        successors{v} = ...
                            [successors{v}, u];
                        candidates{index(search_level+1)} = ...
                            [candidates{index(search_level+1)},u];
                    end
                    if odd_level(u) < search_level
                        anomalies{u} = [anomalies{u}, v];
                        candidates{index(search_level+1)} = ...
                            [candidates{index(search_level+1)},u];
                    end
                end
            end
        end
    else %search_level is odd.
        for v = cands2search
            if isnan(bloom(v))
                u = pair(v);
                if odd_level(u) < inf
                    j = (odd_level(u) + odd_level(v)) / 2;
                    b = graph.get_e_from_vs(u,v);
                    bridges{index(j)} = [bridges{index(j)},b];
                elseif even_level(u) == inf
                    predecessors{u} = v;
                    successors{v} = u;
                    pred_count(u) = 1;
                    even_level(u) = search_level + 1;
                    candidates{index(search_level+1)} = ...
                        [candidates{index(search_level+1)},u];
                end
            end
        end
    end
    
    bridge_list = unique(bridges{index(search_level)});
    level = min(even_level,odd_level);
    
    for i = 1: length(bridge_list)
        bridge = bridge_list(i);
        
        % pack classify struct.
        
        classify_struct.graph = graph;
        classify_struct.bridge = bridge;
        classify_struct.predecessors = predecessors;
        classify_struct.level = level;
        classify_struct.erased = erased;
        classify_struct.bloom = bloom;
        classify_struct.base = base;
        classify_struct.ownership = ownership;
        % run CLASSIFY
        ddfs_mods = CLASSIFY(classify_struct);
        
        ownership = ddfs_mods.ownership;
        
        
        switch ddfs_mods.bloss_or_aug
            case 'blossom'
                % pack bloom struct
                create_bloom_struct.search_level = search_level;
                create_bloom_struct.bloom_number = bloom_number;
                create_bloom_struct.bloom = bloom;
                create_bloom_struct.graph = graph;
                create_bloom_struct.left_peak = left_peak;
                create_bloom_struct.right_peak = right_peak;
                create_bloom_struct.base = base;
                create_bloom_struct.bottleneck = ddfs_mods.bottleneck;
                create_bloom_struct.init_right = ddfs_mods.init_right;
                create_bloom_struct.init_left = ddfs_mods.init_left;
                create_bloom_struct.ownership = ddfs_mods.ownership;
                create_bloom_struct.marked_vertices = ddfs_mods.marked_vertices;
                create_bloom_struct.even_level = even_level;
                create_bloom_struct.odd_level = odd_level;
                create_bloom_struct.candidates = candidates;
                create_bloom_struct.anomalies = anomalies;
                create_bloom_struct.bridges = bridges;
                
                % run CREATE_BLOOM
                [bloom_number, bloom, base, left_peak, right_peak, ...
                    odd_level, even_level, candidates, bridges] = ...
                    CREATE_BLOOM(create_bloom_struct);
                
                level = min(even_level,odd_level);
                    
            case 'augment'
                
                % pack aug_erase_struct
                aug_erase_struct.graph = graph;
                aug_erase_struct.pair = pair;
                aug_erase_struct.erased = erased;
                aug_erase_struct.pred_count = pred_count;
                aug_erase_struct.successors = successors;
                aug_erase_struct.init_left = ddfs_mods.init_left;
                aug_erase_struct.init_right = ddfs_mods.init_right;
                aug_erase_struct.final_left = ddfs_mods.final_left;
                aug_erase_struct.final_right = ddfs_mods.final_right;
                aug_erase_struct.level = level;
                aug_erase_struct.ownership = ddfs_mods.ownership;
                aug_erase_struct.bloom = bloom;
                aug_erase_struct.base = base;
                aug_erase_struct.left_peak = left_peak;
                aug_erase_struct.right_peak = right_peak;
                aug_erase_struct.predecessors = predecessors;
                
                [erased, pair, pred_count] = ...
                    AUGERASE(aug_erase_struct);
                augmentation_occurred = true;
        end
    end
    
    search_level = search_level + 1;
    candidates{index(search_level)} = ...
        unique(candidates{index(search_level)});
    
end


end
