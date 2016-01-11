%%

pvals = 0:.1:1;
xvals = 0:.01:1;
l = length(xvals);
outputs = zeros(length(pvals), l);
for i = 1:length(pvals);
    p = pvals(i);
    for j = 1:l
    outputs(i,j) = 1-geometric_pgf(p,(1-geometric_pgf(p,xvals(j))));
    end
end


hold on
for i = 1:length(pvals)
    plot(xvals,outputs(i,:));
end
legend TOGGLE
hold off

%%

xvals = 0:.01:1;
l = length(xvals);
outputs = zeros(1, l);
p = .5;
for j = 1:l
    outputs(j) = geometric_pgf(p, xvals(j));
end

hold on 
plot(outputs);

outputs2 = repmat(p,1,l).*xvals./(ones(1,l)-(1-p).*xvals);

plot(outputs2);

hold off


%%

plot(0:.01:1,R2(0:.01:1,p, 1000));

