function [G,augOccurred] = SEARCH(G,debugBool)

numNodes = G.info.numNodes;
numEdges = G.info.numEdges;
dummy = G.info.dummy;


% reset the vertices values for new search

G.V.ownership = zeros(1,numNodes);
G.V.lParent = zeros(1,numNodes);
G.V.rParent = zeros(1,numNodes);
G.V.bloom = nan(1,numNodes);
G.V.evenLevel = inf(1,numNodes);
G.V.oddLevel = inf(1,numNodes);
G.V.erased = false(1,numNodes);
G.V.predCount = zeros(1,numNodes);
G.V.preds = cell(1,numNodes);
G.V.succs = cell(1,numNodes);
G.V.anomalies = cell(1,numNodes);

G.E.ddfsMark = false(1,numEdges);

% reset level struct values for new search
% TODO numNodes is way too big.
c = cell(1,numNodes);
z = num2cell(zeros(1,numNodes));
level = struct('candidates',c,'bridges',c,...
    'candPos',z,'bridgePos',z);

C.l = ceil(sqrt(numNodes));
C.candidates = cell(1,C.l);
C.pos = zeros(1,C.l);


% reset bloom struct values for new search.
bloom = struct('base',[],'leftPeak',[],'rightPeak',[]);

% reset the edges values for new search
f = num2cell(false(1,numEdges));
% i = num2cell(inf(1,numNodes));
% na = num2cell(nan(1,numNodes));
% c = cell(1,numNodes);
% z = num2cell(zeros(1,numNodes));

[G.edges.ddfsMark] = f{:};
[G.edges.fpMark] = f{:};


S = 0; % search level
inc = @(i) i+1; % used to increment search level becuase matlab doesn't index by zero

free = ([G.vertices.pair]==dummy);
matchingSize = numNodes - sum(free);

updateCandidates(0,find(free));


G.V.evenLevel(free)=0;

augOccurred = false;
% coming into this, candidates and bridges are unique, and not
% preallocated.
while ~ (augOccurred || isempty(C.candidates{S+1}));
    searchCandidates = unique(C.candidates{S+1}(1:C.pos(S+1)));
%     [searchCandidates,~] = ...
%         my_queue('clean',level(inc(S)).candidates,level(inc(S)).candPos,'');
    % Searches G
    if mod(S,2)==0 % even search level.
        for v = searchCandidates
            targets = G.vertices(v).neighbors;
            for i = 1: length(targets);
                w = G.vertices(v).neighbors(i);
                if G.V.erased(w)
                    targets(targets==w)=[];
                end
            end
            targets(targets == G.vertices(v).pair) = [];
            for u = targets
                if G.V.evenLevel(u) < inf
                    b = getEfromVs(G,u,v);
                    j = inc(sum(G.V.evenLevel([u,v]))/2); % maybe doesn't work
                    [level(j).bridges, level(j).bridgePos] = ...
                        my_queue('add',level(j).bridges,level(j).bridgePos,b);
                else
                    if G.V.oddLevel(u) == inf
                        G.V.oddLevel(u) = S + 1;
                    end
                    oL = G.V.oddLevel(u);
                    if oL == S + 1;
                        G.V.predCount(u) = G.V.predCount(u)+1;
                        G.V.preds{u} = [G.V.preds{u}, v];
                        G.V.succs{v} = [G.V.succs{v}, u];
                        % add u to level S+1 candidates
                        updateCandidates(S+1,u);

                    end
                    if oL < S %TODO could this be an else statement?
                        G.V.anomalies{u} = ...
                            [G.V.anomalies{u},v];
                        % add to candidates anyway? This might be
                        % problematic. TODO make this comment make
                        % senseExcept on return, we'd be looking at odd
                        % level(u) and so u will be in a bloom. hence this
                        % condition 10 lines down (*)
                        updateCandidates(S+1,u);
                    end
                end
            end
        end
    else % odd search level.
        for v = searchCandidates
            if isnan(G.V.bloom(v)) % (*)
                u = G.vertices(v).pair;
                if G.V.oddLevel(u) < inf
                    j = inc(sum(G.V.oddLevel([u,v])) / 2);
                    b = getEfromVs(G,u,v);
                    [level(j).bridges,level(j).bridgePos] = my_queue('add',...
                        level(j).bridges,level(j).bridgePos,b);
                elseif G.V.evenLevel(u) == inf
                    G.V.preds{u} = v;
                    G.V.predCount(u) = 1;
                    G.V.succs{v} = u;
                    G.V.evenLevel(u) = S + 1;
                    % add u to S+1 candidates
                    updateCandidates(S+1,u);
                end
            end
        end
    end
    
    [bridges,~] = my_queue('clean',level(inc(S)).bridges,level(inc(S)).bridgePos,'');
    for bridge = bridges
        [G,D,marked] = DDFS(bridge,G,bloom,level,debugBool);
        switch D.bloomFound
            case 1
                info = struct(...
                    'S',S,...
                    'bloomNodes',marked,...
                    'leftPeak',D.initLeft,...
                    'rightPeak',D.initRight,...
                    'base',D.DCV);
                %                 [G,level,bloom] = BLOOM(G,level,bloom,info);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                B = length(bloom.base) + 1;
                
                bloom.base(B) = info.base;
                bloom.leftPeak(B) = info.leftPeak;
                bloom.rightPeak(B) = info.rightPeak;
                
                for y = info.bloomNodes
                    if ~isnan(G.V.bloom(y))
                        save('~/Desktop/bad_mat.mat','G.A');
                        error('this vx is in a bloom already. bad mat saved to desktop.')
                    end
                    G.V.bloom(y) = B;
                    minLevel = min(G.V.evenLevel(y),G.V.oddLevel(y));
                    switch mod(minLevel,2)
                        case 0 % y is even (i.e. at the end of a matched edge).
                            G.V.oddLevel(y) = 2*info.S +1 - G.V.evenLevel(y);
                        case 1 % y is odd (beginning of a matched edge).
                            G.V.evenLevel(y) = 2*info.S +1 - G.V.oddLevel(y);
                            l = G.V.evenLevel(y);
                            updateCandidates(l,y);
                            for z = G.V.anomalies{y}
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
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 0
                lPath = FINDPATH(D.initLeft,D.lCOA,1,nan,G,bloom);
                rPath = FINDPATH(D.initRight,D.rCOA,2,nan,G,bloom);
                augPath = [flip(lPath),rPath];
                augOccurred = true;
                
                %The following block could be place in a different
                %function, but it slows things down.
                % augment
                for k = 1: length(augPath) - 1
                    if mod(k,2) % i is odd
                        G.vertices(augPath(k)).pair = augPath(k+1);
                        G.vertices(augPath(k+1)).pair = augPath(k);
                    end
                end
                % erase
                [Q,qPos] = my_queue('create','','',augPath);
                while qPos>0
                    [Q,qPos,o] = my_queue('pop',Q,qPos,'');
                    G.V.erased(o) = true;
                    for w = G.V.succs{o}
                        if ~G.V.erased(w)
                            G.V.predCount(w) = G.V.predCount(w) - 1;
                            if G.V.predCount(w) == 0
                                [Q,qPos] = my_queue('add',Q,qPos,w);
                            end
                        end
                    end
                end
            case -1
                % do nothing.
        end
    end
    
    S = S+1;
    updateCandidates(S,'') % this makes sure that S candidates exists
end


    function updateCandidates(s,vs)    
        
        if s+1>C.l % we need to resize candidates;
            newL = 10*C.l;
            tempCell = cell(1,newL);
            tempCell(1:C.l) = C.candidates;
            C.candidates = tempCell;
            tempZero = zeros(1,newL);
            tempZero(1:C.l) = C.pos;
            C.pos = tempZero;
            C.l = newL;
        end
        if isempty(vs)
            return
        end
        newPos = C.pos(s+1) + length(vs);
        tempL = length(C.candidates{s+1});
        if newPos > tempL
            tempZero = zeros(1,10*max(tempL,1));
            tempZero(1:tempL) = C.candidates{s+1};
            C.candidates{s+1} = tempZero;
        end
        C.candidates{s+1} (C.pos(s+1)+1:newPos) = vs;
        C.pos(s+1) = newPos;
    end

    function updateBridges(s,v)
    end


end


