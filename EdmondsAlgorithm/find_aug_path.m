function P = find_aug_path(G,M)
marked_edges = false(num_edges); marked_edges(M.edges) = true;
marked_vxs = false(num_nodes);
exposed_vxs = M.exposed_vxs;
F = cell(1,length(exposed_vxs));
root = zeros(1,length(exposed_vxs));
tree = zeros(1,num_nodes); % the tree number of the vxs.
distance = zeros(1,num_nodes);

for i = 1:length(exposed_vxs)
    root(i) = v;
    v = exposed_vxs(i);
    tree(v) = i;
    distance(v) = 0;
    % F{i} is a tree with single vertex v.
end

v = find(tree & mod(distance,2)==0 & ~marked_vxs, 1);

while ~isempty(v)
    T = tree(v); % the tree number of v.
    neighbors = G.neighbors;
    unmarked_edge_exists = false;
    for i = 1:length(neighbors{v})
        w = neighbors{v}(i);
        e = G.get_e_from_vs(w,v);
        if ~marked_edges(e)
            unmarked_edge_exists = true;
            break
        end
    end
    
    while unmarked_edge_exists
        if ~tree(w) % new vx, add it to v's tree
            x = M.pair(w);
            F{T}([w,x]) = [v,w]; % add pair pointers
            tree([w,x]) = T; % update tree membership
            distance([w,x]) = [1,2] + distance(v); % update distances
        elseif mod(distance(w),2)~=0;
        else
            if tree(w) ~= tree(v)
                P = [flip(get_path(v,root,F{tree(v)})),get_path(w,root,F{tree(w)})];
                return;
            else
                B = get_path(v,w,F{tree(v)});
                [G_prime, M_prime] = contract(G,M,B);
                P_prime = find_aug_path(G_prime, M_prime);
                if any(P_prime == w)
                    P = lift(P_prime, G_prime, G);
                else 
                    P = P_prime;
                end
            end
            
            % create blossom
        end
        % mark edge
        marked_edges(e) = true;
        
        % look for new unmarked_edge;
        unmarked_edge_exists = false;
        for i = 1:length(neighbors{v})
            w = neighbors{v}(i);
            e = G.get_e_from_vs(w,v);
            if ~marked_edges(e)
                unmarked_edge_exists = true;
                break
            end
        end
        
    end
    marked_edges(v) = true;
    v = find(tree & mod(distance,2)==0 & ~marked_vxs, 1); % find new v
end
end










