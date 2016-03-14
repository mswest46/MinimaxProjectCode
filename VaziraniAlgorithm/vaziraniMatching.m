function pair = vaziraniMatching(A,pair,debugBool)

if nargin < 3
    debugBool = false;
end
dispstat('','init');

numNodes = length(A(:,1));
dummy = numNodes +1;
if nargin<2 || isempty(pair)
    pair = dummy*ones(1,numNodes);
end
G = prepForVaz(A,pair);
augOccurred = true; % not really, just to get things started.
while augOccurred;
    [G,augOccurred] = SEARCH(G,debugBool);
    pair = [G.vertices.pair];
    matchingSize = sum(pair<dummy);
    dispstat([num2str(floor(100*matchingSize/numNodes)),...
        '% of nodes matched']);
    
    % for graphs with near perfect matching but with an odd number of
    % vertices, we are spending a lot of time create an alterating tree
    % in the last phase of search, even though we already know that no
    % augmenting path exists. So we can just call the whole thing off
    % here. Bit of a hack but justified.
    if matchingSize == numNodes || matchingSize == numNodes - 1
        return;
        
    end
end