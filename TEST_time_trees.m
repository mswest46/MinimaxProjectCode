clear all;

dist1.type = 'constant';
dist1.params = 2;
dist2.type = 'uniform';
dist2.params = [0,1];


create_tree(20,dist1,dist2,false);

% times = zeros(1,6);
% for i = 10:2:20
%     tic 
%     
%     for j = 1:10
%         create_tree(i, dist1,dist2,false);
%     end
%     
%     times(i)=toc;
% end
% 
%         
