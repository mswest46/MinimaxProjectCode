function check_path_is_along_edges(G,path)

flag = false;

for i = 1:length(path)-1
    if isempty(G.get_e_from_vs(path(i),path(i)+1))
        disp('problem on vx:',num2str(i));
        flag = true;
    end
end

assert(~flag);