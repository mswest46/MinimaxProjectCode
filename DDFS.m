
function output = DDFS(adjacency_matrix, height, r, g, xy)
close all
gplot(adjacency_matrix,xy,'-*')
axis([0,7,-1,8]);
hold on;

num_nodes = size(adjacency_matrix,1);
level = @(node_index) height(node_index);
ownership = zeros(1,num_nodes); % 1 = red, 2 = green
green_position = g;
red_parents = zeros(1,num_nodes);
green_parents = zeros(1,num_nodes);
red_position = r;
searched = zeros(num_nodes);

k = 0;
while true
    
    % case. 
    % 1 no collision, red moves first.
    % 2 no collision, green moves.
    % 3 collision, green searching
    % 4 collsion, red searching
    % 5 end collision, proceed or return. 
    collision = (red_position == green_position);
    collision_node = red_position;
    
    1;
    k = k+1;
    % plot graph
    h1 = viscircles(xy(red_position,:),.25,'Color','red');
    h2 = viscircles(xy(green_position,:),.2,'Color','green');
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
    pause;
    
    if ~collision
        
        
        if level(red_position)>=level(green_position)
            neighbors = find(adjacency_matrix(red_position,:));
            % advance red
            1;
            children = neighbors(level(neighbors)<level(red_position)...
                & ~searched(neighbors));
            if ~isempty(children)
                searched(red_position) = 1;
                best_kid = children(1);
                red_parents(best_kid) = red_position;
                ownership(red_position) = 1;
                searched(red_position) = 1;
                red_position = best_kid;
            else
                %backtrack
                red_position = red_parents(red_position);
            end
        else
            neighbors = find(adjacency_matrix(green_position,:));
            % advance green
            1;
            children = neighbors(level(neighbors)<level(green_position)...
                & ~searched(neighbors));
            
            
            if ~isempty(children)
                
                best_kid = children(1);
                searched(best_kid) = 1;
                ownership(green_position) = 2;
                green_parents(best_kid) = green_position;
                green_position = best_kid;
            else
                %backtrack
                green_position = green_parents(green_position);
            end
        end
        
    else
        if red_position < green_position
            collision = 0; % we've found a way around.
        elseif
            
            % backtrack
            red_position = red_parents(red_position);
        end
        
        
        % plot graph
        delete(h1);
        delete(h2);
    end
    
    
    
end