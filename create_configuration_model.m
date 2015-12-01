function adjacency_matrix = create_configuration_model(num_nodes,...
    degree_distribution)

% specify a degree distribution and the number of nodes

even = false;
while ~even
    degree = random_sample(degree_distribution, num_nodes);
    even = (mod(sum(degree),2)==0);
end

adjacency_matrix = zeros(num_nodes);

%the stub list is a list of node indices, where there are d(v) copies of
%v's index in the list
stub_list = zeros(1, sum(degree));
k = 0;
for i = 1:length(degree)
    stub_list(k+1:k+degree(i)) = i;
    k = k + degree(i);
end

while ~isempty(stub_list)
    i_ind = randi(length(stub_list));
    i = stub_list(i_ind);
    stub_list(i_ind)=[];
    j_ind = randi(length(stub_list));
    j = stub_list(j_ind);
    stub_list(j_ind)=[];
    adjacency_matrix(i,j) = 1;
end

% discard self-edges. multiple edges between two nodes have already been
% ignored. 


for i = 1:num_nodes
    adjacency_matrix(i,i) = 0;
end


