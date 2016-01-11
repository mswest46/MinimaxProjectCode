function values = R22(x,p)

values = R(R(x,p),p);

end

function values = R(x,p)

values = ones(1, length(x)) - p*x./(ones(1,length(x))-(1-p)*x);

end
