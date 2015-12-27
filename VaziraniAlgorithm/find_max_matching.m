function pair = find_max_matching(adjacency_matrix, pair)

% input the adjacency matrix of graph, output a maximal matching vector on
% that graph.

% initialize
phase_no = 0; % number of augmentation phases. just for debugging purposes. 
matching_size = 0; % for progress updating.
dispstat('','init'); % for progress updating. 
graph = create_graph_struct_from_adjacency_matrix(adjacency_matrix);
dummy = graph.dummy; 
num_nodes = graph.num_nodes;

if nargin<2
    pair = dummy * ones(1, num_nodes); % initially all free
else
    disp('PAIR INPUTTED');
end

while true
    augmentation_occurred = false;
    erased = false(1,num_nodes);
    
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
    
    
    % initialize bloom information
    bloom = nan(1,num_nodes);
    bloom_number = 0; % the highest index of the blooms already existing.
    base = []; % the base of the existing blooms
    left_peak = []; % the left peak of the existing blooms. 
    right_peak = []; % the right peak of the existing blooms. 
    ownership = zeros(1,num_nodes); % 1 means left, 2 means right, 0 means unowned. 
    phase_no = phase_no + 1;
    
    while ~augmentation_occurred
        
        % pack search_struct
        search_struct.graph = graph;
        search_struct.search_mods = search_mods;
        search_struct.bloom = bloom;
        search_struct.erased = erased;
        search_struct.pair = pair;
        
        % run SEARCH
        search_mods = SEARCH(search_struct);
        
        if search_mods.max_matching_found
            disp('max matching found');
            return
        end
        
        % TODO this should be cleaned up. 
        level = min(search_mods.even_level, search_mods.odd_level);        
        predecessors = search_mods.predecessors;
        
        bridges = search_mods.bridges{index(search_mods.search_level)};
        for bridge_no = 1: length(bridges)
            bridge = bridges (bridge_no);
            
            if isempty(bridge)
                error('no bridge')
            end

            
            % pack classify_struct. 
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
            
            % TODO this should be cleaned up.
            ownership = ddfs_mods.ownership;
            
            switch ddfs_mods.bloss_or_aug
                
                case 'blossom'
                    
                    % pack create_bloom_struct. 
                    create_bloom_struct.search_level = search_mods.search_level;
                    create_bloom_struct.bloom_number = bloom_number;
                    create_bloom_struct.bloom = bloom;
                    create_bloom_struct.graph = graph;
                    create_bloom_struct.left_peak = left_peak;
                    create_bloom_struct.right_peak = right_peak;
                    create_bloom_struct.base = base;
                    create_bloom_struct.bottleneck = ddfs_mods.bottleneck;
                    create_bloom_struct.init_right = ddfs_mods.init_right;
                    create_bloom_struct.init_left = ddfs_mods.init_left;
                    create_bloom_struct.ownership = ownership;
                    create_bloom_struct.marked_vertices = ddfs_mods.marked_vertices;
                    create_bloom_struct.even_level = search_mods.even_level;
                    create_bloom_struct.odd_level = search_mods.odd_level;
                    create_bloom_struct.candidates = search_mods.candidates;
                    create_bloom_struct.anomalies = search_mods.anomalies;
                    create_bloom_struct.bridges = search_mods.bridges;
                    
                    % run CREATE_BLOOM. this changes search_mods as well as 
                    % bloom_mods.
                    [bloom_number, bloom, base, left_peak,right_peak, ...
                        search_mods.odd_level, ...
                        search_mods.even_level, search_mods.candidates, ...
                        search_mods.bridges] = ...
                        CREATE_BLOOM(create_bloom_struct);
                    
                    % TODO clean this up again. 
                    level = min(search_mods.even_level,search_mods.odd_level);
                    
                case 'augment'
                    
                    % pack aug_erase_struct
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
                    aug_erase_struct.predecessors = predecessors;
                    
                    % run AUGERASE
                    [erased, pair, pred_count] = ...
                        AUGERASE(aug_erase_struct);
                    augmentation_occurred = true;
                    
                    % display progress
                    matching_size = matching_size + 2;
                    dispstat([num2str(100*matching_size/num_nodes),...
                        '% of nodes matched']);
                    
                    % TODO clean up. 
                    search_mods.pred_count = pred_count;
            end
        end
    end
end
end
