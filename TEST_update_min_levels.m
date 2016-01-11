clear

close all

addpath('~/Code/Utilities/');

num_nodes = 7;
adjacency_matrix = zeros(num_nodes);
bridge_matrix = zeros(num_nodes);
predecessors_matrix = zeros(num_nodes);
matching_matrix = zeros(num_nodes);
level = inf(2,num_nodes);

row_sub = [1,1,2,2,3,3,4,4,4,4,5,5,6,6,7,7];
col_sub = [2,3,1,4,1,4,2,3,5,6,4,7,4,7,6,5];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_sub, col_sub)) = 1;
row_sub = [2,4,5,7];
col_sub =[4,2,7,5];
matching_matrix(sub2ind(size(matching_matrix),row_sub,col_sub))=1;
level(1,1) = 0;
data = v2struct(level, adjacency_matrix, bridge_matrix, ...
    predecessors_matrix,matching_matrix);

change = 1;
i = 0;

xy = [1,1,2,1,1,2,1;...
    1,2,2,3,4,4,5]';

gplot(adjacency_matrix, xy,'-*');
hold on

axis([min(xy(:,1))-1,max(xy(:,1))+1,min(xy(:,2))-1,max(xy(:,2))+1]);

while change == 1
    if exist('h1')
        delete(h1);
        delete(h2);
    end
    temp = data.level(1,:);
    str1 = num2str(temp(:));
    temp = data.level(2,:);
    str2 = num2str(temp(:));
    h1 = text(xy(:,1)+.1,xy(:,2),str1);
    h2 = text(xy(:,1)-.1,xy(:,2),str2);
    [data, change] = update_min_levels(data,i);
    disp(data.level)
    pause;
    i = i+1;
    
end
