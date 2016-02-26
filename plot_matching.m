function plot_matching(adjacency_matrix, level, pair, view_vxs)

matching_flag = false;
if ~isempty(pair)
    matching_flag = true;
end

level_flag = false;
if ~isempty(level)
    level_flag = true;
end


num_nodes = length(adjacency_matrix(:,1));

if ~isempty(view_vxs)
    delete_indices = true(1,num_nodes);
    delete_indices(view_vxs) = false;
    adjacency_matrix(delete_indices,:) = 0;
    adjacency_matrix(:,delete_indices) = 0;
end

    
    
if level_flag
    x = zeros(1,num_nodes);
    y = zeros(1,num_nodes);
    for k = 0: max(level)
        lev = find(level==k);
        l = length(lev);
        x0 = 0;
        for i = lev
            x(i) = x0;
            x0 = x0+(1+.3*rand)/l^1.25;
            y(i) = k;
        end
    end  
    xy = [x;y]';
end

if ~level_flag
    theta = linspace(0,2*pi,num_nodes+1);
    theta = theta(1:num_nodes);
    x = sin(theta);
    y = cos(theta);
    xy = [x;y]';
end

gplot(adjacency_matrix,xy,'-*');
axis([min(xy(:,1))-.25, max(xy(:,1))+.25, min(xy(:,2))-.25, max(xy(:,2))+.25]);
hold on;
for i = 1: num_nodes
    text(x(i),y(i)+.05,num2str(i))
end


if matching_flag
    matching_matrix = zeros(num_nodes);
    for i = 1: length(pair)
        if pair(i) <= num_nodes
            matching_matrix(i,pair(i)) = 1;
        end
    end
    matching_matrix = matching_matrix & adjacency_matrix;
    gplot(matching_matrix,xy,'r-')
end
