% these tests are meant to weed out bugs by brute force. So any bad
% matrices should be saved


%% 

% compare matching size with that found by hopcroft

clear
close all;

addpath('~/Code/MinimaxProjectCode/');
addpath('~/Code/MinimaxProjectCode/HopcroftKarpAlgorithm/');


distribution.type = 'custom';
params = [0,0,.5,0,0,0,.2,0,0,0,.2,.1];
distribution.params = size_bias(params);
num_nodes = 1000;
for i = 1:4
%     try
        adjacency_matrix = create_bipartite_configuration_model(num_nodes,distribution);
        pair1 = hopcroft_karp(adjacency_matrix);
        pair2 = vaziraniMatching(adjacency_matrix);
        hop_matching_size = sum(pair1<length(pair1)+1);
        mv_matching_size = sum(pair2<length(pair2)+1);
        assert(isequal(hop_matching_size, mv_matching_size));
        bool = check_pair_is_matching(adjacency_matrix,pair2);
        assert(bool);
%     catch
%         save('~/Desktop/bad.mat','adjacency_matrix');
%         error('yo');
%     end
    disp([num2str(i), ' of 4 matchings tested']);
end


%% lots of medium random graphs. 

clear

distribution.type = 'custom';
num_nodes = 1000;
dummy = num_nodes +1;

for i = 1:20
    params = rand(1,10);
    params = params/sum(params);
    distribution.params = size_bias(params);
    
    try
        adjacency_matrix = create_configuration_model(num_nodes,distribution);
        pair = vaziraniMatching(adjacency_matrix);
        matching_size = sum(pair<length(pair)+1);
        matching = true;
        bool = check_pair_is_matching(adjacency_matrix,pair);
        assert(bool);
        bool = check_for_aug_path(adjacency_matrix,pair);
        assert(~bool);
    catch
        save('~/Desktop/bad.mat','adjacency_matrix');
        error('yo')
    end
    
    disp([num2str(i), ' of 20 matchings tested']);
end

