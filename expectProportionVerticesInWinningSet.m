function p = expectProportionVerticesInWinningSet(params)
close all;
s = linspace(0,1);
syms x
% params are the offspring distribution params. biased_params are the
% config degree distribution params. 
biased_params = size_bias(params);
G = getPGFfromParams(params); % this is the pgf of the offspring params
bias_G(x) = getPGFfromParams(size_bias(params)); % this is the pgf of the root node params
G_dash = diff(bias_G);
G2(x) = G_dash(x)/G_dash(1);

p = solve(x-(1-G),'real',true);
p = double(1-bias_G(p));

plot(s,G(s),'.-');
hold on
plot(s,G2(s));

end