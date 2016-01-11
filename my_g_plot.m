function my_g_plot(adjacency_matrix)

close all;

num_nodes = length(adjacency_matrix(:,1));
theta = linspace(0,2*pi,num_nodes+1);
theta = theta(1:num_nodes);
x = sin(theta);
y = cos(theta);
xy = [x;y]';
gplot(adjacency_matrix,xy,'-*');
axis([min(xy(:,1))-.25, max(xy(:,1))+.25, min(xy(:,2))-.25, max(xy(:,2))+.25]);

str = [];
for i = 1: num_nodes
    str = [str;sprintf('%02d',i)];
end

 text(x,y+.05,str)