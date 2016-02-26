find_max_matching(adjacency_matrix,false,'vazirani')

% every simulation should have a goal, something that it wants to find out.
% So, will be saving data in batches. want to save distribution,
% adjacency_matrix (and information about multi-edges), pair, and vertices
% in all matchings. Can compute any other relevant information from those.
% i.e.number of components, matching in largest component, etc. Constants
% across simulations will also be saved, in a separate file in the
% directory where all the data is stored. This includes a .txt copy of this
% script, a descriptive string,

% Step 1: find the most recent run number R.

% Step 2: increment that number by 1 and create a directory with named by
% that number.

% Step 3: Save the current script in a .txt file and another .txt file
% describing the point of the simulation.

% Step 4: Save the aforementioned data. TODO In what format?
clear

dispstat('','init');

simul_path = '~/Data/Dissertation/Simulations/';
file_names = GetFilesInDirectoryMatchingString(simul_path,'Simulation');
sim_numbers = zeros(1,length(file_names)+1);

for k = 1:length(file_names)
temp = regexp(file_names{k},'\d*$','match');
if~isempty(temp)
    sim_numbers(k) = str2double(temp{1});
end
end
new_sim_num = max(sim_numbers)+1;
new_sim_num_str = sprintf('%03d',new_sim_num);
new_sim_path = strcat(simul_path,'Simulation',new_sim_num_str,'/');
mkdir(new_sim_path);

description = ['Graphs with nodes of two degrees, k1 and k2, for'...
    ' k1 = 1 and k2 changing. Investigation, so not many trials '...
    'for each type'];

this_script_file = strcat(mfilename('fullpath'),'.m');
copyfile(this_script_file,strcat(new_sim_path,'script.txt'));

fid = fopen(strcat(new_sim_path,'description.txt'),'wt');
fprintf(fid, description);
fclose(fid);

data = struct('num_nodes',[],'params',{},'adjacency_matrix',{},'multi_edges',{},...
    'pair',{},'v_in_all',{});

%% From here down can be messed with

p_opts = [.4,.55,.7];
sample_size = 5;
num_trials = 15;
num_nodes = 10^6;

k = 1;
for i = 1:3
    p = p_opts(i);
    for j = 1:sample_size
        dispstat(['running trial ',num2str(k),' of total ',num2str(num_trials)]);
        %specifying distribution
        params = zeros(1,11);params([1,3]) = [p,1-p];
        biased_params = size_bias(params);
        dist = struct('type','custom','params',biased_params);
        
        %create graph
        [adjacency_matrix,info] = create_configuration_model(num_nodes,dist,false);
        
        %find matching
        pair = find_max_matching(adjacency_matrix,true,'vazirani');
        
        % find vertices in all matchings.
        v_in_all = find_vxs_in_all_maximal_matchings(adjacency_matrix,pair);
        
        % input the data.
        data(k).num_nodes = num_nodes; data(k).params = params; ...
            data(k).adjacency_matrix = adjacency_matrix;...
            data(k).multi_edges = info.multi_edges; data(k).pair = pair;...
            data(k).v_in_all = v_in_all;
        k = k+1;
    end
end


save(strcat(new_sim_path,'data.mat'),'data');



