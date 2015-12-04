clear
close all
% 

load('~/Code/MinimaxProjectCode/broked_matrix.mat','adjacency_matrix');
num_nodes = length(adjacency_matrix(:,1));
% 
% distribution.type = 'custom';
% params([3,7]) = [.9,.1]; 
% distribution.params = size_bias(params);
% num_nodes = 70;
% adjacency_matrix = create_bipartite_configuration_model(num_nodes,distribution);

% adjacency_matrix = spalloc(num_nodes+1,num_nodes+1,num_nodes+1);
% temp = create_bipartite_configuration_model(num_nodes,distribution);
% adjacency_matrix(1:num_nodes,1:num_nodes) = temp;
% adjacency_matrix(num_nodes+1, randi(num_nodes,1)) = 1;


% num_nodes = 9;
% adjacency_matrix = zeros(num_nodes);
% left_part_subs =  [1,2,3,3,3,4,5,5];
% right_part_subs = [6,6,6,7,8,7,8,9];
% row_subs = [left_part_subs, right_part_subs];
% col_subs = [right_part_subs, left_part_subs];
% 
% adjacency_matrix(sub2ind(size(adjacency_matrix),row_subs,col_subs)) = 1;
% 
% x = [0,0,0,0,0,1,1,1,1];
% y = [1,2,3,4,5,1,2,3,4];
% 
% xy = [x;y]';


% num_nodes = 11;
% mat = zeros(num_nodes);
% left_part_subs = [1,1,1,2,2,3,3,4,4,5,5];
% right_part_subs = [6,7,8,8,9,8,10,10,11,10,11];
% row_subs = [left_part_subs, right_part_subs];
% col_subs = [right_part_subs, left_part_subs];
% mat(sub2ind(size(mat),row_subs,col_subs)) = 1;

% left_part_subs =  [1,2,3,3,3,4,5,5];
% right_part_subs = [6,6,6,7,8,7,8,9];
% row_subs = [left_part_subs, right_part_subs];
% col_subs = [right_part_subs, left_part_subs];
% 
% mat(sub2ind(size(mat),row_subs,col_subs)) = 1;
% 

% num_nodes = 7;
% adjacency_matrix = zeros(num_nodes);
% left_part_subs = [1,2,3,4,4,4];
% right_part_subs = [5,5,5,5,6,7];
% row_subs = [left_part_subs, right_part_subs];
% col_subs = [right_part_subs, left_part_subs];
% adjacency_matrix(sub2ind(size(adjacency_matrix),row_subs,col_subs)) = 1;
% 

% x = [zeros(1,num_nodes/2),ones(1,num_nodes/2)];
% y = [(1:num_nodes/2)/(num_nodes/2),(1:num_nodes/2)/(num_nodes/2)];
% xy = [x;y]';
% gplot(adjacency_matrix,xy,'-*');
% axis([min(xy(:,1))-.25, max(xy(:,1))+.25, min(xy(:,2))-.25, max(xy(:,2))+.25]);
% pause


%%
close all;

% [matching_size,matching_matrix,pair] = hopcroft_karp_with_plot(adjacency_matrix,xy);
pair1 = hopcroft_karp(adjacency_matrix);
hop_matching_size = sum(pair1<length(pair1)+1);


pair2 = find_max_matching(adjacency_matrix);
% vertices_in_all_matchings = find_vxs_in_all_maximal_matchings(...
%     adjacency_matrix, pair);

MV_matching_size = sum(pair2<length(pair2)+1);

if MV_matching_size ~= hop_matching_size
    error('matchings are different sizes')
end

for i = 1:length(pair1)
    if sum(pair1==i)>1
        error('vertex is double matched')
    end
end


for i = 1:length(pair2)
    if sum(pair2==i)>1
        error('vertex is double matched')
    end
end

