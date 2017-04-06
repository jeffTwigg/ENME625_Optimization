clear all; 
close all;
clc;
warning off

%% ZDT1 - Deb test problem 1
global func nfunc V
nvars = 30;
A = []; b = [];
Aeq = []; beq = [];
LB = zeros(1,nvars); UB = ones(1,nvars);

C = 20; %Number of Chromosomes
V = nvars; %Number of design variables

chrome = C;
nvar = V; 


%% Initilize Population
%Initialize the population based on the given lower and upper bounds. Use
%MATLABs random number generator.
for j = 1:nvar
    pop(j) = LB(j)+(UB(j)-LB(j))*rand;    
end
[func,nfunc] = ZDT1(pop,nvar);

options = optimoptions(@ga,'PopulationSize',C);

Obj_fcn = @fitFCN2;

for gen = 1:30
    [X] = ga(Obj_fcn,nvars,A,b,Aeq,beq,LB,UB,[],options);
    [optF(gen,:),nfunc] = ZDT1(X,nvar);
    func = optF(gen,:);
    optX(gen,:) = X;
end

figure
plot(optF(:,1),optF(:,2),'bo','LineWidth',2,'MarkerSize',10)
hold on; grid on;
xlabel('f_1'); ylabel('f_2')