function [erased, pair, pred_count] = ...
    AUGERASE(aug_erase_struct)


assert(length(fieldnames(aug_erase_struct))==17);
graph = aug_erase_struct.graph;
pair = aug_erase_struct.pair;
erased = aug_erase_struct.erased;
pred_count = aug_erase_struct.pred_count;
successors = aug_erase_struct.successors;
init_left = aug_erase_struct.init_left;
init_right = aug_erase_struct.init_right;
final_left = aug_erase_struct.final_left;
final_right = aug_erase_struct.final_right;
level = aug_erase_struct.level;
ownership = aug_erase_struct.ownership;
bloom = aug_erase_struct.bloom;
base = aug_erase_struct.base;
left_peak = aug_erase_struct.left_peak;
right_peak = aug_erase_struct.right_peak;
bloom_ownership = aug_erase_struct.bloom_ownership;
predecessors = aug_erase_struct.predecessors;


if ischar(aug_erase_struct) && strcmp(aug_erase_struct, '-getSubHandles')
    erased = @AUGMENT;
    return
end


find_path_struct = v2struct(graph,erased,level,ownership,bloom,base, ...
    left_peak,right_peak,bloom_ownership,predecessors);

if init_left==5
    1;
end
left_path = FINDPATH(init_left,final_left, nan, find_path_struct); 
right_path = FINDPATH(init_right,final_right, nan, find_path_struct);
aug_path = [flip(right_path),left_path];


% augment matching in pair.
pair = AUGMENT(aug_path,pair);


erase_struct = v2struct(erased, pred_count, successors);
[erased,pred_count] = ERASE(aug_path,erase_struct);

end


function pair = AUGMENT(aug_path,pair)

% augment matching in pair.
for k = 1: length(aug_path) - 1
    if mod(k,2) % i is odd
        pair(aug_path(k)) = aug_path(k+1);
        pair(aug_path(k+1)) = aug_path(k);
    end
end

end