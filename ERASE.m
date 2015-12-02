function [erased,available_edges, predecessors_count] = ERASE(...
    erased, aug_path, available_edges, predecessors_count)

erased(aug_path) = 1;

for i = 1:length(aug_path)
    v = aug_path(i);
    v_is_predecessor_of = logical(available_edges(v,:));
    predecessors_count((v_is_predecessor_of)) = ...
        predecessors_count(v_is_predecessor_of) - 1;
end
erased(predecessors_count == 0) = 1;
erased = logical(erased);

available_edges(erased,:) = 0;
available_edges(:,erased) = 0;