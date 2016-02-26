function [adjacency_matrix,info] = create_configuration_model(num_nodes,...
    degree_distribution,display_output)

if nargin<3
    display_output = false;
end


if display_output
    dispstat('','init'); % for progress updating.
    dispstat('generating random sample');
    pause(.3);
end
% specify a degree distribution and the number of nodes
even = false;
while ~even
    degree = random_sample(degree_distribution, num_nodes);
    even = (mod(sum(degree),2)==0);
    if display_output
        dispstat('the sum of degrees was not even');
    end
end

if display_output
    dispstat('random sample generated');
    pause(.3);
end

%the stub list is a list of node indices, where there are d(v) copies of
%v's index in the list
num_stubs = sum(degree);
stub_list = zeros(1, num_stubs);
k = 0;

if display_output
    dispstat('generating stub list');
    pause(.3);
end

% TODO maybe this does the size biasing for us.
for i = 1:length(degree)
    stub_list(k+1:k+degree(i)) = i;
    k = k + degree(i);
end

if display_output
    dispstat('creating adjacency matrix');
    pause(.3);
end

stub_list = stub_list(randperm(num_stubs));
row_subs = stub_list;
col_subs = [stub_list(num_stubs/2+1:end),stub_list(1:num_stubs/2)];
adjacency_matrix = sparse(row_subs,col_subs,1,num_nodes, num_nodes);
[row_subs,col_subs] = ind2sub(size(adjacency_matrix),find(adjacency_matrix>1));
info.multi_edges = [row_subs,col_subs];

D = logical(speye(num_nodes,num_nodes));
info.self_edges = find(adjacency_matrix(D)>0);
adjacency_matrix(D) = 0;

assert(issymmetric(adjacency_matrix));

if display_output
    dispstat('graph created');
end


