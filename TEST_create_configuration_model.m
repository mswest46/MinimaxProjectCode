% calculate the degree distribution of this bad boy and see if it's close. 

clear

import matlab.unittest.qualifications.Verifiable
import matlab.unittest.constraints.IsEqualTo;
import matlab.unittest.constraints.AbsoluteTolerance;
import matlab.unittest.constraints.RelativeTolerance;

distribution.type = 'custom';
params = [0,0,.9,0,0,0,.1];
distribution.params = params;
num_nodes = 10^6;

adjacency_matrix = create_configuration_model(num_nodes,distribution);

degrees = sum(adjacency_matrix);
test_params = zeros(1,length(distribution.params));

for i = 1: length(test_params)-1
    test_params(i+1) = sum(degrees == i);
end
test_params = test_params/sum(test_params);
tol = .01;

assert(all(abs(test_params-params)<tol));

% 
% assert(isequal(test_params,params));


% abstol = .01 * ones(1: length(test_params));
% verifiable.verifyThat(params, IsEqualTo(test_params, ...
%     'Within', AbsoluteTolerance(abstol)));