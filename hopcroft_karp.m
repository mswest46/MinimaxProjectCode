

%% Function Hopcroft - Karp

% % input should be a graph struct, with an adjacency matrix and part1,
% part2, the indices of the vxs in parts of the bipartite graph
% function matching = hopcroft_karp(graph);
% graph.adjacency_matrix = adjacency_matrix
% graph.matching_matrix = zeros(size(adjacency_matrix));
% graph.antimatching_matrix = graph.adjacency_matrix ...
%   - graph.matching_matrix;
% graph.layers = nan(1,nNodes);
% while size(graph.layers)>1 % so there are at least some vxs in layer 0
%   graph.layers = BFS(graph);
%   


%% Breadth First Search
% function layers = BFS(graph)
% adds the layers to the graph struct

% for u in graph.part1
%   if isempty(find(graph.matching_matrix(u,:)))
%       layers(u) = 0
%       queue = [queue, u]
%   end
% while ~isempty(queue)
%   u = queue(end);
%   queue = queue(1:end-1);
%   for v in find(graph.adjacency_matrix(u,:)) % indices of u's neighbors
%       if isnan(layers(v)) % else we've already done this
%           layers(v) = layers(u) + 1; 
%           if isnan(pair(v));
%               stop = true 
% %we've reached a free vx. need to finish the layer tho
%               
%           else 
%               pair(v) = layers(u)+2;
%               queue = [queue, pair(v)];
%           end
%       end
%   end
% stop = false
% while ~stop
%   i = i+1;
%   if (mod(i,2) == 1)
%       for vx = layer(i-1) 
%           unmatched_vx_neighbors = find(graph.antimatching_matrix(:,vx));
%           if isempty(unmatched_vs_neighbors) %reached a free vx in part2
%               stop = true;
%           else layer(i) = [layer(i),...
%               unmatched_vx_neighbors);
%       end
%   
%   else
%       for vx = layer(i-1)
%           layer(i) = [layer(i),...
%               find(graph.matching_matrix(:,vx));
%       end
%   end
% end
% 
%% Depth First Search (of u)
% function bool = DFS(graph, u)
% u needs to have its layer specified
% if u.layer==0
%   bool = true;
% else 
%   for v = find(graph.adjacency_matrix(:,u))
%       if (v.layer == u.layer-1 && DFS(graph,v) == true)
%           bool = true
%           graph.matching(
%           add to augpaths and mark as 'used'
%   return false
% end
