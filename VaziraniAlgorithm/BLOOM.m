function [G,level,bloom] = BLOOM(G,level,bloom,info)

minLevel = @(v) min(G.V.evenLevel(v),G.V.oddLevel(v));
inc = @(i) i+1;
B = length(bloom.base) + 1;

bloom.base(B) = info.base;
bloom.leftPeak(B) = info.leftPeak; 
bloom.rightPeak(B) = info.rightPeak;

for y = info.bloomNodes
    if ~isnan(G.vertices(y).bloom)
        save('~/Desktop/bad_mat.mat','G.A');
        error('this vx is in a bloom already. bad mat saved to desktop.')
    end
    G.V.bloom(y) = B;
    switch mod(minLevel(y),2)
        case 0 % y is even (i.e. at the end of a matched edge). 
            G.V.oddLevel(y) = 2*info.S +1 - G.V.evenLevel(y);
        case 1 % y is odd (beginning of a matched edge).
            G.V.evenLevel(y) = 2*info.S +1 - G.V.oddLevel(y);
            l = G.V.evenLevel(y);
            [level(inc(l)).candidates,level(inc(l)).candPos] = ...
                my_queue('add',level(inc(l)).candidates,...
                level(inc(l)).candPos,y);
            for z = G.vertices(y).anomalies
                j = (G.V.evenLevel(z)+ G.V.evenLevel(y))/2;
                [level(inc(j)).bridges, level(inc(j)).bridgePos] = ...
                    my_queue('add',level(inc(j)).bridges,...
                    level(inc(j)).bridgePos, getEfromVs(G,y,z));
            end
            % I don't understand why the algorithm requires us to mark y,z
            % used for future DDFS. I am ignoring for now, hoping it is not
            % necessary! TODO.
    end
end



end
        