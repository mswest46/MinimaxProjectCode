function pair = find_max_matching(G,M) % G is adjacency_matrix, M is pair vector;

P = find_aug_path(G,M);
if ~isempty(P)
    pair = augment(G,pair);
    pair = find_max_matching(G,pair);
end
end