function path = FINDPATH(...
    parent, high_vx, low_vx)

% For now, assuming no blossoms, we can take red_parent and green_parent
% from DDFS. We'll have to do more work later. 

path = zeros(1,100);
path_position = 0;

v = low_vx;

while true
    path_position = path_position + 1;
    if path_position > 100
        path = [path, zeros(1,1000)];
    end
    path(path_position) = v;
    if v == high_vx
        break
    end
    v = parent(v);
end

path(path == 0 ) = [];