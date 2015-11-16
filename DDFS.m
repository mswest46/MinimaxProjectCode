
function bottleneck_node = DDFS(adjacency_matrix, height, r, g, xy)
close all
gplot(adjacency_matrix,xy,'-*')
axis([0,7,-1,8]);
hold on;

num_nodes = size(adjacency_matrix,1);
level = @(node_index) height(node_index);
green_parent = zeros(1,num_nodes);
red_parent = zeros(1,num_nodes);
node_visited = zeros(1, num_nodes);
edge_used = zeros(num_nodes);
ownership = zeros(1,num_nodes); % 1 = red, 2 = green
green_position = g;
red_position = r;
barrier = g;
bottleneck_found = 0;

k = 0;
while ~(level(red_position) == 0 && level(green_position) == 0)
    1;
    
    while level(red_position)>=level(green_position)
        
        % plot graph
        
        if k
            delete(h1);
            delete(h2);
            delete(h3);
         
        end
        k=1;
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
        pause;
        
        
        if red_position == green_position
            green_position = green_parent(green_position);
            break
        end
        
        
        ownership(red_position) = 1;
        node_visited(red_position) = 1;
        unused_edges = (adjacency_matrix & ~edge_used);
        unused_neighbors = find(unused_edges(red_position,:));
        unused_children = unused_neighbors(...
            height(unused_neighbors) < height(red_position));
        flag = 0;
        for u = unused_children
            edge_used(red_position, u) = 1;
            edge_used(u, red_position) = 1;
            if u == green_position
                1;
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
        bottleneck_node = green_position;
        break
    end
    
    while(level(red_position)<level(green_position))
        
        % plot graph
        if k
            delete(h1);
            delete(h2);
            delete(h3);
         
        end
        k=1;
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
        pause;
        
        
        ownership(green_position) = 2;
        unused_edges = (adjacency_matrix & ~edge_used);
        unused_neighbors = find(unused_edges(green_position,:));
        unused_children = unused_neighbors(...
            height(unused_neighbors) < height(green_position));
        1;
        flag = 0;
        for u = unused_children
            edge_used(green_position, u) = 1;
            edge_used(u, green_position) = 1;
            
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
        
         1;
        if ~(green_position==barrier)
            green_position = green_parent(green_position);
        else
            barrier = red_position;
            green_position = red_position;
            red_position = red_parent(red_position);
        end
    end
end





end


