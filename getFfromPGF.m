function F = getFfromPGF(g)
syms x 
g_dash = diff(g);
F(x) = x*g_dash(1-x) + g(1-x) + g(1-g_dash(1-x)/g_dash(1))-1;