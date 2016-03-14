function altPath = FINDPATH(high,low,P,B,G,bloom,baseOrMid)

% the goal is to trace out the path, which we know exists because the DDFFS
% found it, from high to low within the bloom B. The reason things get so
% complicated is because we are sometimes allowed to travel along blooms
% within a different parity, as long as we eventually return to B and do so
% within the correct parity. This is confusing so here are some examples of
% what behavior we want to happen:

% Note. Don't forget that leftPeak does not necessarily belong to bloom it
% is peak for. When we DDFS, we jumped to base of bloom and began there.

% 1. simplest case. bloom is NaN. DDFS made no jumps when discovering the
% aug_path, so findpath will likewise make no jumps.

% 2. another simple case. bloom is some bloom B and DDFS made no jumps when
% discovering it, and we are traveling down the left side. There are no
% embedded blooms. We simply move along 'left' marked vertices until we
% reach the base of B. We may encounter some dead ends, as LEFTDFS must
% have done, but we eventually make it all way.

% 3. B is NaN, but when DDFS made its search, it (not initially) hit a node
% u in a bloom and jumped to the base. (a). This bloom is in the aug_path,
% i.e. DDFS did not backtrack through (TODO this not backtracking might be
% a useful thing to record) (b). This bloom is not in the aug_path, but the
% base of it was marked by the DDFS. (c). This bloom is not in the
% aug_path, and the base of it was not marked by the DDFS (because it was
% the wrong parity). Let's assume that high was initLeft, so when we are
% travelling in NaN bloom, we stick to 'left' marks.

% (a). We encounter this bloom at node u. We include u in our parent data,
% we jump to its baseStar. This base is marked 'left'. We
% continue on as normal. When we are creating the path, we recognize that u
% is in a bloom, and call open ON EACH OF THE BLOOMS IN THE BLOOM CHAIN.
% Bloom chain is like this. u in B1, base(B1) in B2, ...,
% base(Bn)=baseStar(u) in NaN. We can either record what the bloom chain is
% or call a funtion to find it. When navigating in the bloom chain, should
% stick to parity. 

% (b). We proceed like above, only in this instance u will not show up in
% our path, so there is no need to call OPEN

% (c). We do not even inclue u in our tree? TODO make sure of this. 

% 4. B is NaN, but high is in a bloom! Should FINDPATH act any
% differently than it did with case (a)? Yes! If high is in a bloom, it
% might have the wrong parity than that bloom's base. We need to make sure
% that the baseStar of high is the right parity, not high itself. 

% 5. B is not NaN. In what ways might we encounter a non-B vertex u? (a). u
% is base(B). That's good. Thats's the goal. (b). u is in an embedded
% bloom. i.e. a bloom B' where base(B') belongs to B. This is dealt with
% just like 3(a), only with B being the enclosing bloom instead of NaN. Once
% again, need to make sure we stick to parity. 
% (c). u is in a bloom B' whose base does not belong to B. I think the only
% way tthat this can happen is if base(B) is base(B'). In this case, we
% should be find to proceed as in 3(a). 

% Question: What about when leftPeak is in a different bloom than B? Does
% that fuck things up? I think as long as we define what parity we are
% after correctly, we are ok. 

% Does parity matter if we are looking at a non-bloom? in 3(a), we don't
% care about the parity of u. in 4, we don't care about the parity of high.
% The only time we care about parity is if FINDPATH was called with bloom B
% and the vertex in question is in bloom B. In this case, we need to make
% sure that (1). if high was left(right)Peak, then parity is left(right).
% (2). if high is something else, then hgih is in the bloom in question,
% right? In this case FINDPATH has been called by OPEN along the short side
% of the bloom. 

% What happens if B is a stacked bloom?
% e.g.
%  _
% |_|
% | |
% \ /
% In this instance, we will be travelling in B, and eventually hit B' which
% has base(B') = base(B). FINDPATH should call open to deal with this
% instance. That is, we will be at depth three FINDPATH calls. Basically, I
% think it will be easier to specify parity uponn calling FINDPATH, rather
% than letting it figure it out for itself. 

% we might encounter the base of our bloom when we're not looking
% for it! for example, we are being called from FINDPATH, looking
% for a path from the top of the bloom to a midway point in the
% boom. But it is possible to bypass that midway point and reach
% the base. IN THIS CASE, we don't want to be opening the base (it
% may not even be in a bloom). What we can do to avoid this is to
% backtrack if we ever reach a vertex with level below that of our
% low.



% NEW NOTES: 
 
% Case 1: high is midway in a bloom, low is base of that bloom. 

% Case 2: high is peak of bloom. low is midway through that bloom. 

% Case 3: high is peak of bloom and low is base of bloom. 

% Case 4: high is bloom is NaN and high is initLeft and low is free. 

% Case 4 is the initial call to FINDPATH, and cases 1-3 come from OPEN,
% depending on various things. 

% In case 4, we care about parity when we are at vertices also without a
% bloom (i.e. NaN bloom). If we were to allow travel to vertices of a
% different parity, we might end up on the wrong free vertex. 

% In case 2, we also care about parity. Case 2 will be paired with a case 3
% wehn called from open, and we need the paths discovered to be disjoint.
% We know that a correct parity path exists, becasue (e.g.) LEFTDFS made it
% to low via only 'left' marked vertices. 

% In case 3, we also care about parity, for the same reasons as case 2. 

% In case 1, we don't care about parity! We know that there is an
% alternating path from high to low. Why? Because SEARCH tells us there is
% an alternating path from SOME free vertex to high. Suppose low is not on
% one of these paths. Let u be the minimal level vertex s.t. u is in a alt
% path and also in the bloom. Let v be the vertex on the path 1 step closer
% to free. v is not in the bloom. If v were not erased when DDFS was
% called, then v would have been discovered during the backtracking phase,
% and would be in the bloom. Therefore, v must have been erased. If v were
% erased, then u must have another predecessor chain (i.e. alternating
% path) to a free vertex. If v' is the vertex one step closer to free, we
% can use a similar  argument to show that v' must be erased. So, all of
% u's predecessors have been erased, and so u has been erased.
% Contradiction. However, we do not know that this alternating path is of
% the smae parity! See testVizaraniSmall (7) for an example. The idea is
% that (e.g.) LEFTDFS may have made its way to u, hit vertices already
% marked by RIGHTDFS, and backtracked. Then an alternating path does exist
% from u to base, but it is not marked 'left' across the board.

if ~exist('baseOrMid','var')
    baseOrMid='';
end

minLevel = @ (v) min(G.V.evenLevel(v),...
    G.V.oddLevel(v));


% simplest case.
if high == low
    altPath = high;
    return
end

% need to reset the marks. This is SLOW
fpMark = zeros(1,G.info.numNodes);

COA = high;
while COA ~= low

    fpMark(COA) = true;
    if minLevel(COA)<minLevel(low)
        % backtrack. 
        COA = G.V.fpParent(COA);
        continue
    end
        
    
    if isInBloom(COA,G,B)
        if isParity(COA,G,P) || strcmp(baseOrMid,'mid')
            pred = getPred(COA,G,fpMark);
            if isempty(pred)
                COA = G.V.fpParent(COA);
                %backtrack
            else
                G.V.fpParent(pred)= COA;
                COA = pred;
            end
        else 
            COA = G.V.fpParent(COA);
            % backtrack.
        end
    else
       
        

         
        base = getBase(COA,G,bloom,fpMark);
        if isempty(base)
            COA = G.V.fpParent(COA);
        else
            G.V.fpParent(base) = COA;
            COA = base;
        end
    end
end

% COA is now low. Back up along fpParent to high. 

tempPath = COA;
while COA ~= high
    COA = G.V.fpParent(COA);
    tempPath = [COA,tempPath];
end

% path is now a path from high to low, but is not yet alternating. We need
% to open the blooms.
l = length(tempPath);
subPaths = cell(1,l);
for i = 1:l-1
    A = G.V.bloom(tempPath(i));
    if ~isequaln(A,B)
        subPaths{i} = OPEN(tempPath(i),G,bloom,A);
        subPaths{i} = subPaths{i}(1:end-1);
    else
        subPaths{i} = tempPath(i);
    end
end
subPaths{l} = tempPath(end);
altPath = [subPaths{:}];
end

function pred = getPred(v,G,fpMark)
% gets unerased unmarked predecessors. 
options = G.V.preds{v};
pred = [];
for u = (options)
    if ~G.V.erased(u) && ~fpMark(u)
        pred = u;
        return
    end
end
end

function base = getBase(v,G,bloom,fpMark)
% gets base if base is unvisited. 
base = [];
u = bloom.base(G.V.bloom(v));
if G.V.erased(u)
    error('huh??')
end
if fpMark(u)
    return
end
base = u;
end


function bool = isInBloom(v,G,B)
bool = isequaln(G.V.bloom(v),B);
end

function bool = isParity(v,G,P)
bool = isequal(G.V.ownership(v),P);
end

