
params = [0,0,.5,0,.5]; 
biased_params = size_bias(params);
assert(isequal(biased_params,[0,0,1/3,0,2/3]));
