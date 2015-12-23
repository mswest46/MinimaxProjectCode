function search_mods = SEARCH(search_struct)

graph = search_struct.graph;
pair = search_struct.pair;
search_mods = search_struct.search_mods;
bloom = search_struct.bloom;
erased = search_struct.erased;

% initial call will be: 

assert(length(fieldnames(search_mods)) == 12);
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

if search_mods.initial_flag
    search_mods.candidates{index(0)} = find(pair==graph.dummy);
    search_mods.even_level(pair == graph.dummy) = 0;
end
while search_mods.initial_flag || ...
        (~bridge_found && ~isempty(search_mods.candidates{index(search_mods.search_level)}))
    search_mods.initial_flag = false;
    search_mods.search_level = search_mods.search_level + 1;
    if mod(search_mods.search_level,2)==0 %search_level is even.
        for v = search_mods.candidates{index(search_mods.search_level)}
            targets = find( ~erased & graph.adjacency_matrix(v,:)); %maybe better way, neighbors cell for instance
            targets = setdiff(targets, pair(v));
            for u = targets
                if search_mods.even_level(u) < inf
                    j = (search_mods.even_level(u) +...
                        search_mods.even_level(v)) / 2;
                    search_mods.bridges{index(j)} = [search_mods.bridges{index(j)},...
                        graph.get_e_from_vs(u,v)];
                    bridge_found = true;
                else
                    if search_mods.odd_level(u) == inf
                        search_mods.odd_level(u) = search_mods.search_level+1;
                    end
                    if search_mods.odd_level(u) == ...
                            search_mods.search_level+1
                        search_mods.pred_count(u) = ...
                            search_mods.pred_count(u) + 1;
                        search_mods.predecessors{u} = ...
                            [search_mods.predecessors{u}, v];
                        search_mods.successors{v} = ...
                            [search_mods.successors{v}, u];
                        search_mods.candidates{index(search_mods.search_level+1)} = ...
                            [search_mods.candidates{index(search_mods.search_level+1)}, u];
                    end
                    if search_mods.odd_level(u) < search_mods.search_level
                        search_mods.anomalies{u} = [search_mods.anomalies{u}, v];
                    end
                end
            end
        end
    else %search_level is odd.
        for v = search_mods.candidates{index(search_mods.search_level)}
            if isnan(bloom(v))
                u = pair(v);
                if search_mods.odd_level(u) < inf
                    j = (search_mods.odd_level(u) + search_mods.odd_level(v)) / 2;
                    search_mods.bridges{index(j)} = ...
                        [search_mods.bridges{index(j)}, graph.get_e_from_vs(u,v)];
                    bridge_found = true;
                elseif search_mods.even_level(u) == inf
                    search_mods.predecessors{u} = v;
                    search_mods.successors{v} = u;
                    search_mods.pred_count(u) = 1;
                    search_mods.even_level(u) = search_mods.search_level + 1;
                    search_mods.candidates{index(search_mods.search_level+1)} = ...
                        [search_mods.candidates{index(search_mods.search_level+1)}, u];
                end
                
            end
        end
    end
end

search_mods.bridges{index(search_mods.search_level)} = ...
    unique(search_mods.bridges{index(search_mods.search_level)});

if isempty(search_mods.bridges{index(search_mods.search_level)})
    search_mods.max_matching_found = true;
end
end



