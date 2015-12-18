% test_ERASE

% function erased = ERASE(aug_path,erase_struct)
% 
% pred_count = erase_struct.pred_count;
% successors = erase_struct.successors;
% erased = erase_struct.erased;

%%
% |
% |
% |
% |
% .

aug_path = 1;

pred_count = [0,1,1,1,1];
successors = {2,3,4,5,[]};
erased = false(1,5);

erase_struct = v2struct(pred_count,successors,erased);

erased = ERASE(aug_path, erase_struct);
assert(all(erased));

%%
%  |
%  |
%  |
%  .\


aug_path = 1;

pred_count = [0,0,2,1,1,1];
successors = {3,3,4,5,6,[]};
erased = false(1,6);

erase_struct = v2struct(pred_count,successors,erased);

erased = ERASE(aug_path, erase_struct);
assert(erased(1));
assert(all(~erased(2:end)));

%%
%  |
%  |
%  |
% . .


aug_path = [1,2];

pred_count = [0,0,2,1,1,1];
successors = {3,3,4,5,6,[]};
erased = false(1,6);

erase_struct = v2struct(pred_count,successors,erased);

erased = ERASE(aug_path, erase_struct);
assert(all(erased));


