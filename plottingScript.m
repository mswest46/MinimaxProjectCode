%%
clear
close all;
syms x
for p = linspace(.45,.65,10)

params = [0,p,0,1-p];
G = getPGFfromParams(params);
R = 1-G;
star = double(solve(x-R(x),'real',true))
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

