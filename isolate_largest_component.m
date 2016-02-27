function [C,numNodes] = isolate_largest_component(A)

% accepts an adjacency matrix A, finds its largest component, and output C,
% the adjacency matrix for that component along and numNodes, the size of
% that component. 

addpath('~/Code/BrainConnectivityToolbox/');
[components, comp_sizes] = get_components(A);
[numNodes,I] = max(comp_sizes);
C = A(components==I,components==I);

end