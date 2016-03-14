function G = prepForVaz(A,pair)

numNodes = length(A(:,1));
dummy = numNodes+1;
temp = triu(A,1);
edgeIndices = find(temp);
numEdges = length(edgeIndices);
[rowS,colS] = ind2sub([numNodes,numNodes],edgeIndices);
incNodes = [rowS,colS];
incNodes = mat2cell(incNodes,ones(1,numEdges))';
indexInA = num2cell(edgeIndices');
[rowSubs, colSubs] = ind2sub(size(A),edgeIndices);
% newA is upper triangular. All edges appear once with their ID numbers. 
newA = sparse(rowSubs,colSubs,1:numEdges,numNodes,numNodes);
assert(isequal(triu(A)>0,newA>0))

pair = num2cell(pair);
neighbors = cell(1,numNodes);
for i = 1:numNodes
    neighbors{i} = find(A(:,i))';
end
f = num2cell(false(1,numNodes));


    
G.edges = struct('incidentNodes', incNodes, 'indexInA',indexInA);
G.vertices = struct('pair',pair,'neighbors',neighbors,'erased',f);
G.A = newA;
G.info = struct('numNodes',numNodes,'numEdges',numEdges,'dummy',dummy);

end
