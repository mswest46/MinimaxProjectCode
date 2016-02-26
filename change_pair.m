function pair = change_pair(pair)

l = length(pair);
ind = randi(l);

if isstruct(pair)
    pair = subfun(pair,ind,l);
else
    
    
    pair(ind) = randi(l);
end
end

function pair = subfun(pair,ind,l)
pair(ind).num = randi(l);
end