function my_tree_plot(parent)

% puts parent into plottalbe form and plots.

a = find(parent>0); % vxs with parents;
b = parent(a); % the parents; 

% root is in parent with zero entry. every other vx in parent has a parent,
% so is in a. 
root = setdiff(b,a);
a = [a,root]; % vxs in the tree;
n = length(a); % number of vertices;
new_parent = zeros(1,n);
for i = 1: n - 1
    z = find(a==b(i),1); % index in a of the parent of a(i)
    new_parent(i) = z;
end

leaves = setdiff(a,b);
disp(leaves);
treeplot(new_parent);

