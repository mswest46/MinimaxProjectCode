clear all;
close all;

% script that creates a bunch of tree objects using the create_tree
% function and saves them into a folder

addpath('~/Code/Utilities', '~/Code/Utilities/v2struct_2011_09_12/')


%% The parameters I want to save

NUMBER_OF_TREES = 100;
TREE_HEIGHT = 20;
OFFSPRING_DISTRIBUTION.type = 'constant';
OFFSPRING_DISTRIBUTION.params = 2;
TERMINAL_NODE_DISTRIBUTION.type = 'uniform';
TERMINAL_NODE_DISTRIBUTION.params = [0,1];


params = v2struct(TREE_HEIGHT, OFFSPRING_DISTRIBUTION, ...
    TERMINAL_NODE_DISTRIBUTION);

%%
save_dir = '~/Data/Trees/';

if ~exist(save_dir,'dir')
    mkdir(save_dir);
end

% Get a unique sample directory
temp = get_files_in_directory_matching_string(save_dir,'Sample');
if isempty(temp)
    run_no = 000;
else
    numbers = [];
    for n=1:length(temp);numbers = [numbers, str2double(temp{n}(7:9))];end;
    run_no = max(numbers)+1;
end

run_name = sprintf('Sample%03d',run_no);


folder = fullfile(save_dir, run_name);
mkdir(folder);


%% save parameters
save(fullfile(folder, 'params.mat'), '-struct', 'params');

%% create trees

for i = 1: NUMBER_OF_TREES
    tree = create_tree(TREE_HEIGHT, OFFSPRING_DISTRIBUTION, ...
        TERMINAL_NODE_DISTRIBUTION, false);
    trees(i)=tree;
    if (mod(i,5)==0)
        disp(i);
    end
end

%% save trees

save(fullfile(folder, 'trees.mat'), 'trees', '-v7.3');


%%

beep 
