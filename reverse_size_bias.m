function biased_params = reverse_size_bias(params)
% given p_k, the probability distribution of the configuration model, we
% output p_k', the size biased probabilities of a tree found in this graph.
% p_k' = p_(k+1)/(k+1) all normalized.

for i = 1:length(params)-1
    temp(i) = params(i+1)*(i);
end
biased_params = temp/sum(temp);