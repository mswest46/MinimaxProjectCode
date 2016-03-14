function h = getHfromG(G, p)
syms b x
R(x) = 1-G(x); 
H(b,x) = R(2*R(x)-R(x-b)) - R(R(x));
h(b) = H(b,p);