%%
%Test elfunction


%AC

 


% Problem
f1 =@(X) X(1);
g = @(X) 1 + 9/(length(X)-1)*sum(X(2:end));
h = @(X) 1 - sqrt(f1(X)/g(X));
f2 = @(X) g(X)*h(X);



F = @(X) f1(X) +f2(X) + AC;

n = 30;


A=[];
b=[];
Aeq=[];
beq=[];
lb =0;
ub =1;


%m=1
%while coverageDistance(pareto_points)> 0.05

pareto_points = zeros(10,2);

CD = @(X,pareto_points) coverageDifference([f1(X),f1(pareto_points(:,1))],[f2(X),pareto_points(:,2)]);


for i=1:10
    if i > 1
        %F = @(X) f1(X) +f2(X) + CD(X,pareto_points(:,1:i));
        F = @(X) f1(X) +f2(X) + CD(X);
    else
        F = @(X) f1(X) +f2(X);
    end
    vals = ga(F,n,A,b,Aeq,beq,lb,ub);
    f1_val = real(f1(vals));
    f2_val = real(f2(vals));
    pareto_points(i,:) = [f1_val,f2_val];
end

plot(pareto_points(:,1),pareto_points(:,2),'*')