sim_number = 1;

simul_path = '~/Data/Dissertation/Simulations/';
sim_num_str = sprintf('%03d',sim_number);
sim_dir_path = strcat(simul_path,sim_num_str,'/');

type(strcat(sim_dir_path,'description.txt'));
load(strcat(sim_dir_path,'data.mat'),'data');

target_params = '';
match_params_logical = ...
    arrayfun(@(trial) is_params_same(trial.params,target_params),data);

