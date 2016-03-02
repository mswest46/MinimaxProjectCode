%%

% 1. 

clear; 
close all;


A = ones(4);
A(eye(4)) = 0;
pair = hopcroft_karp(A,'');

%%

