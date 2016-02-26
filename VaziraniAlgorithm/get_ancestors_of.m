function ancestors = get_ancestors_of(vxs,predecessors, num_nodes)
% Depth first search of ancestry

v1 = vxs(1);
v2 = vxs(2);



added = false(1,num_nodes);


[A, a_pos] = my_queue('create');
[Q,q_pos] = my_queue('create','','',[v1,v2]);

% queue = zeros(1,100000);
% queue([1,2]) = [v1,v2];
% q_place = 2;

while q_pos>0
    [~,q_pos,u] = my_queue('pop',Q,q_pos,'');
    if ~added(u)
        [A,a_pos] = my_queue('add',A,a_pos,u);
        added(u) = true;
        [Q,q_pos] = my_queue('add',Q,q_pos,predecessors{u});
    end
end

ancestors = my_queue('clean',A,a_pos);
ancestors = sort(ancestors);


end



