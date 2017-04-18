function MasterCode(prob,nChrome,nRun,save_figure);
%clear all; 
% close all;
clc;
warning off

if(nargin < 1)
    prompt = 'Which Test Problem Do You Want To Run? \n 1 - ZDT1\n 2 - ZDT2 \n 3 - ZDT3 \n 4 - OSY \n';
    prob = input(prompt);
end
if nargin <2
    prompt2 = 'How Many Chromosomes? Suggest 20-30 ';
    nChrome = input(prompt2);
end
if nargin <3
    prompt3 = 'How Many Runs? Suggest >40: ';
    nRun = input(prompt3);
end
if nargin <4
    prompt4 = 'Autosave figures [ 1 or 0 ]?';
    save_figure=input(prompt4);
end

%%
%prob=1; nChrome = 1; nRun = 40;



% ZD-func is our problem function
switch prob
    case 1
        problem_function = @(X) ZDT1(X);
        nvar = 30; LB = zeros(1,nvar); UB = ones(1,nvar);
    case 2 
        problem_function = @(X) ZDT2(X);
        nvar = 30; LB = zeros(1,nvar); UB = ones(1,nvar);
    case 3
        problem_function = @(X) ZDT3(X);
        nvar = 30; LB = zeros(1,nvar); UB = ones(1,nvar);
    case 4
        problem_function = @(X) OSY(X);
        nvar = 6; LB = [0,0,1,0,1,0]; UB = [10,10,5,6,5,10];
    case 5 
        problem_function = @(X) TNK(X);
        nvar = 2; LB = [0,0]; UB=[pi,pi];
    case 6
        problem_function = @(X) CTP(X);
        nvar = 10; LB = -5*ones(1,10); UB = 5*ones(1,10); LB(1,1) = 0; UB(1,1) = 1;
    otherwise 
        problem_function = @(X) 0;
end

A = []; b = []; Aeq = []; beq = [];
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
% % options = optimoptions(@gamultiobj,'InitialPopulationMatrix',pop);
% [Xmoga,Fmoga] = gamultiobj(problem_function,nvar,A,b,Aeq,beq,LB,UB,[]);
% figure
% plot(Fmoga(:,1),Fmoga(:,2),'bo','LineWidth',2);
% hold on


Pareto = [];
options = optimoptions(@ga,'PopulationSize',nChrome,'UseVectorized',true);
optF =[];
for gen = 1:nRun
    Obj_fcn = @(X) fitFCN5(X,problem_function);
    [X,fval,exitflag,output] = ga(Obj_fcn,nvar,A,b,Aeq,beq,LB,UB,[],options);
    [optF(gen,:)] = problem_function(X);
    optX(gen,:) = X;
end
nfunc = optF(1,end-2);

 P = paretoset(optF(:,1:nfunc)); 
 m = 1;
    for k = 1:length(P)
        if P(k) == 1
            Pareto(m,:) = optF(k,1:2); m = m+1;
        end
    end     

figure
hold on;
plot(Pareto(:,1),Pareto(:,2),'gv','LineWidth',2,'MarkerSize',10);
plot(optF(:,1),optF(:,2),'r*','LineWidth',2)
hold on; grid on;
xlabel('f_1'); ylabel('f_2')
handle = gcf;
if save_figure == 1
    dir_val = pwd;
    saveFigure(handle,[dir_val,dir_val(1),num2str(prob),'_',num2str(nChrome,'%03.0f'),'_',num2str(nRun,'%04.0f')]);
    print([dir_val,dir_val(1),num2str(prob),'_',num2str(nChrome,'%03.0f'),'_',num2str(nRun,'%04.0f'),'.png'],'-dpng');
end

