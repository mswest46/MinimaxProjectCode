function path = OPEN(vx, find_path_struct)

B = find_path_struct.bloom(vx);
if isnan(B)
    error('not in bloom')
end

b = find_path_struct.base(B);
if mod(find_path_struct.level(vx),2)==0 % is outer
    path = FINDPATH(vx, b, B, find_path_struct);
else
    l = find_path_struct.left_peak(B);
    r = find_path_struct.right_peak(B);
    if find_path_struct.bloom_ownership(vx) == 1;
        p1 = FINDPATH(l, vx, B, find_path_struct); %path from left_peak to vx.
        p2 = FINDPATH(r, b, B, find_path_struct); % path from right_peak to base
        path = [flip(p1),p2];
    
    elseif find_path_struct.bloom_ownership(vx) == 2;
        p1 = FINDPATH(r, vx, B,find_path_struct);
        p2 = FINDPATH(l, b, B, find_path_struct);
        path = [flip(p1), p2];
    else
        error('you done fucked up michael');
    end
end
end