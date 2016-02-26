% for comparison, the vazirani algorithm is taking around .003 seconds per

num_nodes = 10^6;

pair = struct('num',{0},'nothing',{0});
for i = 1:10^4
    pair = change_pair(pair);
end


disp('yo');
pair = zeros(1,num_nodes);

for i = 1:10^4
    pair = change_pair(pair);
end

