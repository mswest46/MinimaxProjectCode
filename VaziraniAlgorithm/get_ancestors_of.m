function ancestors = get_ancestors_of(vxs,predecessors, num_nodes)
% Depth first search of ancestry

v1 = vxs(1);
v2 = vxs(2);
added = false(1,num_nodes);
ancestors = zeros(1,100000);
anc_place = 0;
queue = zeros(1,100000);
queue([1,2]) = [v1,v2];
q_place = 2;
while q_place>0
    u = queue(q_place);
    q_place = q_place-1;
    if ~added(u)
        anc_place = anc_place+1;
        ancestors(anc_place) = u;
        added(u) = true;
        l = length(predecessors{u});
        queue(q_place+1:q_place+l) = predecessors{u};
        q_place = q_place + l;
    end
end
ancestors = ancestors(1:anc_place);
ancestors = sort(ancestors);


end



