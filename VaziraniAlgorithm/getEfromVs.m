function e = getEfromVs(G,v1,v2)
if v1<v2
    e = G.A(v1,v2);
else
    e = G.A(v2,v1);
end
% e = find([G.edges.indexInA] == sub2ind(size(G.A),v1,v2)); %SLOW
end