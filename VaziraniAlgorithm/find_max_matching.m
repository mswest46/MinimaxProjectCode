function pair = find_max_matching(adjacency_matrix, pair)

% input the adjacency matrix of graph, output a maximal matching vector on
% that graph.

% initialize

% all information about the underlying graph will be placed in the struct
% graph, which will not be modified.


graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
dummy = graph.dummy;
num_nodes = graph.num_nodes;

if nargin<2
    
    pair = dummy * ones(1, num_nodes); % initially all free
end


while true
    
    
    
    augmentation_occurred = false;
    erased = false(1,num_nodes);
    
    
    % anything modified by search is stuck into the struct search_mods.
    % initialize search_mods.
    
    search_mods.search_level = -1;
    search_mods.even_level = inf(1,num_nodes);
    search_mods.odd_level = inf(1,num_nodes);
    search_mods.predecessors = cell(1,num_nodes);
    search_mods.successors = cell(1,num_nodes);
    search_mods.pred_count = zeros(1,num_nodes);
    search_mods.bridges = cell(1,num_nodes);
    search_mods.anomalies = cell(1,num_nodes);
    search_mods.candidates = cell(1,num_nodes);
    search_mods.initial_flag = true;
    search_mods.max_matching_found = false;
    search_mods.index_fun = @ (search_level) search_level + 1; % because matlab indexing starts with 1.
    
    
    % anything modifid by CREATE_BLOOM is stuck into struct
    % bloom_mods. careful, because CREATE_BLOOM also modifies some
    % search_mods. Namely, even_level, odd_level, bridges, candidates.
    
    bloom = nan(1,num_nodes);
    bloom_ownership = zeros(1,num_nodes);
    bloom_number = 0; % the highest index of the blooms already existing.
    base = []; % the base of the various blooms
    left_peak = [];
    right_peak = [];
    
    
    while ~augmentation_occurred
        
        
        search_struct = v2struct(graph,pair,search_mods,bloom, erased);
        search_mods = SEARCH(search_struct);
        if search_mods.max_matching_found
            return
        end
        level = min(search_mods.even_level, search_mods.odd_level);
        
        for bridge = search_mods.bridges{search_mods.index_fun(search_mods.search_level)}
            if bridge == 891
                1;
            end
            if isempty(bridge)
                error('no bridge')
            end
            
            % anything modified by CLASSIFY is stuck into struct ddfs_mods.
            
            % prep for CLASSIFY
            predecessors = search_mods.predecessors;
            
            % OUTPUTTED: TODO, ownership should mantain over all search.
            % ddfs_mods.bloss_or_aug = '';
            % ddfs_mods.ownership = zeros(1,num_nodes);
            % ddfs_mods.parent = nan(1,num_nodes);
            % ddfs_mods.bottleneck = nan;
            % ddfs_mods.final_left = nan;
            % ddfs_mods.final_right = nan;
            % ddfs_mods.init_left = nan;
            % ddfs_mods.init_right = nan;
            
            % classify bridge as belonging to an augmenting path or to a
            % blossom by running a DDFS
            
            %
            %             graph = classify_struct.graph;
            %             bridge = classify_struct.bridge;
            %             predecessors = classify_struct.predecessors;
            %             level = classify_struct.level;
            %             erased = classify_struct.erased;
            %             bloom = classify_struct.bloom;
            %             base = classify_struct.base;
            %
            classify_struct.graph = graph;
            classify_struct.bridge = bridge;
            classify_struct.predecessors = predecessors;
            classify_struct.level = level;
            classify_struct.erased = erased;
            classify_struct.bloom = bloom;
            classify_struct.base = base;
            
            ddfs_mods = CLASSIFY(classify_struct);
            
            
            
            switch ddfs_mods.bloss_or_aug
                case 'blossom'
                    
                    create_bloom_struct.search_level = search_mods.search_level;
                    create_bloom_struct.bloom_number = bloom_number;
                    create_bloom_struct.bloom = bloom;
                    create_bloom_struct.bloom_ownership = bloom_ownership;
                    create_bloom_struct.graph = graph;
                    create_bloom_struct.left_peak = left_peak;
                    create_bloom_struct.right_peak = right_peak;
                    create_bloom_struct.base = base;
                    create_bloom_struct.bottleneck = ddfs_mods.bottleneck;
                    create_bloom_struct.init_right = ddfs_mods.init_right;
                    create_bloom_struct.init_left = ddfs_mods.init_left;
                    create_bloom_struct.ownership = ddfs_mods.ownership;
                    create_bloom_struct.even_level = search_mods.even_level;
                    create_bloom_struct.odd_level = search_mods.odd_level;
                    
                    create_bloom_struct.candidates = search_mods.candidates;
                    create_bloom_struct.anomalies = search_mods.anomalies;
                    create_bloom_struct.bridges = search_mods.bridges;
                    
                    % this  changes search_mods as well as bloom_mods.
                    [bloom_number, bloom, base, left_peak,right_peak, bloom_ownership, ...
                        search_mods.odd_level, search_mods.even_level, search_mods.candidates, search_mods.bridges] = ...
                        CREATE_BLOOM(create_bloom_struct);
                    level = min(search_mods.even_level,search_mods.odd_level);
                    
                case 'augment'
                    aug_erase_struct.graph = graph;
                    aug_erase_struct.pair = pair;
                    aug_erase_struct.erased = erased;
                    aug_erase_struct.pred_count = search_mods.pred_count;
                    aug_erase_struct.successors = search_mods.successors;
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
                    aug_erase_struct.bloom_ownership = bloom_ownership;
                    aug_erase_struct.predecessors = predecessors;
                    
                    augmentation_occurred = true;
                    [erased, pair, pred_count] = ...
                        AUGERASE(aug_erase_struct);
                    
                    search_mods.pred_count = pred_count;
                    
            end
        end
    end
end
end
