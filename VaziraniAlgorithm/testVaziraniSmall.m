%% 1

clear

A = zeros(12);
rowSubs = [1,2,2,3,3,3,4,4,5,5,5 ,6,6,7,7,8,9,9 ,10,10,11,11,12,12];
colSubs = [2,1,3,2,4,5,3,6,3,7,12,4,7,6,5,9,8,10,9 ,11,10,12,11,5 ];
A(sub2ind(size(A), rowSubs, colSubs)) = 1;

pair = [13,3,2,6,7,4,5,13,10,9,12,11];
level = [0,1,2,3,3,4,4,0,1,2,3,4];
close all
plot_matching(A,level,pair,'');

pair = vaziraniMatching(A, pair,true);
assert(isequal(pair, [2,1,4,3,12,7,6,9,8,11,10,5]));

%%
% 2
clear

A = zeros(8);
rowSubs = [1,1,2,2,3,3,3,4,4,5,5,6,6,7,7,8];
colSubs = [2,3,1,3,1,2,4,3,5,4,6,5,7,6,8,7];
A(sub2ind(size(A), rowSubs, colSubs)) = 1;
pair = [9,3,2,5,4,7,6,9];
level = [0,1,1,3,3,2,1,0];
close all
plot_matching(A,level,pair,'');

pair = vaziraniMatching(A, pair,true);
assert(isequal(pair, [2,1,4,3,6,5,8,7]));

%% 
% 3
clear

A = zeros(20);
rowSubs = [1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,8,9,9,9,10,10,10,...
    11,11,11,12,12,12,13,13,14,14,14,15,15,16,17,17,18,18,19,19,20,20];
colSubs = [2,1,3,2,4,3,5,4,6,5,7,6,8,7,9,12,8,10,11,9,11,17,9,10,...
    12,8,11,13,12,14,13,15,20,14,16,15,10,18,17,19,18,20,14,19];
assert(length(rowSubs)==length(colSubs));
A(sub2ind(size(A), rowSubs, colSubs)) = 1;
assert(issymmetric(A));

level = [0,1,2,3,4,5,6,5,6,6,5,4,3,2,1,0,6,5,4,3];
assert(length(level)==20);
pair = [21,3,2,5,4,7,6,9,8,11,10,13,12,15,14,21,18,17,20,19];
assert(length(pair)==20);
close all
plot_matching(A,level,pair,'');

expectPair = [2,1,4,3,6,5,8,7,10,9,12,11,14,13,16,15,18,17,20,19];
assert(length(expectPair) == 20);
newPair = vaziraniMatching(A, pair,true);
assert(isequal(newPair, expectPair));
%%
%4 Same as above, only 9 and 17 switch to see if blooms behave correctly. 
clear

A = zeros(20);
rowSubs = [1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,8,17,17,17,10,10,10,...
    11,11,11,12,12,12,13,13,14,14,14,15,15,16,9,9,18,18,19,19,20,20];
colSubs = [2,1,3,2,4,3,5,4,6,5,7,6,8,7,17,12,8,10,11,17,11,9,17,10,...
    12,8,11,13,12,14,13,15,20,14,16,15,10,18,9,19,18,20,14,19];
assert(length(rowSubs)==length(colSubs));
A(sub2ind(size(A), rowSubs, colSubs)) = 1;
assert(issymmetric(A));

level = [0,1,2,3,4,5,6,5,6,6,5,4,3,2,1,0,6,5,4,3];
assert(length(level)==20);
pair = [21,3,2,5,4,7,6,17,18,11,10,13,12,15,14,21,8,9,20,19];
assert(length(pair)==20);
close all
plot_matching(A,level,pair,'');

expectPair = [2,1,4,3,6,5,8,7,18,17,12,11,14,13,16,15,10,9,20,19];
assert(length(expectPair) == 20);
newPair = vaziraniMatching(A, pair,true);
assert(isequal(newPair, expectPair));


%% 
% 5. (dreidle) Case where DDFS is looking at a bridge whose endpoints both belong to
% blooms with same base. 

A = zeros(7);

rowSubs = [1,1,1,2,2,3,3,4,4,5,5,5,6,6,6,7,7,7];
colSubs = [2,3,4,1,5,1,6,1,7,2,6,7,3,5,7,4,5,6];
A(sub2ind(size(A), rowSubs, colSubs)) = 1;
assert(issymmetric(A));

pair = [8,5,6,7,2,3,4];
newPair = vaziraniMatching(A, pair,true);
assert(isequal(pair,newPair));


%% 
% 6.
A = zeros(7);
rowSubs = [1,1,1,2,2,3,3,4,4,4,5,5,6,6,7,7];
colSubs = [2,4,7,1,3,2,4,1,3,5,4,6,5,7,1,6];
A(sub2ind(size(A), rowSubs, colSubs)) = 1;
assert(issymmetric(A));

pair = [8,3,2,5,4,7,6];
level = [0,1,2,1,2,2,1];
close all
plot_matching(A,level,pair,'');

newPair = vaziraniMatching(A, pair,true);
assert(isequal(pair,newPair));

%% 
% 7. 

clear

A = zeros(28);
rowSubs = [1,1,2,2,3,3,3,4,4,5,5,5,5,6,6,7,7,7,8,8,9,9,10,10,10,11,11,...
    12,12,13,13,14,14,15,15,16,16,17,17,18,18,19,19,20,20,21,21,22,22,...
    23,23,24,24,25,25,26,26,27,27,28];
colSubs = [2,14,1,3,2,4,15,3,5,4,6,9,10,5,7,6,8,20,7,9,5,8,5,11,19,10,...
    12,11,13,12,14,1,13,3,16,15,17,16,18,17,19,10,18,7,21,20,22,21,23,...
    22,24,23,25,24,26,25,27,26,28,27];
A(sub2ind(size(A), rowSubs, colSubs)) = 1;
assert(issymmetric(A));


pair = [29,3,2,5,4,7,6,9,8,19,12,11,14,13,16,15,18,17,10,21,20,23,22,25,24,27,26,29];
assert(length(pair)==28);
level = [0,1,2,3,4,5,6,6,5,5,4,3,2,1,3,4,5,6,6,7,7,6,5,4,3,2,1,0];
close all
plot_matching(A,level,pair,'');


newPair = vaziraniMatching(A, pair, true);


figure;
plot_matching(A,level,newPair,'');

assert(isequal([2,1,4,3,6,5,20,9,8,19,12,11,14,13,16,15,18,17,10,7,22,21,24,23,26,25,28,27],newPair));

%%
% 8. Case without augmentation 

A = zeros(6);
rowSubs = [1,1,2,2,3,3,4,4,5,5,6,6];
colSubs = [2,3,1,3,1,2,5,6,4,6,4,5];
A(sub2ind(size(A), rowSubs, colSubs)) = 1;
assert(issymmetric(A));

pair = [2,1,7,5,4,7];
newPair = vaziraniMatching(A,pair);
assert(isequal(pair,newPair));







