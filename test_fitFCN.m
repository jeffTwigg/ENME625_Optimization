



new_point = [0.5 1];
existing_points=[0 1 ; 1 2 ; 3 2 ; 4 0 ; 2 2 ;...
    1 1 ; 2 1 ; 0 2; 4 4];

V= 30;

ZD_func = @(X) X+0;

[fit_value, fitness_vals] = fitFCN4(new_point, ZD_func, V,existing_points);

plot(fitness_vals(:,1),fitness_vals(:,2),'*')