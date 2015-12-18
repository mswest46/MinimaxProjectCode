function [erased, pred_count] = ERASE(aug_path,erase_struct)

pred_count = erase_struct.pred_count;
successors = erase_struct.successors;
erased = erase_struct.erased;
queue = aug_path;
while ~isempty(queue)
    o = queue(end);

    queue = queue(1:end-1);
    erased(o) = true;
    for w = successors{o}
        if ~erased(w)
            pred_count(w) = pred_count(w) - 1;
            if pred_count(w) == 0
                queue = [queue,w];
            end
        end
    end
end
end
