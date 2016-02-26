% testing over night
if exist('~/Data/bad_graphs/','dir')
    rmdir('~/Data/bad_graphs/','s');
end
mkdir('~/Data/bad_graphs/');

num = 1;

parameters = cell(1,10);
parameters{1} = [0,0,1];
parameters{2} = [0,0,.9,.1];
parameters{3} = [0,0,.99,.01];
parameters{4} = [0,0,.9,0,0,0,0,.1];
parameters{5} = [0,0,0,.9,0,0,0,.1];
parameters{6} = zeros(1,20); parameters{6}([3,20]) = [.9,.1];
parameters{7} = zeros(1,20); parameters{7}([3,20]) = [.99,.01];
parameters{8} = zeros(1,20); parameters{8}([2,20]) = [.99,.01];
parameters{9} = zeros(1,21); parameters{9}([2,21]) = [.99,.01];
paramters{10} = zeros(1,21); parameters{10}([3,21]) = [.99,.01];

for i = 1:10
    distribution.type = 'custom';
    distribution.params = parameters{i};
    
    for k = 6:7
        for j = 1:3
            disp(clock);
            num_nodes = 10^k;
            adjacency_matrix = create_configuration_model(num_nodes,distribution);
            flag = false;
            try
                pair = find_max_matching(adjacency_matrix,true,'vazirani');
            catch
                filename = strcat(...
                    '~/Data/bad_graphs/matrix',...
                    num2str(num),'.mat');
                string = 'errored';
                disp(string);
                save(filename,'adjacency_matrix','string');
                num = num+1;
                flag = true;
            end
            if ~flag
                [aug_path_exists,~] = check_for_aug_path(adjacency_matrix,pair);
                if aug_path_exists
                    filename = strcat(...
                        '~/Data/bad_graphs/matrix',...
                        num2str(num),'.mat');
                    string = 'incomplete';
                    disp(string);
                    save(filename,'adjacency_matrix','string');
                    num = num+1;
                end
                
            end
            
        end
    end
end

