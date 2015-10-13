function sample = random_sample(distribution, size)

if strcmp(distribution.type, 'custom')
    sample = custom_random_sample(distribution.params, size);
else
    params = num2cell(distribution.params);
    disp(params);
    sample = random(distribution.type, params{:}, 1, size);
    
end
