function path = OPEN(vx, find_path_struct)

B = find_path_struct.bloom(vx);

if isnan(B)
    error('not in bloom')
end
level = @(v) min(find_path_struct.even_level(v),...
    find_path_struct.odd_level(v));

b = find_path_struct.base(B);
if mod(level(vx),2)==0 
    % if vx is outer, we don't need to go around the blossom. 
    path = FINDPATH(vx, b, B, find_path_struct);
else % we need to loop around the blossom.
    l = find_path_struct.left_peak(B);
    r = find_path_struct.right_peak(B);
    if find_path_struct.ownership(vx) == 1; % on left side of blossom
        p1 = FINDPATH(l, vx, B, find_path_struct); %path from left_peak to vx.
        p2 = FINDPATH(r, b, B, find_path_struct); % path from right_peak to base
        path = [flip(p1),p2];
    elseif find_path_struct.ownership(vx) == 2; % on right side of blossom
        p1 = FINDPATH(r, vx, B,find_path_struct); % path from right_peak to vx. 
        p2 = FINDPATH(l, b, B, find_path_struct); % path from left_peak to base. 
        path = [flip(p1), p2];
    else
        error('something has gone horribly, horribly wrong');
    end
end
end