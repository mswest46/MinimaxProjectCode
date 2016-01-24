function P = lift(P_prime, G_prime, G, B, distance)
% b is the base of blossom B. in P_prime, there is an edge from b to
% another vertex y, which represents an edge from one of the vertices x in
% B to y outside of B. What things can go wrong? we might have b in the
% path, but not any of the other B vxs. e.g.
%    ._. --B
%  ._|./_. --P
% This should be dealt with the same as any other B vx. Note that P
% cannot go p-v for some v in B not neighboring b in this case, as this
% would form a cycle in our tree.


b = B(end);
b_ind = find(P_prime==b,1);

if isempty(b_ind) % P_prime doesn't run through the blossom
    P = P_prime;
else
    
    
    % need to determine if P_prime runs 'forwards' thru B or 'backwards'.
    % we say 'forwards' if in our expansion P, a B vx follows b.
    
    % one of these skips the blossom; G(b, x)
    follower = []; preceder = [];
    if b_ind>1
        preceder = P_prime(b_ind-1);
    end
    if b_ind<length(P_prime);
        follower = P_prime(b_ind+1);
    end
    
    % out_neighbor is the vx not in B adjacent to a vx in B in the graph G.
    % If b is the first (last) in P_prime, then the follower (preceder)
    % must be the out_neighbor. Otherwise, if either the follower or
    % preceder is adjacent to b in G, we know that the other must be the
    % out_neighbor. Note that the order of the if elseifs matter, becuase
    % it is possible that BOTH the follower and preceder are adjacent to b
    % in G, (if the path P_prime touches the base of the blossom and does
    % not enter it)
    if isempty(follower); out_neighbor = preceder; forwards = false;
    elseif isempty(preceder); out_neighbor = follower; forwards = true;
    elseif G.adjacency_matrix(b,follower); out_neighbor = preceder; forwards = false;
    else out_neighbor = follower; forwards = true;
    end
    
    % finds the blossom vertex from which we exit/enter. TODO check there's
    % only one of these bad boys (o/w there's a cycle in G)
    clear out
    flag = false;
    for v = B;
        if G.adjacency_matrix(v,out_neighbor)
            if flag
                error('yo')
            end
            out = v;
            flag = true;
            
        end
    end
    assert(logical(exist('out','var')));
    
    d = distance(out) - distance(b);
    
    % sub path is a path from out to b
    if mod(d,2)==0 % we're an even distance from out to b
        ind = find(B==out);
        sub_path = B(ind:end);
        assert(mod(length(sub_path),2)==1);
    else % we're an odd distance from out to b
        ind = find(B==out);
        sub_path = [flip(B(1:ind)),b];
        assert(mod(length(sub_path),2)==1);
    end
    
    if forwards
        P = [P_prime(1:b_ind-1),flip(sub_path),P_prime(b_ind+1:end)];
    else
        P = [P_prime(1:b_ind-1),sub_path,P_prime(b_ind+1:end)];
    end
    
end

end