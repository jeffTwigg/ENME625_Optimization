clear all; 
% close all;
clc;
warning off

global V nvar pop prob w1 w2
prompt = 'Which Test Problem Do You Want To Run? \n 1 - ZDT1\n 2 - ZDT2 \n 3 - ZDT3 \n';
prob = input(prompt);
prompt2 = 'How Many Chromosomes? Suggest 10-20 ';
nChrome = input(prompt2);
prompt3 = 'How Many Runs? Suggest >30: ';
nRun = input(prompt3);

if prob == 1
%% ZDT1 - Deb test problem 1

nvar = 30;
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


Pareto = [];
options = optimoptions(@ga,'PopulationSize',C);
Obj_fcn = @fitFCN3;
optF_all=[];optX_all=[];
for w1 =0:0.1:1
    w2 = 1-w1;
    for gen = 1:nRun
        [X] = ga(Obj_fcn,nvar,A,b,Aeq,beq,LB,UB,[],options);
        [optF(gen,:)] = ZDT1(X);
        optX(gen,:) = X;
    end
    optF_all = [optF_all; optF];
    optX_all = [optX_all; optX];
end
[P,~] = prtp(optF_all);
Pareto = [Pareto;P];

plot(Pareto(:,1),Pareto(:,2),'gv','LineWidth',2,'MarkerSize',10)
% plot(optF_all(:,1),optF_all(:,2),'r*','LineWidth',2)
hold on; grid on;
xlabel('f_1'); ylabel('f_2')

elseif prob == 2
%% ZDT2 - Deb test problem 2

nvar = 30;
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
[Xmoga,Fmoga] = gamultiobj(@ZDT2,nvar,A,b,Aeq,beq,LB,UB,[],options);

figure
plot(Fmoga(:,1),Fmoga(:,2),'bo','LineWidth',2);
hold on


Pareto = [];
options = optimoptions(@ga,'PopulationSize',C);
Obj_fcn = @fitFCN3;
for gen = 1:nRun
    [X] = ga(Obj_fcn,nvar,A,b,Aeq,beq,LB,UB,[],options);
    [optF(gen,:)] = ZDT2(X);
    optX(gen,:) = X;
end
[P,~] = prtp(optF);
Pareto = [Pareto;P];


plot(Pareto(:,1),Pareto(:,2),'gv','LineWidth',2,'MarkerSize',10)
plot(optF(:,1),optF(:,2),'r*','LineWidth',2)
hold on; grid on;
xlabel('f_1'); ylabel('f_2')

elseif prob == 3
%% ZDT3 - Deb test problem 3

nvar = 30;
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
[Xmoga,Fmoga] = gamultiobj(@ZDT3,nvar,A,b,Aeq,beq,LB,UB,[],options);

figure
plot(Fmoga(:,1),Fmoga(:,2),'bo','LineWidth',2);
hold on; grid on;

Pareto = [];
options = optimoptions(@ga,'PopulationSize',C);
Obj_fcn = @fitFCN3;

for gen = 1:nRun
    [X] = ga(Obj_fcn,nvar,A,b,Aeq,beq,LB,UB,[],options);
    [optF(gen,:)] = ZDT3(X);
    optX(gen,:) = X;
end
[P,~] = prtp(optF);
Pareto = [Pareto;P];


plot(Pareto(:,1),Pareto(:,2),'gv','LineWidth',2,'MarkerSize',10)
plot(optF(:,1),optF(:,2),'r*','LineWidth',2)
hold on; 
xlabel('f_1'); ylabel('f_2')



end


