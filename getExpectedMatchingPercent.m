function percentNodesMatched = getExpectedMatchingPercent(params)

g = getPGFfromParams(params);
F = getFfromPGF(g);

ezplot(F,[0,1]);

x = linspace(0,1,1000);
[m,i] = max(double(F(x)));

percentNodesMatched = 1-m;