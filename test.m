clear all; 
% close all;
clc;
warning off

global nvar

nvar = 30;
nChrome = 15;
A = []; b = [];
Aeq = []; beq = [];
LB = zeros(1,nvar); UB = ones(1,nvar);
V = nvar; %Number of design variables
C = nChrome*nvar; %Number of Chromosomes

%% Initilize Population
%Initialize the population based on the given lower and upper bounds. Use
%MATLABs random number generator.
for k = 1:C
    for j = 1:nvar
        pop(k,j) = LB(j)+(UB(j)-LB(j))*rand;    
    end
end
options = optimoptions(@gamultiobj,'InitialPopulationMatrix',pop);
[Xmoga,Fmoga] = gamultiobj(@ZDT1,nvar,A,b,Aeq,beq,LB,UB,[],options);

figure
plot(Fmoga(:,1),Fmoga(:,2),'bo','LineWidth',2);
hold on

%% 
%while coverageDistance(pareto_points)> 0.05

pareto_points = zeros(10,2);

%CD = @(X,pareto_points) coverageDifference([f1(X),f1(pareto_points(:,1))],[f2(X),pareto_points(:,2)]);


for i=1:10
    if i > 1
        F_metric = @(X) coverageDifference2([ZDT1(X);pareto_points]);
        F_obj = @(X) sum(ZDT1(X)) + F_metric(X);
    else
        F_obj = @(X) sum(ZDT1(X));
    end
    vals = ga(F_obj,nvar,A,b,Aeq,beq,LB,UB,[],options);
    pareto_points(i,:)= ZDT1(vals);
end

plot(pareto_points(:,1),pareto_points(:,2),'*')