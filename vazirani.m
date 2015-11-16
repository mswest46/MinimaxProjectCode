function matching = vazirani(adjacency_matrix);

num_nodes = length(adjacency_matrix(:,1));
matching_adjacency_matrix = zeros(num_nodes);
antimatching_adjacency_matrix = adjacency_matrix;
bridge = inf(num_nodes); %inf if not checked. 0 if prop, 1 if bridge
level = zeros(2,num_nodes); % first row is even_level, second is odd_level
min_level = zeros(1,num_nodes);
max_level = zeros(1,num_nodes);
node_tenacity = zeros(1,num_nodes);
edge_tenacity = zeros(num_nodes);
predecessors = zeros(num_nodes); %predecessors of vx v are indices of 1s in row v
end


function output = MIN(input, i);

odd = mod(i,2); % 0 if even, 1 if odd
level_i_vxs = find(level(:,odd+1)==i); % vxs for which even/odd level is i.
for u = level_i_vxs
    if ~odd % even
        search_matrix = antimatching_adjacency_matrix;
    else 
        search_matrix = matching_adjacency_matrix;
    end
    
    for v = find(search_matrix(:,u)); %neighbors of u along matched/unmatched edges 
        if bridges(v,u)>2; % i.e. not scanned yet
            % if i is even, i+1 is odd and v might have oddlevel i+1. if i
            % is odd v might have evenlevel i+1. 
            if odd && even_level(v) > i+1
                ind = 1;
                level(1,v) = i+1;
                
            elseif even && odd_level(v) > i+1
                ind = 1;
                level(2,v) = i+1;
            end
            if ind
                vertex_tenacity(v) = sum(level(:,v));
                min_level(v) = i+1;
                predecessors(v,u) = 1;
                bridge(v,u) = 0;
            else 
                bridge(v,u) = 1;
            end
        end
    end
end
end

function output = DDFS(input)
%% we have two DFSs running, communicating with each other as they run. 
red_parent = zeros(1,num_nodes);
green_parent = zeros(1,num_nodes);
red_stack = r;
green_stack = g;
red_COA = r;
green_COA = g;
while something
    if red_COA == green_COA;
        collision = 1;
        collision_vx = red_COA;
        red_COA = red_parent(collision_vx);
        green_COA = green_parent(collision_vx);
        
    end
    if ~collision      
        % we just run the DFSs as normal, ensuring we stay level-ish.
        if min_level(red_COA) >= min_level(green_COA);
            red_DFS();
        else 
            green_DFS();
        end
    else
        % collision! now we are backtracking on green until we find a new
        % green_COA, in which case the collision vx becomes red and
        % red_COA, orr, we have empty green_stack, in which case 
        if ~isempty(green_stack)
            green_DFS(parent(green_COA));
            if min_level(green_COA) <= min_level(collision_vx);
                collision = 0; % resume like usual
                red_COA = collision_vx;
                %
            end 
        else
            red_DFS(parent(red_COA));
        end
          
       
        
    end
    
end

    function output = red_DFS(red_COA);
        % find the first neighbor u of v for which we haven't visited.
        v = find((adjacency_matrix(:,v) && visited), 1);
        if ~isempty(v)
            red_stack(end+1) = v; % add v to stack
            parent(v) = u; 
            red_COA = v; % move COA to v
        else 
            red_stack(red_stack == u) = []; %remove u from stack.
            red_COA = parent(u); % move COA to u's parent.
        end
    end

    function output = green_DFS(green_COA);
            % find the first neighbor u of v for which we haven't visited.
        v = find((adjacency_matrix(:,v) && visited), 1);
        if ~isempty(v)
            red_stack(end+1) = v; % add v to stack
            parent(v) = u; 
            red_COA = v; % move COA to v
        else 
            red_stack(red_stack == u) = []; %remove u from stack.
            red_COA = parent(u); % move COA to u's parent.
        end
    end



while ~isempty(red_stack) 
   
    end
end
end

    
