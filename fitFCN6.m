function [ fit ] = fitFCN6(X, ZD_func,existing_points)
%NSGA algorithm. Use Approach 1 for sorting


possible_points = ZD_func(X);

[rows,cols] = size(possible_points);


if isempty(existing_points)
    fit = sum(possible_points,2);
    return
end

fit = zeros(rows,1);
for i = 1:rows
    new_point = possible_points(i,:);
    fit(i,1) = -getFitness(existing_points,new_point);
end
return
    
    
    
    