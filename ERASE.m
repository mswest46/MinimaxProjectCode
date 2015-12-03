function [erased, predecessors_count] = ERASE(...
    erased, aug_path, predecessors, predecessors_count)

% we input the aug_path. we want to call erase recursively, so that
% whenever we erase a vertex v, we decrement the predecessors_count of all
% vertices for which v is a predecessor of. if any of these predecessor
% counts, say for vertex u, go to zero, we erase u and repeat. Example: 2
% neighboring vxs, say u is predecessor of v, both have predecessor w. we
% erase 2, which sets predecessors_count(v) = 1, predecessors_count(u) = 0.
% So we erase u, which sets predecessors_count(v) = 0. so we erase(v).
% Another example: we have the v is also a predecessor of u in the previous
% example. Then neither u nor v gets erased.

queue = aug_path;
while ~isempty(queue)
    v = queue(end);
    queue = queue(1:end-1);
    erased(v) = true;
    v_is_predecessor_of = find(predecessors(v,:));
    for i = 1:length(v_is_predecessor_of)
        u = v_is_predecessor_of(i);
        predecessors_count(u) = predecessors_count(u) - 1;
        if predecessors_count(u) == 0 && ~erased(u)
            queue = [queue,u];
        end
        if predecessors_count(u) < 0
            error('something is not working the way you think it is')
        end
        
    end
end