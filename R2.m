function values = R2(x, p , sumSize)
values = R1(R1(x, p, sumSize), p, sumSize);
end

function values = R1(x, p, sumSize)
for i = 1:length(x)
    values(i) = 1- sum((repmat(x(i),1,sumSize).^(0:sumSize-1)) ...
    .* (p*repmat((1-p),1,sumSize).^(0:sumSize-1)));
end

end
