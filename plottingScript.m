%%
clear
close all;
syms x
for p = linspace(.45,.65,10)

params = [0,p,0,1-p];
G = getPGFfromParams(params);
R = 1-G;
star = double(solve(x-R(x),'real',true));
R2 = R(R);
h(x) = R2-x;
s = linspace(0,1);
figure;
plot(s,h(s));
hold on
plot(s,zeros(1,100));
title(num2str(p));
plot(star,0,'*');
end

%%
clear
close all;
syms x
for p = linspace(0,1,10)

G(x) = (1-p)/(1-p*x);
R(x) = 1-G;
star = double(solve(x-R(x),'real',true));
R2 = R(R);
h(x) = R2-x;
s = linspace(0,1);
figure;
plot(s,h(s));
hold on
plot(s,zeros(1,100));
title(num2str(p));
plot(star,0,'*');
end
%%
%Plot of p1 = p, p3 = 1-p for p = linspace(.5,.9,10)
clear
close all

load('~/Data/Dissertation/Simulations/Simulation022/data.mat')

params = data.params;
params = cell2mat({data.params}');
shapeData.p = reshape(params(:,2),[5,10]);
numNodes = reshape([data.num_nodes],[5,10]);
numVinMatching = reshape([data.numVM],[5,10]);
numVinWinning = reshape([data.numV],[5,10]);

shapeData.matchingProp = numVinMatching./numNodes;
shapeData.winningProp = numVinWinning./numNodes;
hold on
for i = 1:10
    plot(shapeData.p(:,i),shapeData.winningProp(:,i), 'b*');
end

SavePlotToFile('varying_p1_small_sample','~/Documents/Dissertation/images');


%%
% Plot of p1 = .56, p3 = 1-p1 with 500k node
clear
close all

load('~/Data/Dissertation/Simulations/Simulation043/data.mat')
numNodes = [data.num_nodes];
p = .56;
numVinMatching = [data.numVM];
numVinWinning = [data.numV];
hold on
plot(repmat(p,100),numVinWinning./numNodes, 'b*');
plot(repmat(p,100),numVinMatching./numNodes, 'r*');
figure;
plot(numVinMatching./numNodes,numVinWinning./numNodes,'*');

%%
% plot of p1 = .52,.56, p3 = 1-p3 with 1 million nodes;
clear
close all

load('~/Data/Dissertation/Simulations/Simulation035/data.mat')
params = data.params;
params = cell2mat({data.params}');
shapeData.p = reshape(params(:,2),[10,2]);
numNodes = reshape([data.num_nodes],[10,2]);
numVinMatching = reshape([data.numVM],[10,2]);
numVinWinning = reshape([data.numV],[10,2]);

shapeData.matchingProp = numVinMatching./numNodes;
shapeData.winningProp = numVinWinning./numNodes;
hold on
for i = 1:2
    plot(shapeData.p(:,i),shapeData.winningProp(:,i), 'b*');
end


%% 
% plot of p1 = p, p3 = 1-p for p = linspace(.5,.65)
clear
close all

load('~/Data/Dissertation/Simulations2/Simulation001/data.mat')

params = cell2mat({data.params}');
shapeData.p = reshape(params(:,2),[10,10]);
numNodes = reshape([data.num_nodes],[10,10]);
numVinMatching = reshape([data.numVM],[10,10]);
numVinWinning = reshape([data.numV],[10,10]);

shapeData.matchingProp = numVinMatching./numNodes;
shapeData.winningProp = numVinWinning./numNodes;
hold on
for i = 1:10
    plot(shapeData.p(:,i),shapeData.winningProp(:,i), 'b*');
end
title('Proportion of Vertices in Maximum Matching');
xlabel('p');
ylabel('Proportion');
SavePlotToFile('critical_region_medium_sample','~/Documents/Dissertation/images/');

%%
% plot of p1 = p, p3 = 1-p for p = linspace(.5,.65)
clear
close all

load('~/Data/Dissertation/Simulations/Simulation044/data.mat')

params = cell2mat({data.params}');
shapeData.p = reshape(params(:,2),[10,10]);
numNodes = reshape([data.num_nodes],[10,10]);
numVinMatching = reshape([data.numVM],[10,10]);
numVinWinning = reshape([data.numV],[10,10]);

shapeData.matchingProp = numVinMatching./numNodes;
shapeData.winningProp = numVinWinning./numNodes;
hold on
for i = 1:10
    plot(shapeData.p(:,i),shapeData.winningProp(:,i), 'b*');
end
title('Proportion of Vertices in Maximum Matching');
xlabel('p');
ylabel('Proportion');
SavePlotToFile('critical_region_bipartite_medium_sample','~/Documents/Dissertation/images/');




