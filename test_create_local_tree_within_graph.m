%% test the degree distributions are correct.
clear

dispstat('','init');
dist_params = [0,0,.9,0,0,0,.1];
biased_params = size_bias(dist_params);
num_nodes = 10^6;
dist = struct('type','custom','params',biased_params);
adjacency_matrix = create_configuration_model(num_nodes,dist);

num_samples = 100;
roots = randi(num_nodes,[1,num_samples]);
is_tree = cell(1,num_samples); 
tree_mat = cell(1,num_samples);
degree_vec = cell(1,num_samples);
for i = 1:num_samples
    [is_tree{i},tree_mat{i},degree_vec{i}] = create_local_tree_within_graph(adjacency_matrix,roots(i),6);
    dispstat(num2str(i/num_samples));
end

root_degrees = zeros(1,num_samples);
for i = 1:num_samples
root_degrees(i) = degree_vec{i}(roots(i));
end

other_degrees = [];
for i = 1:num_samples
    degree_vec{i}(roots(i)) = nan;
    other_degrees = [other_degrees,degree_vec{i}(~isnan(degree_vec{i}))];
end

p = zeros(1,max(other_degrees)+1);
for k = 0:max(other_degrees);
    p(k+1) = sum(other_degrees==k);
end
p = p/sum(p);

p0 = zeros(1,max(root_degrees)+1);
for k = 0:max(root_degrees)
    p0(k+1) = sum(root_degrees == k);
end
p0 = p0/sum(p0);

my_beep


% create config model from some biased distribution

% sample a bunch of the local graphs and make sure they are from the
% correct distribution


