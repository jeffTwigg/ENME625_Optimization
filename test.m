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

pareto_points = 

for i=1:10
    m=m+1;
    pareto_points
    
    
    
    F = @(X) f1(X) +f2(X) + AC(X,pareto_points);
    pareto_points(i,, = ga(F,n,A,b,Aeq,beq,lb,ub)