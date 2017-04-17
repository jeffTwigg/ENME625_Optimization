



%new_point = [6  2];
%existing_points=[ 3 22 ; 1 14 ; 4 15  ;5 5 ; 2 20];
%
new_point = [];
points = [ 1 14;5 5; 6 2; 4 15;2 20; 3 22];

V= 30;

ZD_func = @(X) X+0;

%[fit_value, fitness_vals] = fitFCN4_test(new_point, ZD_func, V,existing_points);

[fit_value, fitness_vals] = getFitness([],points);


plot(fitness_vals(:,1),fitness_vals(:,2),'*')