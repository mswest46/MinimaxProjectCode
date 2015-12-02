function pair = AUGMENT(pair, aug_path)

if mod(length(aug_path),2)
    error('something is wrong')
end

for i = 1: length(aug_path) - 1
    if mod(i,2) % i is odd
        pair(aug_path(i)) = aug_path(i+1);
        pair(aug_path(i+1)) = aug_path(i);
    end
end
