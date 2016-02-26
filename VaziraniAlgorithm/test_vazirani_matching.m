% %%
% clear
% p = .4;
% num_nodes = 10^6;
% params = zeros(1,11);params([1,3]) = [p,1-p];
% biased_params = size_bias(params);
% dist = struct('type','custom','params',biased_params);
% 
% %create graph
% [adjacency_matrix,info] = create_configuration_model(num_nodes,dist,false);
% 
% %find matching
% pair = karp_sipser_matching(adjacency_matrix);
% 
% %%
% profile clear 
% profile on
% pair = vazirani_matching(adjacency_matrix,pair);
% profile off 
% profile viewer



%% single bloom, single aug_path
adjacency_matrix = zeros(12);
row_subs = [1,2,2,3,3,3,4,4,5,5,5 ,6,6,7,7,8,9,9 ,10,10,11,11,12,12];
col_subs = [2,1,3,2,4,5,3,6,3,7,12,4,7,6,5,9,8,10,9 ,11,10,12,11,5 ];
adjacency_matrix(sub2ind(size(adjacency_matrix), row_subs, col_subs)) = 1;

pair = [13,3,2,6,7,4,5,13,10,9,12,11];
level = [0,1,2,3,3,4,4,0,1,2,3,4];
close all
plot_matching(adjacency_matrix,level,pair,'');

pair = vazirani_matching(adjacency_matrix, pair);
assert(isequal(pair, [2,1,4,3,12,7,6,9,8,11,10,5]));

% %% compare matching size with that found by hopcroft
% 
% clear
% 
% distribution.type = 'custom';
% params = [0,0,.7,0,0,0,0,0,0,0,.2,.1];
% distribution.params = size_bias(params);
% num_nodes = 1000;
% for i = 1:4
%     adjacency_matrix = create_bipartite_configuration_model(num_nodes,distribution);
%     pair1 = hopcroft_karp(adjacency_matrix);
%     pair2 = vazirani_matching(adjacency_matrix);
%     hop_matching_size = sum(pair1<length(pair1)+1);
%     mv_matching_size = sum(pair2<length(pair2)+1);
%     assert(isequal(hop_matching_size, mv_matching_size));
%     bool = check_pair_is_matching(adjacency_matrix,pair2);
%     assert(bool);
%     disp([num2str(i), ' of 4 matchings tested']);
% end

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
    pair = vazirani_matching(adjacency_matrix);
    matching_size = sum(pair<length(pair)+1);
    matching = true;
    bool = check_pair_is_matching(adjacency_matrix,pair);
    assert(bool);
    bool = check_for_aug_path(adjacency_matrix,pair);
    assert(~bool);
    
    disp([num2str(i), ' of 10 matchings tested']);
end

%%

clear

distribution.type = 'custom';
params = [0,.7,0,0,0,0,0,0,0,.2,.1];
distribution.params = size_bias(params);
num_nodes = 10000;
dummy = num_nodes +1;

for i = 1:3
    adjacency_matrix = create_configuration_model(num_nodes,distribution);
    pair = vazirani_matching(adjacency_matrix);
    matching_size = sum(pair<length(pair)+1);
    matching = true;
    bool = check_pair_is_matching(adjacency_matrix,pair);
    assert(bool);
    bool = check_for_aug_path(adjacency_matrix,pair);
    assert(~bool);
    
    disp([num2str(i), ' of 3 matchings tested']);
end




