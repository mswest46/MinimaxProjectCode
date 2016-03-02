%%

% 1.

% A = zeros(4);
% pair = hopcroft_karp(A,'');

%%

% 2. 

clear; 
close all;

A = zeros(4);
rowSubs = [1,1,2,2,3,3,4,4];
colSubs = [3,4,3,4,1,2,1,2];
A(sub2ind(size(A), rowSubs, colSubs)) = 1;

pair = hopcroft_karp(A,'');

%%

