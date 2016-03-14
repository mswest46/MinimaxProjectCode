function altPath = OPEN(v,G,bloom,B)

minLevel = @(v) min(G.V.evenLevel(v),G.V.oddLevel(v));

b = bloom.base(B);
P = G.V.ownership(v);
assert(P==1||P==2);

if mod(minLevel(v),2)==0
    altPath = FINDPATH(v,b,P,B,G,bloom,'mid');
else
    l = bloom.leftPeak(B);
    r = bloom.rightPeak(B);
    if P == 1
        p1 = FINDPATH(l,v,1,B,G,bloom);
        p2 = FINDPATH(r,b,2,B,G,bloom);
        altPath = [flip(p1),p2];
    else
        p1 = FINDPATH(r,v,2,B,G,bloom);
        p2 = FINDPATH(l,b,1,B,G,bloom);
        altPath = [flip(p1),p2];
    end
end

end