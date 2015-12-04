function pair = find_max_matching(adjacency_matrix, xy)


close all;

switch nargin
    case 1
        plot_switch = 0;
    case 2
        plot_switch = 1;
end

dispstat('','init');

if plot_switch
    dispstat('plot of unmatched graph');
    gplot(adjacency_matrix,xy,'b*-');
    axis([min(xy(:,1))-.25, max(xy(:,1))+.25, min(xy(:,2))-.25, max(xy(:,2))+.25]);
    hold on;
    pause;
end


num_nodes = length(adjacency_matrix(:,1));
dummy = num_nodes + 1;
pair = dummy*ones(1,num_nodes); 
% the matching information. paired with dummy means free. 

phase = 0;
matching_size = 0;
while true
    phase = phase + 1;
    disp(['phase: ', num2str(phase)]);
    erased = false(num_nodes,1); % reset the erased nodes
    
    % determines whether the current matching is maximal, assigns levels
    % to the nodes, finds bridges, determines predecessors, creates the
    % directed graph predecessors.
    [max_matching_found, bridges, levels, predecessors,...
        predecessors_count] = SEARCH(adjacency_matrix, pair);
    
%     if plot_switch
%         dispstat('plot of available_edges');
%         gplot(available_edges,xy,'r-');
%         pause
%         matching_matrix = zeros(num_nodes);
%         col_subs = [];
%         row_subs = [];
%         for i = 1: num_nodes
%             if pair(i) < dummy
%                 col_subs = [col_subs,i];
%                 row_subs = [row_subs,pair(i)];
%             end
%         end
%         matching_matrix(sub2ind(size(matching_matrix),row_subs,col_subs)) = 1;
%         if ~issymmetric(matching_matrix)
%             disp('you done fucked up')
%         end
%         
%         dispstat('plot of matching');
%         gplot(matching_matrix,xy,'y-');
%         
%         pause;
%         1;
%     end
    
    
    if max_matching_found
        break
    end
    
    level = min(levels.even_level,levels.odd_level);
    for i = 1:length(bridges(1,:))
        
        if plot_switch
            x = xy(:,1);
            y = xy(:,2);
            erased_x = x(erased);
            erased_y = y(erased);
            plot(erased_x, erased_y, 'y*')
            pause;
        end
        
        
        bridge = bridges(:,i);
        red_vx = bridge(1);
        green_vx = bridge(2);
        
        %         if level(red_vx) ~= level(green_vx)
        %             1;
        %         end
        %
        %         if available_edges(green_vx,red_vx)
        %             available_edges(green_vx, red_vx)= 0;
        %             predecessors_count(red_vx) = predecessors_count(red_vx) - 1;
        %             if ~predecessors_count(red_vx)
        %                 erased(red_vx) = 1;
        %             end
        %         end
        %
        %          if available_edges(red_vx,green_vx)
        %             available_edges(red_vx, green_vx)= 0;
        %             predecessors_count(green_vx) = predecessors_count(green_vx) - 1;
        %             if ~predecessors_count(green_vx)
        %                 erased(green_vx) = 1;
        %             end
        %         end
        %
        
        if erased(green_vx) || erased(red_vx)
            continue % skips the rest of this iteration
        end
        
        if pair(red_vx) == dummy && pair(green_vx) == dummy
            % skip DDFS and just go straight to augmenting
            aug_path = [green_vx, red_vx];
            pair = AUGMENT(pair, aug_path);
            [erased, predecessors_count] = ...
                ERASE(erased,aug_path,predecessors,predecessors_count);
            matching_size = matching_size+1;
        else
            
            
            
            % pre-processing for DDFS: firstly, we want to rule out edge
            % cases: 
            % (1) bridge vx is erased: we just ignore this bridge and move
            % on to the next one. 
            %   _ _
            %  | |\|
            %
            
            
            % (2) bridge vxs are both free. DDFS should discover this.
            % (3) bridge vx v has no predecessor other than the other
            % bridge vx u. Currently, DDFS is 
            
            input_matrix = predecessors;
            % remove the bridge in question
            input_matrix(red_vx, green_vx) = 0;
            input_matrix(green_vx, red_vx) = 0;
            % remove edges to and from erased vxs. 
            input_matrix(:,erased) = 0;
            input_matrix(erased,:) = 0;
            % check to see whether red_vx and green_vx have any remaining
            % predecessors
            if sum(input_matrix(:,red_vx))==0 || sum(input_matrix(:,green_vx))==0
                continue
            end
          
         
            
            
            [free_red, free_green, parent, bottleneck_node, ownership] = ...
                DDFS2(input_matrix, level, red_vx, green_vx);
            if isempty(bottleneck_node)
                if isempty(free_red) || isempty(free_green)
                    error('yo');
                end
                
                % findpath and augment
                red_path = FINDPATH(parent, red_vx, free_red);
                green_path = FINDPATH(parent, green_vx, free_green);
                aug_path = [red_path,flip(green_path)];
                pair = AUGMENT(pair, aug_path);
                [erased, predecessors_count] = ...
                    ERASE(erased,aug_path,predecessors,predecessors_count);
                matching_size = matching_size+1;
            end
        end
        
    end
    
end

disp(['matching size is ', num2str(matching_size)]);