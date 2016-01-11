%% TODO a lot of different random graphs. Problems may be lurking. 

%% test_find_max_matching
adjacency_matrix = zeros(12);
row_subs = [1,2,2,3,3,3,4,4,5,5,5 ,6,6,7,7,8,9,9 ,10,10,11,11,12,12];
col_subs = [2,1,3,2,4,5,3,6,3,7,12,4,7,6,5,9,8,10,9 ,11,10,12,11,5 ];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;

pair = [13,3,2,6,7,4,5,13,10,9,12,11];



pair = find_max_matching(adjacency_matrix, pair);
assert(isequal(pair, [2,1,4,3,12,7,6,9,8,11,10,5]));




%% search finds blossoms but not augmentation, quits.
clear

temp = load('~/Code/MinimaxProjectCode/testing_matrices/mat1.mat','adjacency_matrix');
adjacency_matrix = temp.adjacency_matrix;
pair = [3,8,1,5,4,7,6,2,11,11];


pair = find_max_matching(adjacency_matrix, pair);



%%

clear

temp = load('~/Code/MinimaxProjectCode/testing_matrices/mat2.mat','adjacency_matrix');
adjacency_matrix = temp.adjacency_matrix;

pair = find_max_matching(adjacency_matrix);


%%
clear

temp = load('~/Code/MinimaxProjectCode/testing_matrices/mat3.mat','adjacency_matrix');
adjacency_matrix = temp.adjacency_matrix;

pair = find_max_matching(adjacency_matrix);

%% test with bipartite graphs
clear

distribution.type = 'custom';
params = [0,0,.7,0,0,0,0,0,0,0,.2,.1];
distribution.params = size_bias(params);
num_nodes = 1000;
for i = 1:4
    adjacency_matrix = create_bipartite_configuration_model(num_nodes,distribution);
    pair1 = hopcroft_karp(adjacency_matrix);
    pair2 = find_max_matching(adjacency_matrix);
    hop_matching_size = sum(pair1<length(pair1)+1);
    mv_matching_size = sum(pair2<length(pair2)+1);
    assert(isequal(hop_matching_size, mv_matching_size));
    matching = true;
    for j = 1: num_nodes
        if length(find(pair2==j,2))>1
            matching = false;
        end
    end
    assert(matching);
    disp([num2str(i), ' of 4 matchings tested']);
end

%% test with lots of random graphs

clear

distribution.type = 'custom';
% params = [0,.7,0,0,0,0,0,0,0,.2,.1];
% distribution.params = size_bias(params);
num_nodes = 1000;
dummy = num_nodes +1;

for i = 1:10
    params = rand(1,30);
    params = params/sum(params);
    distribution.params = size_bias(params);
    
    adjacency_matrix = create_configuration_model(num_nodes,distribution);
    pair = find_max_matching(adjacency_matrix);
    matching_size = sum(pair<length(pair)+1);
    matching = true;
    
    for j = 1: num_nodes
        if length(find(pair==j,2))>1 % double matched a vertex
            matching = false;
            break
        end
        if pair(j)~=dummy && adjacency_matrix(j,pair(j))==0 % paired with something that is not an edge
            matching = false;
            break
        end
        if pair(j) ~= dummy && pair(pair(j))~=j
            matching = false;
            break
        end
            
    end
    assert(matching);
    disp([num2str(i), ' of 10 matchings tested']);
end
%% no aug_path exists in medium size graph
% 
clear

distribution.type = 'custom';
params = [0,.7,0,0,0,0,0,0,0,.2,.1];
distribution.params = size_bias(params);
num_nodes = 1000;

adjacency_matrix = create_configuration_model(num_nodes,distribution);
pair = find_max_matching(adjacency_matrix);

bool = check_for_aug_path(adjacency_matrix,pair);
assert(~bool);





