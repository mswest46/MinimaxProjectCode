function [matching_size, matching_matrix, pair] = hopcroft_karp_with_plot(adjacency_matrix, xy)

graph.adjacency_matrix = adjacency_matrix;

if ~(isfield(graph, 'part1') && isfield(graph, 'part2'))
    [graph.part1, graph.part2] = bipartition(adjacency_matrix);
end

if nargin == 2
    % set graph_bool
    graph_bool = 1;
else
    graph_bool = 0;
end

graph.graph_bool = graph_bool;
graph.num_nodes = length(graph.adjacency_matrix(:,1));

if graph_bool
    node_labels = [];
    for i = 1:graph.num_nodes
        node_labels = [node_labels; num2str(i)];
    end
    node_labels = cellstr(node_labels);
    
    graph.xy = xy;
    a = 1:length(graph.adjacency_matrix(:,1));
    %     label_handle = text(xy(:,1)+.05,xy(:,2),cellstr(num2str(a(:))));
    hold on;
    gplot(adjacency_matrix,xy,'-*b');
    axis([min(xy(:,1))-.25, max(xy(:,1))+.25, min(xy(:,2))-.25, max(xy(:,2))+.25]);
    
    
    pause;
end

graph.num_nodes = length(graph.adjacency_matrix(:,1));

% an extra vx which will attach to end of minimal augmenting paths
graph.dummy = graph.num_nodes + 1;

graph.pair = graph.dummy*ones(1,graph.num_nodes); %everything starts paired with dummy
count = 0;

while true
    [graph.layer, bool] = BFS(graph);
    if ~bool % no aug paths left
        break
    end
    for u = graph.part1
        if (graph.pair(u)==graph.dummy) %i.e. if u is free
            [bool,pair,layer,aug_path] = DFS(graph,u);
            1;
            if bool % i.e. if u in aug path
                graph.pair = pair; % change the matching
                graph.layer = layer; % update the layers
                matching = [1:graph.num_nodes; graph.pair];
                matching = matching(:,(matching(2,:)<graph.dummy));
                matching_matrix = sparse(matching(1,:),matching(2,:),1,graph.num_nodes,graph.num_nodes);
                aug_path_matrix = zeros(size(matching_matrix));
                for i = 1:length(aug_path)-1
                    aug_path_matrix(aug_path(i),aug_path(i+1))=1;
                end
                
                if graph_bool
                    hold on;
                    
                    gplot(adjacency_matrix,xy,'-*b');
                    gplot(aug_path_matrix,xy,'-g');
                    pause(.1);
                    
                    gplot(matching_matrix,xy,'-.r');
                    pause
                end
                
                
                
            end
        end
    end
end
1;
matching = graph.pair;
pair = graph.pair;
matching = [1:graph.num_nodes; matching];

matching = matching(:,(matching(2,:)<graph.dummy));
matching_matrix = sparse(matching(1,:),matching(2,:),1,graph.num_nodes,graph.num_nodes);
if any(sum(matching_matrix,1)>1)
    error('this aint a matching');
end

matching_size = length(matching(1,:));

if graph_bool
    hold on;
    gplot(adjacency_matrix,xy,'-*b');
    gplot(matching_matrix,xy,'-.y');
    text(xy(:,1)'+.05,xy(:,2)',node_labels);
    1;
end

% matching_matrix = zeros(graph.num_nodes);
%
% mat
%
% for i = 1:graph.num_nodes
%     if matching(i)<graph.dummy
%         matching_matrix(i,matching(i)) = 1;
%         matching_matrix(matching(i),i) = 1;
%     end
% end
% matching_size = sum(matching<graph.dummy)/2;


end


function [layer, bool] = BFS(graph)
dummy = graph.dummy;
% queue = zeros(1,graph.num_nodes);
queue = [];
qSpot = 0;
layer = nan(1,graph.num_nodes);
count = 1;
for u = graph.part1
    count = count+1;
    if graph.pair(u)==dummy
        %         qSpot = qSpot+1;
        layer(u) = 0;
        %         queue(qSpot) = u;
        queue = [queue,u];
        % put the free vxs of part1 in queue and give layer 0
    else layer(u) = inf;
        % otherwise not in layer
    end
    
    %     if graph.graph_bool
    %         str = num2str(layer(u));
    %         h(count) = text(graph.xy(u,1)+.1,graph.xy(u,2),str);
    %         pause(.3);
    %     end
    
end
% if graph.graph_bool
%
%     delete(h);
% end

layer(dummy) = inf;

% while qSpot>0
while ~isempty(queue)
    %     u = queue(qSpot);
    %     qSpot = qSpot - 1;
    u = queue(end); % pop u
    queue = queue(1:end-1);
    if layer(u) < layer(dummy) % if we haven't hit dummy yet. if we've hit dummy we've found minimal aug paths already
        neighbors = find(graph.adjacency_matrix(:,u));
        for i = 1:length(neighbors);
            v = neighbors(i);
            if layer(graph.pair(v)) == inf % v's pair not hit yet
                layer(graph.pair(v)) = layer(u) + 1;
                %                 n = length(graph.pair(v));
                %                 queue(qSpot+1: qSpot+n) = graph.pair(v);
                %                 qSpot = qSpot + n;
                queue = [queue, graph.pair(v)];
                % eventually we will have v's pair be dummy, in wich
                % case we have an aug path from a free vx in u to a
                % free vx in v with length 2*layer(dummy) - 1.
            end
        end
    end
end
bool = ~(layer(dummy)==inf); % if layer(dummy)=inf then every neighbor of every u in our queue is in the matching.
end


function [bool,pair,layer,aug_path] = DFS(graph,u)% answers the question, is this in a an aug path and if yes

aug_path = 0;
pair = graph.pair;
layer = graph.layer;
if ~(u == graph.dummy)
    u_neighbors = find(graph.adjacency_matrix(:,u));
    for i = 1:length(u_neighbors);
        v = u_neighbors(i);
        if (layer(pair(v)) == layer(u)+1)
            [inner_bool, pair, layer, aug_path] = DFS(graph,pair(v));
            if  inner_bool; % make sure we're on the right layer, because we switch pairs every so often
                aug_path = [u,v,aug_path];
                pair(v) = u;
                pair(u) = v;
                bool = true;
                return
            end
        end
    end
    layer(u) = inf; % remove this from the set of vxs for other paths
    bool = false; % if no neighbor of u completes the aug path.
    return
else
    aug_path = [];
    bool = true; % we're at the dummy vx
end

end


