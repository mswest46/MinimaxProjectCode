function search_mods = SEARCH(search_struct)

graph = search_struct.graph;
pair = search_struct.pair;
search_mods = search_struct.search_mods;
bloom = search_struct.bloom;
erased = search_struct.erased;


% initial call will be: 

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
% search_mods.search_level = 0;
% search_mods.even_level = inf(1,num_nodes);
% search_mods.odd_level = inf(1,num_nodes);
% search_mods.predecessors = cell(1,num_nodes);
% search_mods.successors = cell(1,num_nodes);
% search_mods.pred_count = zeros(1,num_nodes);
% search_mods.bridges = cell(1,num_nodes);
% search_mods.anomalies = cell(1,num_nodes);
% search_mods.candidates = cell(1,num_nodes);
% search_mods.initial_flag = true;
bridge_found = false;

if initial_flag
    candidates{index(0)} = find(pair==graph.dummy);
    even_level(pair == graph.dummy) = 0;
end
search_happened = false;
while initial_flag || ...
        (~bridge_found && ~isempty(candidates{index(search_level)}))
    search_happened = true;
    initial_flag = false;
    search_level = search_level + 1;
    if mod(search_level,2)==0 %search_level is even.
        for v = candidates{index(search_level)}
            targets = find( ~erased & graph.adjacency_matrix(v,:)); %maybe better way, neighbors cell for instance
            targets = setdiff(targets, pair(v));
            for u = targets
                if even_level(u) < inf
                    j = (even_level(u) +...
                        even_level(v)) / 2;
                    bridges{index(j)} = [bridges{index(j)},...
                        graph.get_e_from_vs(u,v)];
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
                        candidates{index(search_level+1)} = ...
                            [candidates{index(search_level+1)}, u];
                    end
                    if odd_level(u) < search_level
                        anomalies{u} = [anomalies{u}, v];
                    end
                end
            end
        end
    else %search_level is odd.
        for v = candidates{index(search_level)}
            if isnan(bloom(v))
                u = pair(v);
                if odd_level(u) < inf
                    j = (odd_level(u) + odd_level(v)) / 2;
                    bridges{index(j)} = ...
                        [bridges{index(j)}, graph.get_e_from_vs(u,v)];
                    bridge_found = true;
                elseif even_level(u) == inf
                    predecessors{u} = v;
                    successors{v} = u;
                    pred_count(u) = 1;
                    even_level(u) = search_level + 1;
                    candidates{index(search_level+1)} = ...
                        [candidates{index(search_level+1)}, u];
                end
                
            end
        end
    end
end
% 
% if ~(initial_flag || ...
%         (~bridge_found && ~isempty(candidates{index(search_level)})))
%     search_level = search_level+1;
% end

if ~search_happened
    search_level = search_level + 1;
end
    
bridges{index(search_level)} = ...
    unique(bridges{index(search_level)});

if isempty(bridges{index(search_level)})
    max_matching_found = true;
end

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



