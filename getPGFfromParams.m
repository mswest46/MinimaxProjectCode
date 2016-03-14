function g = getPGFfromParams(params)

syms x
temp = 0;
for i = 1:length(params)
    if params(i)>0
        temp = temp + params(i) * x^(i-1);
    end
end

g(x) = temp;