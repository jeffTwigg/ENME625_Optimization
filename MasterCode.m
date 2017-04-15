clear all; 
% close all;
clc;
warning off


prompt = 'Which Test Problem Do You Want To Run? \n 1 - ZDT1\n 2 - ZDT2 \n 3 - ZDT3 \n';
prob = input(prompt);
prompt2 = 'How Many Chromosomes? Suggest 30*# variables ';
nChrome = input(prompt2);
prompt3 = 'How Many Runs? Suggest >10: ';
nRun = input(prompt3);
%%
%prob=1; nChrome = 1; nRun = 40;



% ZD-func is our problem function
switch prob
    case 1
        problem_function = @(X) ZDT1(X);
    case 2 
        problem_function = @(X) ZDT2(X);
    case 3
        problem_function = @(X) ZDT3(X);
    otherwise 
        problem_function = @(X) 0;
end
nvar = 30;
A = []; b = [];
Aeq = []; beq = [];
LB = zeros(1,nvar); UB = ones(1,nvar);

V = nvar; %Number of design variables

%% Initilize Population
%Initialize the population based on the given lower and upper bounds. Use
%MATLABs random number generator.
pop = zeros(nChrome,nvar);
for k = 1:nChrome
    for j = 1:nvar
        pop(k,j) = LB(j)+(UB(j)-LB(j))*rand;    
    end
end
% options = optimoptions(@gamultiobj,'InitialPopulationMatrix',pop,'PopulationSize',5000);
% options = optimoptions(@gamultiobj,'InitialPopulationMatrix',pop);
% [Xmoga,Fmoga] = gamultiobj(problem_function,nvar,A,b,Aeq,beq,LB,UB,[]);
% figure(1)
% % plot(Fmoga(:,1),Fmoga(:,2),'bo','LineWidth',2);
% hold on


Pareto = [];
options = optimoptions(@ga,'PopulationSize',nChrome,'UseVectorized',true);
optF =[];
for gen = 1:nRun
    Obj_fcn = @(X) fitFCN5(X,problem_function);
    %Obj_fcn = @(X) fitFCN2(X,problem_function,V);
    [X,fval,exitflag,output] = ga(Obj_fcn,nvar,A,b,Aeq,beq,LB,UB,[],options)
    [optF(gen,:)] = problem_function(X);
    %func = optF(gen,:);
    optX(gen,:) = X;
end
[P,~] = prtp(optF);
Pareto = [Pareto;P];

figure
hold on;
plot(Pareto(:,1),Pareto(:,2),'gv','LineWidth',2,'MarkerSize',10)
plot(optF(:,1),optF(:,2),'r*','LineWidth',2)
hold on; grid on;
xlabel('f_1'); ylabel('f_2')


