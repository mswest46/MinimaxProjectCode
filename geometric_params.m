function params = geometric_params(p)
tol = 10^(-7);
i = 2;
prob = 1;
params = zeros(1,10^6);
while prob > tol
    prob = p^(i-2);
    params(i) = prob;
    i = i+1;
end

params = params(1:i-1);
params = params/sum(params);
    