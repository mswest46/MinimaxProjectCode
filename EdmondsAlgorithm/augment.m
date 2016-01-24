function M = augment(G,M,P)

% augments matching M along path P

dummy = G.dummy;
num_nodes = G.num_nodes;
pair = M.pair;
for k = 1: length(P) - 1
    if mod(k,2) % i is odd
        pair(P(k)) = P(k+1);
        pair(P(k+1)) = P(k);
    end
end

exposed_vertices = find(pair==dummy);
matching_size = sum(pair<dummy)/2; % number of edges in matching;
M_edges = zeros(1,matching_size*2);
k = 0;
for i = 1: num_nodes
    if pair(i)<dummy
        k = k+1;
        M_edges(k) = G.get_e_from_vs(i,pair(i));
    end
end
M_edges = unique(M_edges);
M = struct('pair',pair,'edges',M_edges,...
    'exposed_vxs', exposed_vertices);
end