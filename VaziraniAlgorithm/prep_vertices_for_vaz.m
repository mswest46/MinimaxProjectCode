function vertices = prep_vertices_for_vaz(num_nodes, pair)

% creates a struct that has all the relevant tags and attributes for use in
% vazirani.


pair = num2cell(pair);
erased = num2cell(false(1,num_nodes));
ownership = num2cell(zeros(1,num_nodes));
ancestors = cell(1,num_nodes);
predecessors = cell(1,num_nodes);
left_parent = num2cell(zeros(1,num_nodes));
right_parent = left_parent;
findpath_parent = left_parent;
pred_count = num2cell(zeros(1,num_nodes));


vertices = struct('pair',pair,'erased',erased,'ownership',ownership,...
    'left_parent',left_parent,'right_parent',right_parent,...
    'findpath_parent',findpath_parent,'pred_count',pred_count);
% vertices = struct('pair', pair,'erased',erased,'odd_level', ...
%     odd_level,'even_level',even_level,'neighbors',neighbors,... 
%     'successors',successors,'predecessors',predecessors,'bloom', bloom,...
%      'left_parent',left_parent,...
%     'right_parent',right_parent,'ownership',ownership);
end