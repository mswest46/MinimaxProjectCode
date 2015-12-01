function size_biased_distribution_params = size_bias(distribution_params)

% turns a custom distribution, with parameters a vector of probabilities 
% into a size biased distribution 

bias_vector = 0:length(distribution_params)-1;
size_biased_distribution_params = bias_vector .* distribution_params;
size_biased_distribution_params = size_biased_distribution_params/...
    sum(size_biased_distribution_params);

end
