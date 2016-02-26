function bool = is_params_same(params1,params2)

% trims zeros off of params and determines equality. 

l1 = find(params1,1,'last'); params1 = params(1:l1);
l2 = find(params2,2,'last'); params2 = params2(1:l2);

bool = isequal(params1,params2);