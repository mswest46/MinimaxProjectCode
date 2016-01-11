function bipartite_g_plot(adjacency_matrix)
close all;

num_nodes = length(adjacency_matrix(:,1));
x = [zeros(1,num_nodes/2),ones(1,num_nodes/2)];
y = [(1:num_nodes/2)/(num_nodes/2),(1:num_nodes/2)/(num_nodes/2)];
xy = [x;y]';
gplot(adjacency_matrix,xy,'-*');
axis([min(xy(:,1))-.25, max(xy(:,1))+.25, min(xy(:,2))-.25, max(xy(:,2))+.25]);

str = [];
for i = 1: num_nodes
    str = [str;sprintf('%02d',i)];
end

 text(x,y+.05,str)

