function size_biased_distribution_params = size_bias(distribution_params)

% given p_k', the probabilities of a node in the tree having k children, we
% output p_k, the probabilities of a configuration model having k
% neighbors. p_k = p_(k-1)'/(k-1) all normalized. 

bias_vec = 1:length(distribution_params);
temp = [0,distribution_params./bias_vec];
size_biased_distribution_params = temp/sum(temp);