function sample = custom_random_sample(distribution, size)
% random_sample - returns a sample of given size drawn from the given
% distribution
%
% Inputs:
%    size - an integer specifying the number of individual samples we wish
%    to take from the distribution
%    distribution - TODO an array specifying the
%    distribution of the number of children from a node
%
% Outputs:
%    sample - an array of given size containing samples from the given
%    distribution
%
% Example: 
%    sample = custom_random_sample([0,.25,.25,.25,0,.25], 5)
%    returns [1, 1 , 2, 5, 3]
distribution = distribution/sum(distribution);
cumDist = [cumsum(distribution) 1]; % CDF corresponding to the pmf
randUni = rand(1, size); % uniform random numbers
sample = zeros(1, size); % 

% probably a nicer way to do this, i.e. no loop and no conditioning.
for i = 1:size
    temp = find(cumDist<randUni(i), 1, 'last');
    if ~isempty(temp)
        sample(i) = temp;
    else sample (i) = 0;
    end
end

