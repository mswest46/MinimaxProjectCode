function [matching_size, matching_matrix] = hopcroft_karp(adjacency_matrix)

graph.adjacency_matrix = adjacency_matrix;

if ~(isfield(graph, 'part1') && isfield(graph, 'part2'))
    [graph.part1, graph.part2] = bipartition(adjacency_matrix);
end
graph.nNodes = length(graph.adjacency_matrix(:,1));

% an extra vx which will attach to end of minimal augmenting paths
graph.dummy = graph.nNodes + 1;

graph.pair = graph.dummy*ones(1,graph.nNodes); %everything starts paired with dummy

while true
    [graph.layer, bool] = BFS(graph);
    1;
    if ~bool % no aug paths left
        break
    end
    for u = graph.part1
        1;
        if (graph.pair(u)==graph.dummy)
            [bool,pair,layer] = DFS(graph,u);
            if bool % i.e. if u in aug path
                graph.pair = pair; % change the matching
                graph.layer = layer; % update the layers
            end
        end
    end
end
1;
matching = graph.pair;
matching = [1:graph.nNodes; matching];

matching = matching(:,(matching(2,:)<graph.dummy));
matching_matrix = sparse(matching(1,:),matching(2,:),1,graph.nNodes,graph.nNodes);
matching_size = length(matching(1,:));
% matching_matrix = zeros(graph.nNodes);
%
% mat
%
% for i = 1:graph.nNodes
%     if matching(i)<graph.dummy
%         matching_matrix(i,matching(i)) = 1;
%         matching_matrix(matching(i),i) = 1;
%     end
% end
% matching_size = sum(matching<graph.dummy)/2;


end


function [layer, bool] = BFS(graph)
dummy = graph.dummy;
queue = zeros(1,graph.nNodes);
qSpot = 0;
layer = nan(1,graph.nNodes);
for u = graph.part1
    1;
    if graph.pair(u)==dummy
        qSpot = qSpot+1;
        layer(u) = 0;
        queue(qSpot) = u;
        % put the free vxs of part1 in queue and give layer 0
    else layer(u) = inf;
        % otherwise not in layer
    end
end

layer(dummy) = inf;

while qSpot>0
    %     while ~isempty(queue)
    u = queue(qSpot);
    qSpot = qSpot - 1;
    %         u = queue(end); % pop u
    %         queue = queue(1:end-1);
    if layer(u) < layer(dummy) % if we haven't hit dummy yet. if we've hit dummy we've found minimal aug paths already
        for v=find(graph.adjacency_matrix(:,u)) % u's neighbors
            if layer(graph.pair(v)) == inf % v's pair not hit yet
                layer(graph.pair(v)) = layer(u) + 1;
                n = length(graph.pair(v));
                queue(qSpot+1: qSpot+n) = graph.pair(v);
                qSpot = qSpot + n;
                %                     queue = [queue, graph.pair(v)];
                % eventually we will have v's pair be dummy, in wich
                % case we have an aug path from a free vx in u to a
                % free vx in v with length 2*layer(dummy) - 1.
            end
        end
    end
end
bool = ~(layer(dummy)==inf); % if layer(dummy)=inf then every neighbor of every u in our queue is in the matching.
end


function [bool,pair,layer] = DFS(graph,u)% answers the question, is this in a an aug path and if yes

pair = graph.pair;
layer = graph.layer;
if ~(u == graph.dummy)
    u_neighbors = find(graph.adjacency_matrix(:,u));
    for i = 1:length(u_neighbors);
        v = u_neighbors(i);
        if (layer(pair(v)) == layer(u)+1)
            [inner_bool, pair, layer] = DFS(graph,pair(v));
            if  inner_bool; % make sure we're on the right layer, because we switch pairs every so often
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
    bool = true; % we're at the dummy vx
end

end

function  [part1,part2] = bipartition(adjacency_matrix)
nNodes = length(adjacency_matrix);
partsArray = -1*ones(1,nNodes);
partsArray(1) = 0;
queue = 1;
count = 1;
while ~isempty(queue) || (count<nNodes)
    if isempty(queue)
        u = find(partsArray==-1,1);
        queue = u;
        partsArray(u) = 0;
        count = count + 1;
    end
    u = queue(end);
    queue = queue(1:end-1);
    neighbors = find(adjacency_matrix(:,u));
    for i = 1:length(neighbors);
        v = neighbors(i);
        if partsArray(v) < 0
            partsArray(v) = 1 - partsArray(u);
            count = count+1;
            queue = [queue, v];
        elseif partsArray(v) == partsArray(u)
            error('this graph is not bipartite');
        end
    end
end

1;

part1=find(partsArray==0);
part2=find(partsArray==1);
end



