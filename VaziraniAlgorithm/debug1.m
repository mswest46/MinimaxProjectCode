lineage = [];
v = right_COA;
while ~isnan(v)
    lineage = [lineage,v];
    v = right_parent(index_of_ancestors(right_COA));
end