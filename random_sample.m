function sample = random_sample(distribution, size)

if strcmp(distribution.type, 'custom')
    sample = custom_random_sample(distribution.params, size);
elseif strcmp(distribution.type, 'constant')
    sample = repmat(distribution.params, 1, size);
else
    params = num2cell(distribution.params);
    sample = random(distribution.type, params{:}, 1, size);
    
end
