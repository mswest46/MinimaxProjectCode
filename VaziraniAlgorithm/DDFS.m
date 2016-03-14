function [G,D,marked] = DDFS(bridge,G,bloom,level,debugBool)

minLevel = @ (v) min(G.V.evenLevel(v),...
    G.V.oddLevel(v));
[marked,markedPos] = my_queue('create');

% D will be the information about DDFS struct. In it will be
% initLeft,initRight,lCOA,rCOA,bloomFound,DCV,barrier.

vs = G.edges(bridge).incidentNodes;
D.initLeft=vs(1); D.initRight = vs(2);
D.bloomFound = false;
% TODO add edgesUsed?

% one of the top vxs has been erased
if G.V.erased(D.initLeft)|| G.V.erased(D.initRight)
    D.bloomFound = -1;
    return
end
lBloom = G.V.bloom(D.initLeft);
rBloom = G.V.bloom(D.initRight);
% we already found this bloom (or the bloom this bloom is embedded in).
% Continuing with DDFS would only bring us to the same bloom.
if ~isnan(lBloom) && ~isnan(rBloom) && ...
        (baseStar(lBloom,G,bloom) == baseStar(rBloom,G,bloom));
    D.bloomFound = -1;
    return
end
% one of the top vxs in a bloom already.
if ~isnan(lBloom)
    D.lCOA = assign(baseStar(lBloom,G,bloom));
    G.V.lParent(D.lCOA) = D.initLeft;
else
    D.lCOA = assign(D.initLeft);
end
if ~isnan(rBloom)
    D.rCOA = assign(baseStar(rBloom,G,bloom));
    G.V.rParent(D.rCOA) = D.initRight;
else
    D.rCOA = assign(D.initRight);
end
% note how we assign lCOA and rCOA, and not initLeft and initRight.
% initLeft and initRight may already belong to blooms!

G.V.ownership(D.lCOA) = 1;

G.V.ownership(D.rCOA) = 2;

% tracks who we marked. It's probably better to use unique DDFS id in
% vertices.ddfsMark. I think the bridge id should do the trick.
[marked,markedPos] = my_queue('add',marked,markedPos,[D.lCOA,D.rCOA]);
% Deepest Common Vertex. Becomes bottleneck if we have no routes around.
D.DCV = nan;
% barrier is the node belonging to RIGHTDFS beyond which we don't need to
% backtrack, because everything has been checked. Initiallly is just rCOA
D.barrier = assign(D.rCOA);

% stopping condition: if bloom has been found, we're done. If we have
% reached the minLevel 0 vertices, we have an augpath somewhere, UNLESS
% lCOA and rCOA are the same. In this case, we may have an undiagnosed
% bloom.
stop = D.bloomFound || ...
    (minLevel(D.lCOA)==0 && minLevel(D.rCOA) == 0 && D.lCOA~=D.rCOA);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while ~stop
    if minLevel(D.lCOA) >= minLevel(D.rCOA)
        [D,G,bloom,marked,markedPos] = LEFTDFS(D,G,bloom,marked,markedPos,debugBool);
    else
        [D,G,bloom,marked,markedPos] = RIGHTDFS(D,G,bloom,marked,markedPos,debugBool);
    end
    stop = D.bloomFound || ...
        (minLevel(D.lCOA)==0 && minLevel(D.rCOA) == 0 && D.lCOA~=D.rCOA);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pack up for output.

if D.bloomFound
    % we don't want the base of the bloom to be part of the bloom, so
    % remove mark and ownership
    
    G.V.ownership(D.DCV) = 0;
    marked(marked==D.DCV) = []; markedPos = markedPos - 1;
    
end
[marked,~] = my_queue('clean',marked,markedPos);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% these are out for debugging purposes. TODO plan on moving them into main
% body if they fuck with speed.
function [D,G,bloom,marked,markedPos] = LEFTDFS(D,G,bloom,marked,markedPos,debugBool)
if D.lCOA == D.rCOA
    % DCV  part 1. We set RIGHTDFS backtracking in motion. If RIGHTDFS
    % finds a way around, things will continue. If not, it will make its
    % way to barrier, at which point it will start DCV part 2, in which
    % LEFTDFS looks for a way around. TODO: is there any way that this
    % condition is satisfied (i.e. lCOA=rCOA) in edge cases. For example,
    % what if RIGHTDFS is backtracking and finds aNTOHER way down to DCV? I
    % think this is a problem. Solution might be to used indicator
    % variables for what phase we are in. That is all for this LEFTDFS
    
    
    % we should set bottleneckage in motion
    D.DCV = assign(D.lCOA);
    D.rCOA = assign(G.V.rParent(D.rCOA));
    
    G.V.ownership(D.lCOA) = 1;
    
    
    % check has been marked already.
    if debugBool
        assert(any(marked==D.lCOA));
    end
    
else
    
    u = getPred(D.lCOA,G);
    if isempty(u)
        if D.lCOA == D.initLeft
            % if have backtracked back to initLeft we have discovered a bloom
            D.bloomFound = true;
        else
            % backtrack
            D.lCOA = assign(G.V.lParent(D.lCOA));
        end
        
    elseif D.lCOA==D.initLeft && ~isnan(G.V.bloom(D.initLeft));
        % we have somehow managed to backtrack to init left via blooms, but
        % preds are not empty. TODO see if we shoudl put the hack in getPreds
        % instead of here.
        D.bloomFound= true;
    else
        e = getEfromVs(G,D.lCOA, u);
        B = G.V.bloom(u);
        if ~isnan(B)
            % move to baseStar. Note that we don't check here whether or not we
            % have already visited baseStar.
            u = baseStar(B,G,bloom);
        end
        % at this point note that we are in a nan bloom vertex. If u is owned,
        % it must have been touched by RIGHTDFS in this DDFS session. In debug
        % mode, check this is correct
        if debugBool && G.V.ownership(u)
            assert(any(marked==u))
        end
        
        % whether we move along it or not, we mark e as having been looked at.
        % note that ddfsMark goes onto the ORIGINAL edge, even if we've come
        % via a bloom. that is, the endpoint of e might be in a boom, and u is
        % not.
        G.E.ddfsMark(e) = true;
        
        
        % It is possible that RIGHTDFS jumped below us via a bloom. If this is
        % the case we want LEFTDFS to claim the vertex, as if LEFTDFS got there
        % first. LEFTDFS will take care of the DCV procedure on the next call.
        if G.V.ownership(u)==0
            G.V.ownership(u) = 1;
            [marked,markedPos] = my_queue('add',marked,markedPos,u); %TODO see about implementing this as a ddfsID number in edges.ddfsMark
            G.V.lParent(u) = D.lCOA;
            D.lCOA = assign(u);
        elseif u == D.rCOA && u ~= D.DCV
            G.V.lParent(u) = D.lCOA;
            D.lCOA = assign(u);
        end
    end
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [D,G,bloom,marked,markedPos] = RIGHTDFS(D,G,bloom,marked,markedPos,debugBool)

u = getPred(D.rCOA,G);
if isempty(u) || ...
        (D.rCOA==D.initRight && ~isnan(G.V.bloom(D.initRight)))
    if D.rCOA == D.barrier || D.rCOA == D.initRight;
        % we have backtracked all the way to barrier, no way around, so
        % return to DCV. OR we've backtracked to initRight, but because
        % initRight is in a bloom, it has predecessors that havent' been
        % checked. TODO see if we should put the hack into getPreds. This
        % is similar to issues in LEFTDFS.
        
        % another hack is here. The D.rCOA == D.initRight bit for test case
        % #
        
        D.barrier = assign(D.DCV);
        D.rCOA = assign(D.DCV);
        % reclaim DCV as 'right'
        G.V.ownership(D.rCOA) = 2;
        % set LEFTDFS backtracking
        D.lCOA = assign(G.V.lParent(D.lCOA));
    else % normal backtrack
        D.rCOA = assign(G.V.rParent(D.rCOA));
    end
else
    e = getEfromVs(G,D.rCOA,u);
    
    % we jump to nan vertex if we hit a bloom.
    B = G.V.bloom(u);
    if ~isnan(B)
        u = baseStar(B,G,bloom);
    end

    
    % whether we move along e or not, we mark it as looked at.
    G.E.ddfsMark(e) = true;
    
    % if we have reached either an unowned vertex or we have encountered
    % lCOA, we move to it and claim. If u is lCOA, LEFTDFS will claim right
    % back in the DCV stage. This is a bit messy but I think ok.
    if G.V.ownership(u) == 0
        G.V.ownership(u) = 2;
        [marked,markedPos] = my_queue('add',marked,markedPos,u);
        G.V.rParent(u) = D.rCOA;
        D.rCOA = assign(u);
    elseif u == D.lCOA
        G.V.ownership(u) = 2;
        G.V.rParent(u) = D.rCOA;
        D.rCOA = assign(u);
        
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get 'unused' and 'unerased' predecessor.
function pred = getPred(v, G)
og = G.V.preds{v};
pred = [];
for p = og
    e = getEfromVs(G,v,p);
    if ~G.E.ddfsMark(e) && ~G.V.erased(p)
        pred = p;
        return
    end
end

end

% assigns value to target, making sure that things are not 0 or NaN
function target = assign(value)
assert(~isnan(value) && ~(value==0));
target = value;
end

function b = baseStar(B,G,bloom)

% (B, bloom, base)
b = bloom.base(B);
while ~isnan(G.V.bloom(b))
    b = bloom.base((G.V.bloom(b)));
end

end


