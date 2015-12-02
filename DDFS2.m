function [free_red, free_green, parent, bottleneck_node, ownership] = ...
    DDFS2(available_edges, level, red_initial, green_initial, pair, xy)

switch nargin
    case 5
        plot_switch = 0;
    case 6
        plot_switch = 1;
    otherwise
        error('not enough input arguments')
end

if plot_switch
    adjacency_matrix = available_edges;
    gplot(adjacency_matrix,xy,'-*')
    axis([min(xy(:,1))-1,max(xy(:,1))+1,min(xy(:,2))-1,max(xy(:,2))+1]);
    hold on;
    first_run = 1;
end



num_nodes = length(available_edges(:,1));
ownership = zeros(1, num_nodes); % 1 for red, 2 for green
ownership(red_initial) = 1;
ownership(green_initial) =2;
parent = zeros(1,num_nodes);

red_position = red_initial;
green_position = green_initial;
barrier = green_initial;
DCV = [];
bottleneck_node = [];
free_red = [];
free_green = [];
bottleneck_found = 0;



% when we check vertices, we proceed down available edges only. Once we
% arrive at vertex, we check to see if it has been visited previously or is
% occupied by the other DFS.

while ~(level(red_position) == 0 && level(green_position) == 0)
    
    1;
    while level(red_position) >= level(green_position)
        
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
            pause(.3);
        end
        
        % RED_DFS
        u = find(available_edges(:,red_position),1);
        if isempty(u)
            if red_position == red_initial
                % we have backtracked all the way and a bottleneck
                % discovered
                'bottleneck found'
                bottleneck_node = DCV;
                if isempty(DCV)
                    error('not a real bottleneck')
                end
                bottleneck_found = 1;
                break
            else
                %BACKTRACK
                red_position = parent(red_position);
            end
        else % there is an available predecessor_edge
            if u == green_position
                ownership(u) = 1;
                green_position = parent(green_position);
                DCV = red_position;
            elseif ownership(u) % u is previously visited via a different edge by one of the DFSs
                available_edges(u,red_position) = 0; % mark edge as used.
                % don't change red_position
            else % we are in an unexamined edge to an unexamined vertex
                parent(u) = red_position;
                available_edges(u,red_position) = 0;
                ownership(u) = 1;
                red_position = u;
            end
        end
        
    end
    
    if bottleneck_found
        break
    end
    
    while level(red_position) < level(green_position)
        
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
        
        % GREEN_DFS
        u = find(available_edges(:,green_position),1);
        if isempty(u)
            if green_position == barrier
                % green returns to DCV and takes ownership, red does its
                % backtrack thang, and barrier moves to DCV
                barrier = DCV;
                green_position = DCV;
                ownership(green_position) = 2;
                red_position = parent(red_position);
            else % BACKTRACK
                green_position = parent(green_position);
            end
        else % predecessor exists
            if u == red_position
                ownership(u) = 1; % red gets ownership by convention
                green_position = parent(green_position); % set green backtracking
                DCV = red_position;
            elseif ownership(u)
                available_edges(u,green_position) = 0;
                % do nothing else
            else
                parent(u) = green_position;
                available_edges(u,green_position) = 0;
                ownership(u) = 2;
                green_position = u;
            end
        end
    end
    
    
end

if ~bottleneck_found
    free_red = red_position;
    free_green = green_position;
    if isempty(free_red) || isempty(free_green)
        error('hey')
    end
    
    
end
