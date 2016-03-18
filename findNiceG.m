clear

p_opts = linspace(.01,1,5);
for p1 = p_opts
    for p2 = p_opts
        for p3 = p_opts
            for p4 = p_opts
                for p5 = p_opts
                    p = [p1,p2,p3,p4,p5];
                    p = p/sum(p);
                    G = @(x) p(1)*x+p(2)*x.^2+p(3)*x.^3+p(4)*x.^4+p(5)*x.^5;
                    h = @(x) 1-G(1-G(x))-x;
                    z = zeros(1,100);
                    y = linspace(0,1,100);
                    for k = 1:100
                        z(k) = fzero(h,y(k));
                    end
                    z = round(z,2);
                    z = unique(z);
                    z = z(z>=0 & z<=1);
                    if length(z)> 6
                        disp('z')
                        disp(z);
                        disp('p');
                        disp(p);
                    end
                end
            end
        end
    end
end
