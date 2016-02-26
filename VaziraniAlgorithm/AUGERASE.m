function [vertices,aug_path] = ...
    AUGERASE(aug_erase_struct,vertices)

% unpack aug_erase_struct. TODO clean this up. 
assert(length(fieldnames(aug_erase_struct))==13);
graph = aug_erase_struct.graph;
successors = aug_erase_struct.successors;
init_left = aug_erase_struct.init_left;
init_right = aug_erase_struct.init_right;
final_left = aug_erase_struct.final_left;
final_right = aug_erase_struct.final_right;
even_level = aug_erase_struct.even_level;
odd_level = aug_erase_struct.odd_level;
bloom = aug_erase_struct.bloom;
base = aug_erase_struct.base;
left_peak = aug_erase_struct.left_peak;
right_peak = aug_erase_struct.right_peak;
predecessors = aug_erase_struct.predecessors;


% packing find_path_struct.
find_path_struct.graph = graph;
find_path_struct.vertices = vertices;
% find_path_struct.pair = pair;
find_path_struct.even_level = even_level;
find_path_struct.odd_level = odd_level;
find_path_struct.bloom = bloom;
find_path_struct.base = base;
find_path_struct.left_peak = left_peak;
find_path_struct.right_peak = right_peak;
find_path_struct.predecessors = predecessors;

% find augmenting path. 
left_path = FINDPATH(init_left,final_left, nan, find_path_struct); 
right_path = FINDPATH(init_right,final_right, nan, find_path_struct);
aug_path = [flip(right_path),left_path];
% 
% check_path_is_along_edges(graph,path);

% augment matching in pair.
% vertices = AUGMENT(graph,aug_path,vertices);

% for k = 1: length(aug_path) - 1
%     if mod(k,2) % i is odd
%         pair(aug_path(k)) = aug_path(k+1);
%         pair(aug_path(k+1)) = aug_path(k);
%     end
% end

% check_pair_is_matching(graph.adjacency_matrix,pair);

% % pack erase_struct. 
% erase_struct.pred_count = pred_count;
% erase_struct.successors = successors;
% erase affected vertices. 
% [pred_count,vertices] = ERASE(aug_path,erase_struct,vertices);

% queue = aug_path;
% while ~isempty(queue)
%     o = queue(end);
%     queue = queue(1:end-1);
%     erased(o) = true;
%     for w = successors{o}
%         if ~erased(w)
%             pred_count(w) = pred_count(w) - 1;
%             if pred_count(w) == 0
%                 queue = [queue,w];
%             end
%         end
%     end
% end
end


% TODO speed this up. 
function vertices = AUGMENT(G,aug_path,vertices)
for k = 1: length(aug_path) - 1
    if mod(k,2) % i is odd
        vertices(aug_path(k)).pair = aug_path(k+1);
        vertices(aug_path(k+1)).pair = aug_path(k);
%         
%         pair(aug_path(k)) = aug_path(k+1);
%         pair(aug_path(k+1)) = aug_path(k);
%         if isempty(G.get_e_from_vs(aug_path(k),aug_path(k+1)))
%             1;
%         end
    end
end
end