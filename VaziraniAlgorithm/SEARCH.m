function [augmentation_occurred,vertices] = SEARCH(graph,vertices)

dispstat('','init');

num_nodes = graph.num_nodes;
dummy = graph.dummy;

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
bloom = nan(1,num_nodes);
bloom_number = 0; % the highest index of the blooms already existing.
base = []; % the base of the existing blooms
left_peak = []; % the left peak of the existing blooms.
right_peak = []; % the right peak of the existing blooms.

f = num2cell(false(1,num_nodes));
[vertices.erased] = f{:};

z = num2cell(zeros(1,num_nodes));
[vertices.pred_count] = z{:};
ownership = num2cell(zeros(1,num_nodes));
[vertices.ownership] = ownership{:};

free = ([vertices.pair]==dummy);
matching_size = num_nodes - sum(free);
candidates{index(0)} = find(free);
even_level(free) = 0;


[vertices.left_parent] = z{:};

[vertices.right_parent] = z{:};


% continue until augmentation occurs or candidates level i is empty
while ~augmentation_occurred && ~isempty(candidates{index(search_level)})
    cands2search = candidates{index(search_level)};
    cand_pos = length(candidates{index(search_level+1)});
    bridge_pos = zeros(1,num_nodes);
    bridges_modified = false(1,num_nodes);
    C = zeros(1,max(100,cand_pos));
    C(1:cand_pos) = candidates{index(search_level+1)};
    if mod(search_level,2)==0 %search_level is even.
        for v = cands2search
            neighbors = graph.neighbors{v}';
            targets = neighbors;
            for i = 1: length(neighbors)
                if vertices(neighbors(i)).erased
                    targets(targets==neighbors(i)) = [];
                end
            end
            targets(targets==vertices(v).pair) = [];
            for u = targets
                if even_level(u) < inf
                    j = (even_level(u) +...
                        even_level(v)) / 2;
                    b = graph.get_e_from_vs(u,v);
                    %                     bridges{index(j)} = [bridges{index(j)},b];
                    l = length(bridges{index(j)});
                    if ~bridges_modified(index(j))
                        z = zeros(1,1000);
                        z(1:l) = bridges{index(j)};
                        bridges{index(j)} = z;
                        bridge_pos(index(j)) = l;
                        bridges_modified(index(j)) = true;
                    elseif bridge_pos(index(j)) == l
                        z = zeros(1,10*l);
                        z(1:l) = bridges{index(j)};
                        bridges{index(j)} = z;
                    end
                    bridge_pos(index(j)) = bridge_pos(index(j))+1;
                    bridges{index(j)}(bridge_pos(index(j))) = b;
                    
                else
                    if odd_level(u) == inf
                        odd_level(u) = search_level+1;
                    end
                    if odd_level(u) == ...
                            search_level+1
                        vertices(u).pred_count = ...
                            vertices(u).pred_count + 1;
                        predecessors{u} = ...
                            [predecessors{u}, v];
                        successors{v} = ...
                            [successors{v}, u];
                        cand_pos = cand_pos+1;
                        if cand_pos > length(C)
                            z = zeros(1,10*length(C));
                            z(1:length(C)) = C;
                            C = z;
                        end
                        C(cand_pos) = u;
                    end
                    if odd_level(u) < search_level
                        anomalies{u} = [anomalies{u}, v];
                        
                        % this could cause bugs.
                        cand_pos = cand_pos+1;
                        if cand_pos > length(C)
                            z = zeros(1,10*length(C));
                            z(1:length(C)) = C;
                            C = z;
                        end
                        C(cand_pos) = u;
                    end
                end
            end
        end
    else %search_level is odd.
        for v = cands2search
            if isnan(bloom(v))
                u = vertices(v).pair;
                if odd_level(u) < inf
                    j = (odd_level(u) + odd_level(v)) / 2;
                    b = graph.get_e_from_vs(u,v);
                    bridges{index(j)} = [bridges{index(j)},b];
                elseif even_level(u) == inf
                    predecessors{u} = v;
                    successors{v} = u;
                    vertices(u).pred_count = 1;
                    even_level(u) = search_level + 1;
                    cand_pos = cand_pos+1;
                    if cand_pos > length(C)
                        z = zeros(1,10*length(C));
                        z(1:length(C)) = C;
                        C = z;
                    end
                    C(cand_pos) = u;
                end
            end
        end
    end
    
    mod_bridge_indices = find(bridges_modified); % note that these are already +1ed
    for i = 1:length(mod_bridge_indices)
        ind = mod_bridge_indices(i);
        bridges{ind} = bridges{ind}(1:bridge_pos(ind));
    end
    candidates{index(search_level+1)} = unique(C(1:cand_pos));
    bridge_list = unique(bridges{index(search_level)});
    
    for i = 1: length(bridge_list)
        bridge = bridge_list(i);
        
        % pack classify struct.
        
        classify_struct.graph = graph;
        classify_struct.bridge = bridge;
        classify_struct.predecessors = predecessors;
        classify_struct.even_level = even_level;
        classify_struct.odd_level = odd_level;
        classify_struct.bloom = bloom;
        classify_struct.base = base;
        % run CLASSIFY
        if bridge ==2508
            1;
        end
        [ddfs_mods,vertices] = CLASSIFY(classify_struct,vertices);
        
        
        
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
                create_bloom_struct.even_level = even_level;
                create_bloom_struct.odd_level = odd_level;
                create_bloom_struct.candidates = candidates;
                create_bloom_struct.anomalies = anomalies;
                create_bloom_struct.bridges = bridges;
                create_bloom_struct.marked = ddfs_mods.marked;
                
                % run CREATE_BLOOM
                [bloom_number, bloom, base, left_peak, right_peak, ...
                    odd_level, even_level, candidates, bridges,vertices] = ...
                    CREATE_BLOOM(create_bloom_struct,vertices);
                
            case 'augment'
                
                % pack aug_erase_struct
                aug_erase_struct.graph = graph;
                aug_erase_struct.successors = successors;
                aug_erase_struct.init_left = ddfs_mods.init_left;
                aug_erase_struct.init_right = ddfs_mods.init_right;
                aug_erase_struct.final_left = ddfs_mods.final_left;
                aug_erase_struct.final_right = ddfs_mods.final_right;
                aug_erase_struct.even_level = even_level;
                aug_erase_struct.odd_level = odd_level;
                aug_erase_struct.bloom = bloom;
                aug_erase_struct.base = base;
                aug_erase_struct.left_peak = left_peak;
                aug_erase_struct.right_peak = right_peak;
                aug_erase_struct.predecessors = predecessors;
                
                
                
                init_left = ddfs_mods.init_left;
                final_left = ddfs_mods.final_left;
                if init_left == 311 && final_left == 611
                    1;
                end
                
                
                
                [vertices,aug_path] = ...
                    AUGERASE(aug_erase_struct,vertices);
                
                
                % augment
                for k = 1: length(aug_path) - 1
                    if mod(k,2) % i is odd
                        vertices(aug_path(k)).pair = aug_path(k+1);
                        vertices(aug_path(k+1)).pair = aug_path(k);
                    end
                end
                
                % erase
                queue = aug_path;
                while ~isempty(queue)

                    o = queue(end);
                    queue = queue(1:end-1);
                    vertices(o).erased = true;
                    for w = successors{o}
                        if ~vertices(w).erased
                            vertices(w).pred_count = vertices(w).pred_count - 1;
                            if vertices(w).pred_count == 0
                                queue = [queue,w];
                            end
                        end
                    end
                end
%                 
%                 pair = [vertices.pair];
%                 check_pair_is_matching(graph.adjacency_matrix,pair);
%                 
                augmentation_occurred = true;
                matching_size = matching_size+2;
                if mod(matching_size,round(num_nodes/100))==0
                    dispstat([num2str(100*matching_size/num_nodes),...
                        '% of nodes matched']);
                end
        end
    end
    
    search_level = search_level + 1;
    candidates{index(search_level)} = ...
        unique(candidates{index(search_level)});
    
end


end




