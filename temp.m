% realistic configuration model.
addpath('~/Code/VisComms')
clear
close all;
p = .4;
params = zeros(1,11);params([1,2,6]) = [.001,p,1-p];
biased_params = size_bias(params);
dist = struct('type','custom','params',biased_params);


%%
num_runs = 10;
exp = round(logspace(5,6,num_runs));
cTime = zeros(1,num_runs);
eTime = zeros(1,num_runs);
for i = 1:length(exp)
    num_nodes = exp(i);
    tic;
    A = create_configuration_model(num_nodes,dist);
    A = isolate_largest_component(A);
    
    cTime(i) = toc;
%     display_degree_distribution(A);
    
    tic;
    pair = find_max_matching(A,true,'vazirani2');
    vxs = find_vxs_in_all_maximal_matchings(A,pair);
    eTime(i) = toc;
end

plot(exp,cTime,exp,eTime);
legend('creation time','evaluation time');