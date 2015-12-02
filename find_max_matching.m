function pair = find_max_matching(adjacency_matrix)

num_nodes = length(adjacency_matrix(:,1));
dummy = num_nodes + 1;
pair = dummy*ones(1,num_nodes);

phase = 0;
matching_size = 0;
while true
    erased = zeros(num_nodes,1);
    [max_matching_found, bridges, levels, available_edges,...
        predecessors_count] = SEARCH(adjacency_matrix, pair);
    
    if max_matching_found
        break
    end
    
    level = min(levels.even_level,levels.odd_level);
    for i = 1:length(bridges(1,:))
        bridge = bridges(:,i);
        red_vx = bridge(1);
        green_vx = bridge(2);
        
        if level(red_vx) ~= level(green_vx) 
            1;
        end
        
        if available_edges(green_vx,red_vx)
            available_edges(green_vx, red_vx)= 0;
            predecessors_count(red_vx) = predecessors_count(red_vx) - 1;
            if ~predecessors_count(red_vx)
                erased(red_vx) = 1;
            end
        end
        
         if available_edges(red_vx,green_vx)
            available_edges(red_vx, green_vx)= 0;
            predecessors_count(green_vx) = predecessors_count(green_vx) - 1;
            if ~predecessors_count(green_vx)
                erased(green_vx) = 1;
            end
        end
     
        
        if erased(green_vx) || erased(red_vx)
            continue % skips the rest of this iteration
        end
        if pair(red_vx) == dummy && pair(green_vx) == dummy
            % skip DDFS and just go straight to augmenting
            aug_path = [green_vx, red_vx];
            pair = AUGMENT(pair, aug_path);
            [erased,available_edges, predecessors_count] = ...
                ERASE(erased,aug_path,available_edges,predecessors_count);
            matching_size = matching_size+1;
        else
            [free_red, free_green, parent, bottleneck_node, ownership] = ...
                DDFS2(available_edges,  level, red_vx, green_vx, pair);
            if isempty(bottleneck_node)
                if isempty(free_red) || isempty(free_green)
                    error('yo');
                end
                
                % findpath and augment
                red_path = FINDPATH(parent, red_vx, free_red);
                green_path = FINDPATH(parent, green_vx, free_green);
                aug_path = [red_path,flip(green_path)];
                pair = AUGMENT(pair, aug_path);
                [erased,available_edges, predecessors_count] = ...
                    ERASE(erased,aug_path,available_edges,predecessors_count);
                matching_size = matching_size+1;
            end
        end
        
    end
    phase = phase + 1;
    disp(['phase: ', num2str(phase)]);
end

disp(['matching size is ', num2str(matching_size)]);