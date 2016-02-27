function display_degree_distribution(A)

degrees = full(sum(A));
m = max(degrees);
p = zeros(1,m+1);
for i = 0:m
    p(i+1) = sum(degrees==i);
end
p = p/sum(p);
disp(p);
    