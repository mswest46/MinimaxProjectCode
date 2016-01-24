function M = edmonds_matching(G,M,initial) % G is adjacency_matrix, M is pair vector;

if ~exist('initial','var')
    initial = true;
    addpath('~/Code/MinimaxProjectCode/')
end

dispstat('','init');
if initial
    % call is from outside find_max_matching, so we assume is called with M
    % just the pair vector, and G is just an adjacency_matrix
    
    G = create_graph_struct_from_adjacency_matrix(G);
    
    dummy = G.dummy;
    num_nodes = G.num_nodes;
    if isempty(M)
        pair = dummy*ones(1,num_nodes);
    else
        pair = M;
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

assert(isequal(length(fieldnames(M)),3));

P = find_aug_path(G,M);

if ~isempty(P)
    M = augment(G,M,P);
    dummy = G.dummy;
    num_nodes = G.num_nodes;
    matching_size = sum(M.pair<dummy)/2;
    %     dispstat([num2str(200*matching_size/num_nodes),...
    %         '% of nodes matched'])
    M = edmonds_matching(G,M,false);
end

if initial
    matching_size = sum(M.pair<dummy)/2;
    M = M.pair;
    dispstat(['max matching found with', num2str(200*matching_size/num_nodes),...
        '% of nodes matched'],'keepthis');
    return
end

end