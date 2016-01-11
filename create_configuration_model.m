function adjacency_matrix = create_configuration_model(num_nodes,...
    degree_distribution)

dispstat('','init'); % for progress updating.

dispstat('generating random sample');
pause(.3);
% specify a degree distribution and the number of nodes
even = false;
while ~even
    degree = random_sample(degree_distribution, num_nodes);
    even = (mod(sum(degree),2)==0);
end

dispstat('random sample generated');
pause(.3);

%the stub list is a list of node indices, where there are d(v) copies of
%v's index in the list
num_stubs = sum(degree);
stub_list = zeros(1, num_stubs);
k = 0;

dispstat('generating stub list');
pause(.3);
% TODO maybe this does the size biasing for us. 
for i = 1:length(degree)
    stub_list(k+1:k+degree(i)) = i;
    k = k + degree(i);
end

dispstat('creating adjacency matrix');
pause(.3);

stub_list = stub_list(randperm(num_stubs));
row_subs = stub_list;
col_subs = [stub_list(num_stubs/2+1:end),stub_list(1:num_stubs/2)];
adjacency_matrix = sparse(row_subs,col_subs,1,num_nodes, num_nodes);

% while ~isempty(stub_list)
%     i_ind = randi(length(stub_list));
%     i = stub_list(i_ind);
%     stub_list(i_ind)=[];
%     j_ind = randi(length(stub_list));
%     j = stub_list(j_ind);
%     stub_list(j_ind)=[];
%     adjacency_matrix(i,j) = 1;
%     adjacency_matrix(j,i) = 1;
% end

% discard self-edges. multiple edges between two nodes have already been
% ignored. 
for i = 1:num_nodes
    adjacency_matrix(i,i) = 0;
end

% make symmetric
adjacency_matrix = max(adjacency_matrix, adjacency_matrix');

dispstat('graph created');


