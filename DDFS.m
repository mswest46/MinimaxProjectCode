
function [free_red, free_green, bottleneck_node, ownership] = DDFS(...
    adjacency_matrix, level, r, g, xy)

% DDFS - Performs Double Depth First Search on a layered graph.
% Given the two starting nodes, we are interested in the highest botteneck.
% i.e. the highest node for which all paths from both the starting node to
% layer 0 vxs must pass through.
%
% Syntax:
% bottleneck_node =
% DDFS(adjacency_matrix, level, red_vx, green_vx, (optional) plot_points)
%
% Inputs:
% adjacency_matrix = the adjacency matrix of the graph
% level = layers of the graph
% r = starting red vertex
% g = starting green vertex
% xy = optional plotting layout for the points.

% Outputs: (WILL ADAPT DEPENDING ON REST OF MV)
% bottleneck_node = the highest bottleneck
% ownership = an array which indicates the color of the vxs. in the graph
% after completion.

close all

switch nargin
    case 4
        plot_switch = 0;
    case 5
        plot_switch = 1;
    otherwise
        error('not enough input arguments')
end

if plot_switch
    gplot(adjacency_matrix,xy,'-*')
    axis([min(xy(:,1))-1,max(xy(:,1))+1,min(xy(:,2))-1,max(xy(:,2))+1]);
    hold on;
end

num_nodes = size(adjacency_matrix,1);

green_parent = zeros(1,num_nodes);
red_parent = zeros(1,num_nodes);
node_visited = zeros(1, num_nodes);
ownership = zeros(1,num_nodes); % 1 = red, 2 = green
green_position = g;
red_position = r;
barrier = g;
bottleneck_found = 0;

if plot_switch
    first_run = 1;
end

while ~(level(red_position) == 0 && level(green_position) == 0)
    
    while level(red_position)>=level(green_position)
        
        if plot_switch
            % plot graph
            
            if ~first_run
                delete(h1);
                delete(h2);
                delete(h3);
            end
            first_run = 0;
            h1 = viscircles(xy(red_position,:),.25,'Color','red');
            h2 = viscircles(xy(green_position,:),.2,'Color','green');
            h3 = viscircles(xy(barrier,:),.3,'Color','black');
            red_xy = xy(ownership == 1,:);
            if ~isempty(red_xy)
                x = red_xy(:,1);
                y = red_xy(:,2);
                plot(x,y,'r*');
            end
            green_xy = xy(ownership == 2,:);
            if ~isempty(green_xy)
                x = green_xy(:,1);
                y = green_xy(:,2);
                plot(x,y,'g*');
            end
            1;
            pause(.3);
        end
        
        if red_position == green_position
            green_position = green_parent(green_position);
            node_visited(red_position) = 1;
            break
        end
        
        ownership(red_position) = 1;
        node_visited(red_position) = 1;
        unused_predecessors = find(adjacency_matrix(:,red_position)& ~node_visited);
        flag = 0;
        
        for u = unused_predecessors
            if u == green_position
                %we've met green, back green up 1.
                green_position = green_parent(green_position);
                red_parent(u) = red_position;
                red_position = u;
                flag = 1;
                break
            elseif ~node_visited(u)
                red_parent(u) = red_position;
                red_position = u;
                flag = 1;
                break
            end
        end
        if flag
            break
        end
        % only get to here when when all of red_poistions's children have
        % been visited already. we backtrack if we're not at the top, else
        % we've found a bottleneck.
        if red_position == r;
            bottleneck_found = 1;
            break
        else
            red_position = red_parent(red_position);
            break
        end
        
    end
    
    if bottleneck_found
        
        disp('bottleneck found');
        bottleneck_node = green_position;
        free_red = [];
        free_green = [];
        break
    end
    
    while(level(red_position)<level(green_position))
        
        if plot_switch
            
            % plot graph
            if ~first_run
                delete(h1);
                delete(h2);
                delete(h3);
                
            end
            first_run = 0;
            h1 = viscircles(xy(red_position,:),.25,'Color','red');
            h2 = viscircles(xy(green_position,:),.2,'Color','green');
            h3 = viscircles(xy(barrier,:),.3,'Color','black');
            red_xy = xy(ownership == 1,:);
            if ~isempty(red_xy)
                x = red_xy(:,1);
                y = red_xy(:,2);
                plot(x,y,'r*');
            end
            green_xy = xy(ownership == 2,:);
            if ~isempty(green_xy)
                x = green_xy(:,1);
                y = green_xy(:,2);
                plot(x,y,'g*');
            end
            1;
            pause(.3);
        end
        
        
        ownership(green_position) = 2;
        node_visited(green_position) = 1;
        
        unused_predecessors = find(adjacency_matrix(:,green_position)& ~node_visited);

        flag = 0;
        for u = unused_predecessors
            
            if ~node_visited(u)
                green_parent(u) = green_position;
                green_position = u;
                flag = 1;
                break
            end
        end
        
        if flag == 1
            break
        end
        
        if ~(green_position==barrier)
            green_position = green_parent(green_position);
        else
            barrier = red_position;
            green_position = red_position;
            red_position = red_parent(red_position);
        end
    end
end

if ~bottleneck_found
    disp('augmenting path exists');
    free_red = red_position;
    free_green = green_position;
    bottleneck_node = [];
end



end


