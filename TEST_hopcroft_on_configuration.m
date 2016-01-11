distribution.type = 'custom';
distribution.params = [0, 0,1];

adjacency_matrix = create_configuration_model(1000,distribution);
matching_matrix = hopcroft_karp(adjacency_matrix);

temp = linspace(0,2*pi,1000);
xy = [cos(temp)',sin(temp)'];
gplot(adjacency_matrix,xy);
hold on;
gplot(matching_matrix,xy);