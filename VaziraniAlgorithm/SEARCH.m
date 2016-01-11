function search_mods = SEARCH(search_struct)

% unpack search_struct
graph = search_struct.graph;
pair = search_struct.pair;
search_mods = search_struct.search_mods;
bloom = search_struct.bloom;
erased = search_struct.erased;

% unpack search_mods.
assert(length(fieldnames(search_mods)) == 11);
search_level = search_mods.search_level;
even_level = search_mods.even_level;
odd_level = search_mods.odd_level;
predecessors = search_mods.predecessors;
successors = search_mods.successors;
pred_count = search_mods.pred_count;
bridges = search_mods.bridges;
anomalies = search_mods.anomalies;
candidates = search_mods.candidates;
initial_flag = search_mods.initial_flag;
max_matching_found = search_mods.max_matching_found;

% initialize
num_nodes = graph.num_nodes;
bridge_found = false;
if initial_flag % first run we need to put free vxs in level 0 candidates.
    candidates{index(0)} = find(pair==graph.dummy);
    even_level(pair == graph.dummy) = 0;
end

bridges2 = cell(1,num_nodes);
bridge_pos = zeros(1,num_nodes);
for i = 1: num_nodes
    bridges2{i} = zeros(1,100);
    bridges2{i}(1:length(bridges{i})) = bridges{i};
    bridge_pos(i) = length(bridges{i}); % where the last bridge is.
end

candidates2 = cell(1,num_nodes);
cand_pos = zeros(1,num_nodes);
cand_added = false(1,num_nodes);
for i = 1: num_nodes
    candidates2{i} = zeros(1,100);
    candidates2{i}(1:length(candidates{i})) = candidates{i};
    cand_pos(i) = length(candidates{i}); % where the last candidate is.
end


% this is a weird edge case. If we have searched through bridges and found
% only blossoms, we're going to call SEARCH again without resetting. If
% there are no candidates in the next level however, we should have found a
% max matching. Thus, if ~search_happened, we want to be done. To do this
% we need to increment search level outside of the loop.  TODO make this
% more intuitive and clean.
search_happened = false;

while initial_flag || ...
        (~bridge_found && cand_pos(index(search_level))>0)
    search_happened = true;
    initial_flag = false;
    search_level = search_level + 1;
    cands2search = candidates2{index(search_level)}...
        (1:cand_pos(index(search_level)));
    if mod(search_level,2)==0 %search_level is even.
        for v = cands2search
            neighbors = graph.neighbors{v}';
            targets = neighbors;
            for i = 1: length(neighbors)
                if erased(neighbors(i))
                    targets(targets==neighbors(i)) = [];
                end
            end
            targets(targets==pair(v)) = [];
            for u = targets
                if even_level(u) < inf
                    j = (even_level(u) +...
                        even_level(v)) / 2;
                    b = graph.get_e_from_vs(u,v);
                    bridge_pos(index(j)) = bridge_pos(index(j)) + 1;
                    bridges2{index(j)}(bridge_pos(index(j))) = b;
                    bridge_found = true;
                else
                    if odd_level(u) == inf
                        odd_level(u) = search_level+1;
                    end
                    if odd_level(u) == ...
                            search_level+1
                        pred_count(u) = ...
                            pred_count(u) + 1;
                        predecessors{u} = ...
                            [predecessors{u}, v];
                        successors{v} = ...
                            [successors{v}, u];
                        if ~cand_added(u)
                            cand_pos(index(search_level + 1)) = cand_pos(index(search_level+1)) + 1;
                            candidates2{index(search_level+1)}(cand_pos(index(search_level+1))) = u;
                            cand_added(u) = true;
                        end
                    end
                    if odd_level(u) < search_level
                        anomalies{u} = [anomalies{u}, v];
                    end
                end
            end
        end
    else %search_level is odd.
        for v = cands2search
            if isnan(bloom(v))
                u = pair(v);
                if odd_level(u) < inf
                    j = (odd_level(u) + odd_level(v)) / 2;
                    b = graph.get_e_from_vs(u,v);
                    bridge_pos(index(j)) = bridge_pos(index(j)) + 1;
                    bridges2{index(j)}(bridge_pos(index(j))) = b;
                    bridge_found = true;
                elseif even_level(u) == inf
                    predecessors{u} = v;
                    successors{v} = u;
                    pred_count(u) = 1;
                    even_level(u) = search_level + 1;
                    if ~cand_added(u)
                        cand_pos(index(search_level + 1)) = cand_pos(index(search_level+1)) + 1;
                        candidates2{index(search_level+1)}(cand_pos(index(search_level+1))) = u;
                        cand_added(u) = true;
                    end
                end
                
            end
        end
    end
    
end

% TODO could be clarified.
if ~search_happened
    search_level = search_level + 1;
end

% remove duplicates.
bridges2{index(search_level)} = ...
    unique(bridges2{index(search_level)});

for i = 1: num_nodes
    if~isempty(bridges2{i})
        bridges2{i}(bridges2{i}==0) = [];
    end
end

bridges = bridges2;

for i = 1: num_nodes
    if~isempty(candidates2{i})
        candidates2{i}(candidates2{i}==0) = [];
    end
end

candidates = candidates2;

% TODO make some indicator variables to improve this.
if isempty(bridges{index(search_level)})
    max_matching_found = true;
end

% repack search_mods.
search_mods.search_level = search_level;
search_mods.even_level = even_level;
search_mods.odd_level = odd_level ;
search_mods.predecessors = predecessors;
search_mods.successors = successors ;
search_mods.pred_count = pred_count;
search_mods.bridges = bridges ;
search_mods.anomalies =  anomalies;
search_mods.candidates = candidates;
search_mods.initial_flag = initial_flag;
search_mods.max_matching_found = max_matching_found;




end



