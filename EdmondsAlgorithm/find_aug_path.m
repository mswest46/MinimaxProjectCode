function P = find_aug_path(G,M)
num_edges = G.num_edges; num_nodes = G.num_nodes; dummy = G.dummy;
P = [];
marked_edges = spalloc(num_nodes,num_nodes,G.num_edges);
for i = 1:length(M.edges)
    [v,w] = G.get_vs_from_e(M.edges(i));
    marked_edges(v,w) = 1;
    marked_edges(w,v) = 1;
end

% marked_edges = false(1,num_edges); marked_edges(M.edges) = true;
marked_vxs = false(1,num_nodes);
exposed_vxs = M.exposed_vxs;
F = cell(1,length(exposed_vxs)); % each exposed vx has its own tree
root = zeros(1,length(exposed_vxs));
tree = zeros(1,num_nodes); % the tree number of the vxs.
distance = inf(1,num_nodes); % the distance of a vx from its tree root
index_in_tree = zeros(1,num_nodes);

for i = 1:length(exposed_vxs)
    v = exposed_vxs(i);
    root(i) = v;
    v = exposed_vxs(i);
    tree(v) = i;
    distance(v) = 0;
    index_in_tree(v) = 1;
    F{i} = 0; % the parent pointers of the tree.
    %     F{i}(v) = dummy;
    
end

v_options = find(tree & mod(distance,2)==0 & ~marked_vxs);
options_length = length(v_options);
options_distances = distance(v_options);
[~,indices] = sort(options_distances,'descend');
v_options = v_options(indices); % so v_options is sorted so that larger trees grow first.
v = [];
if ~isempty(v_options)
    option_index = 1;
    v = v_options(option_index);
    option_index = option_index+1;
end

% unmarked, in tree, even distance
% v = find(tree & mod(distance,2)==0 & ~marked_vxs, 1);

while ~isempty(v)
    neighbors = G.neighbors{v};
    unmarked_edge_exists = false;
    for i = 1:length(neighbors)
        w = neighbors(i);
%         e = G.get_e_from_vs(w,v);
        if ~marked_edges(w,v)
            unmarked_edge_exists = true;
            break
        end
    end
    
    while unmarked_edge_exists
        if ~tree(w) % new vx, add it to v's tree
            x = M.pair(w);
            distance([w,x]) = [1,2] + distance(v); % update distances
            index_in_tree([w,x]) = length(F{tree(v)}) + [1,2];
            F{tree(v)} = [F{tree(v)},v,w];
%             
%             F{tree(v)}([w,x]) = [v,w]; % add pair pointers
            tree([w,x]) = tree(v); % update tree membership
        elseif mod(distance(w),2)~=0;
            % if tree(w) ~= tree(v),
            % .-.~.e.-.~.-. % (u,w) and (w,x) are both unmatched, path
            % would not be alternating, so do nothing
            % if tree(w) = tree(v), even cycle created, can't contain
            % aug_path, so do nothing.
        else
            if tree(w) ~= tree(v)
                % we've discovered an augmenting path
                P = [flip(get_path(v,root(tree(v)),F{tree(v)},index_in_tree)),get_path(w,root(tree(w)),F{tree(w)},index_in_tree)];
                return;
            else
                
                
                % create blossom. I'm struggling to coordinate what B
                % should look like
                
                
                
                % Just for clarity, we'll have B running from other to b.
                % so b = B(end)
                B = discover_blossom(v,w,F{tree(v)},distance,index_in_tree);
                [G_prime, M_prime] = contract(G,M,B);
                P_prime = find_aug_path(G_prime, M_prime);
                P = lift(P_prime, G_prime, G, B, distance);
                
            end
        end
        % mark edge
        marked_edges(w,v) = 1;
        marked_edges(v,w) = 1;
        
        % look for new unmarked_edge;
        unmarked_edge_exists = false;
        for i = 1:length(neighbors)
            w = neighbors(i);
%             e = G.get_e_from_vs(w,v);
            if ~marked_edges(v,w)
                unmarked_edge_exists = true;
                break
            end
        end
        
    end
    marked_vxs(v) = true;
    
    % should output a v whcich is unmarked, in a tree, and even disance
    while marked_vxs(v)
        if option_index<=options_length
            v = v_options(option_index);
            option_index = option_index+1;
        else
            v_options = find(tree & mod(distance,2)==0 & ~marked_vxs);
            options_length = length(v_options);
            options_distances = distance(v_options);
            [~,indices] = sort(options_distances,'descend');
            v_options = v_options(indices); % so v_options is sorted so that larger trees grow first.
            
            option_index = 1;
            if isempty(v_options)
                v = [];
                break
            end
        end
    end
    
    
    
    %
    %
    %
    %     v = find(tree & mod(distance,2)==0 & ~marked_vxs, 1); % find new v
end
end


function path = get_path(top,bottom,tree,index_in_tree)
% returns an array representing a path from the top vx to the bottom vx.

v = top;
path = top;
while v~=bottom
    v = tree(index_in_tree(v)); % the parent of v.
    path = [path,v];
end

end

function blossom = discover_blossom(left,right,tree,distance,index_in_tree)

left_part = left;
right_part = right;

while left~=right
    if distance(left)>distance(right)
        left = tree(index_in_tree(left));
        left_part = [left_part,left];
        % drop left
    else
        right = tree(index_in_tree(right));
        right_part = [right_part,right];
        % drop right
    end
end

left_part(end) = [];
blossom = [flip(left_part),right_part];


end




