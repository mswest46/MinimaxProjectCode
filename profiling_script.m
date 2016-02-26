
distribution.type = 'custom';
params = [0,.3,.6,0,0,0,0,0,0,0,.1];
distribution.params = size_bias(params);
num_nodes = 10^7;
adjacency_matrix = create_configuration_model(num_nodes,distribution);
pair = find_max_matching(adjacency_matrix,true,'vazirani');



% %% for profiling purposes
% if exist('~/Data/bad_graphs/','dir')
%     rmdir('~/Data/bad_graphs/','s');
% end
% mkdir('~/Data/bad_graphs/');
% 
% distribution.type = 'custom';
% params = [0,.3,.6,0,0,0,0,0,0,0,.1];
% distribution.params = size_bias(params);
% num = 1;
% for k = 3:6
%     for i = 1:20
%         num_nodes = 10^k;
%         adjacency_matrix = create_configuration_model(num_nodes,distribution);
%         flag = false;
%         try
%             pair = find_max_matching(adjacency_matrix,true,'vazirani');
%         catch
%             filename = strcat(...
%                 '~/Data/bad_graphs/matrix',...
%                 num2str(num),'.mat');
%             string = 'errored';
%             disp(string);
%             save(filename,'adjacency_matrix','string');
%             num = num+1;
%             flag = true;
%         end
%         if ~flag
%             [aug_path_exists,~] = check_for_aug_path(adjacency_matrix,pair);
%             if aug_path_exists
%                 filename = strcat(...
%                     '~/Data/bad_graphs/matrix',...
%                     num2str(num),'.mat');
%                 string = 'incomplete';
%                 disp(string);
%                 save(filename,'adjacency_matrix','string');
%                 num = num+1;
%             end
%             
%         end
%         
%     end
% end
% 
% 
% [aug_path_exists,aug_path] = check_for_aug_path(adjacency_matrix,pair);
% % %% where the problems at
% % clear
% %
% % disp('about to delete testing_matrices, you sure?');
% % pause;
% %
% % rmdir('~/Code/MinimaxProjectCode/testing_matrices','s');
% % mkdir('~/Code/MinimaxProjectCode/testing_matrices');
% %
% %
% % flag = false;
% % num = 1;
% % j = 0;
% %
% % while ~flag
% %     j = j+1;
% %     if j==100
% %         break
% %     end
% %     for k =  6
% %         distribution.type = 'custom';
% %         params = [0,.3,.6,0,0,0,0,0,0,0,.1];
% %         distribution.params = size_bias(params);
% %         num_nodes = 10^k;
% %         og_adjacency_matrix = create_configuration_model(num_nodes,distribution);
% %         og_pair = find_max_matching(og_adjacency_matrix,true,'vazirani');
% %         m_size = sum(og_pair<num_nodes+1);
% %         for i = 1:7
% %             P = randperm(num_nodes);
% %             adjacency_matrix = og_adjacency_matrix(P,P);
% %             err = false;
% %             try
% %                 pair = find_max_matching(adjacency_matrix,true,'vazirani');
% %             catch
% %                 disp('error occured')
% %                 err = true;
% %             end
% %             matching_size = sum(pair<num_nodes+1);
% %             if ~isequal(m_size,matching_size) || err
% %                 disp('matchings unequal');
% %                 save(strcat(...
% %                     '~/Code/MinimaxProjectCode/testing_matrices/matrix',...
% %                     num2str(num),'.mat'),'og_adjacency_matrix','adjacency_matrix','P');
% %                 num = num+1;
% %                 flag = true;
% %                 break
% %             end
% %
% %         end
% %
% %
% %         if flag
% %             break
% %         end
% %     end
% % end
% % beep;pause(1);beep;pause(1);beep
% % %%
% % distribution.type = 'custom';
% % params = [0,.3,.6,0,0,0,0,0,0,0,.1];
% % distribution.params = size_bias(params);
% % num_nodes = 10^5;
% % og_adjacency_matrix = create_configuration_model(num_nodes,distribution);
% % num_edges = sum(sum(og_adjacency_matrix));
% % og_pair = find_max_matching(og_adjacency_matrix,true,'vazirani');
% %
% % for i = 1:20
% %     pair = find_max_matching(og_adjacency_matrix,true,'vazirani');
% %     assert(all(pair==og_pair));
% %
% % end
% %
% % %% investigating the get edges from vertices function
% % %
% % % clear
% % %
% % % distribution.type = 'custom';
% % % params = [0,0,.9,0,0,0,0,0,0,0,.1];
% % % distribution.params = size_bias(params);
% % %
% % % times = zeros(1,7);
% % % for k = 1:7
% % %     tic;
% % %     num_nodes = 10^k;
% % %     adjacency_matrix = create_configuration_model(num_nodes, distribution);
% % %     pair = find_max_matching(adjacency_matrix);
% % %     times(k) = toc;
% % % end18692
% %
% % %%
% % % D = dir(['~/Code/MinimaxProjectCode/testing_matrices/', '\*.mat']);
% % % Num = length(D(not([D.isdir])));
% % %
% % % for i = 1: D
% % %     data = load(
% % %     adjacency_matrix =
% %
% %
