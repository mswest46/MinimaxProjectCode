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

description = ['What happens with multiple R2 atoms? several trials of '...
    'p2 = .6, p12 = .4'];

this_script_file = strcat(mfilename('fullpath'),'.m');
copyfile(this_script_file,strcat(new_sim_path,'script.txt'));

fid = fopen(strcat(new_sim_path,'description.txt'),'wt');
fprintf(fid, description);
fclose(fid);

data = struct('num_nodes',[],'params',{},'adjacency_matrix',{},'multi_edges',{},...
    'pair',{},'v_in_all',{});

%% From here down can be messed with

sample_size = 15;
num_trials = 15;
eTime = zeros(1,15);
fid = fopen(strcat(new_sim_path,'simpleData.txt')','wt');
k = 1;
params = zeros(1,13); params([1,3,13]) = [.0001,.6,.4];
for j = 1:sample_size
    r = round(rand);
    num_nodes = 5*10^5+r;
    fprintf(fid,['\ntrial ',num2str(j),': ']);
    dispstat(['running trial ',num2str(k),' of total ',num2str(num_trials)]);
    %specifying distribution
    params = geometric_params(p);
    biased_params = size_bias(params);
    dist = struct('type','custom','params',biased_params);
    
    %create graph
    tic;
    [A,info] = create_configuration_model(num_nodes,dist,false);
    [A,num_nodes] = isolate_largest_component(A);
    degrees = full(sum(A));
    cTime(i,j) = toc;
    
    %find matching
    tic;
    pair = find_max_matching(A,true,'vazirani2');
    numVM = sum(pair<num_nodes+1);
    % find vertices in all matchings.
    v_in_all = find_vxs_in_all_maximal_matchings(A,pair);
    numVAll = sum(v_in_all);
    t = toc;
    eTime(i,j) = t;
    
    
    % input the data.
    data(k).num_nodes = num_nodes; ...
        data(k).params = params; ...
        data(k).multi_edges = info.multi_edges; ...
        data(k).v_in_all = v_in_all; data(k).degrees = degrees;...
        data(k).numV = numVAll; data(k).numVM = numVM;data(k).r = r;
    fprintf(fid,['\n    Graph Size: ', num2str(num_nodes)]);
    fprintf(fid,['\n    Matching Size: ',num2str(numVM)]);
    fprintf(fid,['\n    Winning Set Size: ',num2str(numVAll)]);
    fprintf(fid,['\n    r: ',num2str(r)]);
    fprintf(fid,['\n    elapsed time: ',num2str(t)]);
    fprintf(fid,['\n    time:', datestr(clock)]);
    k = k+1;
end

fclose(fid);


save(strcat(new_sim_path,'data.mat'),'data','eTime','cTime');



