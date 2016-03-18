function [endogeny,matchingProp,winningProp,z1,z2] = getDetails(par)
winningProp = 0;
z1 = 0; z2 = 0;
% params is input in [p0,p1,p2,...] form, the offspring distribution,
% display the expected number of vertices in the matching.
bias_par = size_bias(par);
bias_g = @(x) polyval(flip(bias_par),x);
g_dash = @(x) polyval(polyder(flip(bias_par)),x);
F = @(x) x.*g_dash(1-x) + bias_g(1-x) + bias_g(1-g_dash(1-x)/g_dash(1))-1;
s = linspace(0,1,100000);
m = max(F(s));
matchingProp = (1-m);
% disp('matchingProp is')
% disp(matchingProp);

% find out if the starred point is endogenous.
R = @(x) 1-polyval(flip(par),x);
R2 = @(x) R(R(x));
R_minus_x = @(x) R(x) - x;
R2_minus_x = @(x) R2(x) - x;
star = fzero(R_minus_x,.5);
endogeny = R2(star+.01)<star+.01;
% disp(endogeny);

% if yes, display the expected proportion of vertice in the winning set.
% if no, display the expected proportion of vertices in the winning set
% if BCs are on either side of the starred point.

bias_R = @(x) 1-polyval(flip(size_bias(par)),x);
if endogeny
    winningProp = bias_R(star);
    %     disp(winningProp);
    
else
    % look for the zeros of R2 on either side of star.
    if par(2)>.57
        1;
    end
    l = linspace(0,1,100);
    for i = 1:100
        z1 = fzero(R2_minus_x,star-l(i));
        if round(z1,5)<round(star,5)
            break
        end
    end
    z1 = bias_R(z1);
    for i = 1:100
        z2 = fzero(R2_minus_x,star+l(i));
        if round(z2,5)>round(star,5)
            break
        end
    end
    z2 = bias_R(z2);
end

