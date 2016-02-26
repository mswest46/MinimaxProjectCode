clear

distribution.type = 'custom';
params = [0,.3,.6,0,0,0,0,0,0,0,.1];
distribution.params = size_bias(params);
num_nodes = 10^5;

adjacency_matrix = create_configuration_model(num_nodes,distribution);
[pair, core] = find_max_matching(adjacency_matrix);
vxs_in_all = find_vxs_in_all_maximal_matchings(adjacency_matrix,pair);
temp = false(1,num_nodes); temp(vxs_in_all) = true;

figure;
imagesc(temp);
figure;
imagesc(core);

%% Answers the question: Does order of vxs change the core? 

distribution.type = 'custom';
params = [0,.3,.6,0,0,0,0,0,0,0,.1];
distribution.params = size_bias(params);
num_nodes = 10^5;

adjacency_matrix = create_configuration_model(num_nodes,distribution);
[pair, core] = find_max_matching(adjacency_matrix);


P = randperm(num_nodes);
adjacency_matrix2 = adjacency_matrix(P,P);
[pair2, core2] = find_max_matching(adjacency_matrix2);

disp(sum(pair<num_nodes+1));
disp(sum(pair2<num_nodes+1));

%%
check_pair_is_matching(adjacency_matrix,pair);
check_pair_is_matching(adjacency_matrix2,pair2);
beep;

%%

bool = check_for_aug_path(adjacency_matrix,pair);
bool2 = check_for_aug_path(adjacency_matrix2,pair2);

assert(~bool);
assert(~bool2);

%%
isequal(core2,core)