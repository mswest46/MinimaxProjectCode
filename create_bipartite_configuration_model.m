function adjacency_matrix = create_bipartite_configuration_model(...
    num_nodes,degree_distribution)

% specify a degree distribution and the number of nodes

if mod(num_nodes, 2)
    error('must be an even number of nodes')
end

degree = random_sample(degree_distribution, num_nodes/2);

%%


%the stub list is a list of node indices, where there are d(v) copies of
%v's index in the list
stub_list = zeros(1, sum(degree));

k = 0;
for i = 1:length(degree)
    stub_list(k+1:k+degree(i)) = i;
    k = k + degree(i);
end


% randomly permute the stub_list

p1 = randperm(length(stub_list));
p2 = randperm(length(stub_list));
stub_list1 = stub_list(p1);
stub_list2 = stub_list(p2)+num_nodes/2;

row_sub = [stub_list1,stub_list2];
col_sub = [stub_list2,stub_list1];
adjacency_matrix = sparse(row_sub,col_sub,1,num_nodes, num_nodes);
disp('graph created');

