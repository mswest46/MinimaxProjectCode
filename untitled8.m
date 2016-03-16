close all
syms x
p = .3;
G(x) = (1-p)*x/(1-p*x);
ezplot(G,[0,1])
