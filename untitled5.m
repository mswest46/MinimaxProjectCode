
clear
close all;
syms x
params = [0,0,.5,0,0,0,0,0,0,.5];
G = getPGFfromParams(params);
figure;
ezplot(1-G,[0,1]);
hold on
R2 = 1-G(1-G);
ezplot(R2,[0,1]);
hold off

figure;
ezplot(1-G,[0,1]);
sols = double(solve(x-R2,'real',true));
p = sols(sols> 0 & sols < 1);
h = getHfromG(G,p);
figure;

x = linspace(0,min(p,1-p));
plot(x,h(x))
hold on
plot(x,x)

figure;
plot(x,-(1-G(.5-x)))

