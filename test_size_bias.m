%% test_size_bias 
clear

params = [1]; 
biased_params = size_bias(params);
assert(isequal(biased_params,[0,1]))

%%

params = [0,1]; 
biased_params = size_bias(params);
assert(isequal(biased_params,[0,0,1]))
%%

params = [0,0,1]; 
biased_params = size_bias(params);
assert(isequal(biased_params,[0,0,0,1]));
%%

params = [1/2,1/2]; 
biased_params = size_bias(params);
assert(isequal(biased_params,[0,2/3,1/3]));

%%


params = [1/2,0,1/2]; 
biased_params = size_bias(params);
assert(isequal(biased_params,[0,3/4,0,1/4]));

%%

params = [0,1/2,1/2]; 
biased_params = size_bias(params);
diff = biased_params-[0,0,.6,.4];
assert(sum(diff)<10^-10);

%%

params = [1/3,1/3,1/3];
biased_params = size_bias(params);
diff = biased_params - [0,6/11,3/11,2/11];
assert(sum(diff)<10^-10);