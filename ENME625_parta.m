clear all; close all; clc; warning off;

global alpha sigma epsilon Mmoga CF1 CF2

prompt2 = 'Run full code or see results only? \n 1 - Run Full Code \n 2 - Results only \n';
runType = input(prompt2);

prompt = 'Which Test Problem Do You Want To Run? \n 1 - ZDT1\n 2 - ZDT2 \n 3 - ZDT3 \n 4 - OSY \n 5 - TNK \n 6 - CTP \n';
prob = input(prompt);

%% Load Selected Problem and Optimization Parameters
switch prob
    case 1 % ZDT1
        problem_function = @(X) ZDT1(X);
        problem_constraints = [];
    case 2 %ZDT2
        problem_function = @(X) ZDT2(X);
        problem_constraints = [];
    case 3 %ZDT3
        problem_function = @(X) ZDT3(X);
        problem_constraints = [];
    case 4 %OSY
        problem_function = @(X) OSY(X);
        problem_constraints = @OSYcon;
    case 5 %TNK
        problem_function = @(X) TNK(X);
        problem_constraints = @TNKcon; 
    case 6 %CTP
        problem_function = @(X) CTP(X);
        problem_constraints = @CTPcon; 
    case 7 % Robust TNK
        DP=1;
        problem_function = @(X) TNK_Robust(X,DP);
    otherwise 
        problem_function = @(X) 0;
end
%Load Parameters for desired test problem
[params,A,b,Aeq,beq,LB,UB,true_P] = FuncParams(prob);
nvar = params(1); nRun = params(2); nChrome = params(3);
if length(params)>5
    alpha = params(4); sigma = params(5); epsilon = params(6);
else
    CF1 = params(4); CF2 = params(5); 
end

if runType == 1
    %% Matlab's MOGA

    options = optimoptions('gamultiobj','PopulationSize', nChrome,'CrossoverFcn', @crossoverscattered,'Display', 'final','PlotFcn', { @gaplotpareto },'ParetoFraction', 0.9);
    Mmoga = 1;
    [Xmoga,Fmoga] = gamultiobj(problem_function,nvar,A,b,Aeq,beq,LB,UB,problem_constraints,options);
    Mmoga = 0;

    figure
    plot(Fmoga(:,1),Fmoga(:,2),'bo','LineWidth',2);
    hold on

    %% Our MOGA
    Pareto = [];
    options = optimoptions(@ga,'PopulationSize',nChrome,'UseVectorized',true,'CrossoverFraction', 0.90);
    optF =[]; optX = [];
    for gen = 1:nRun
        Obj_fcn = @(X) fitFCN5(X,problem_function);
        [X,fval,exitflag,output] = ga(Obj_fcn,nvar,A,b,Aeq,beq,LB,UB,[],options);
        [optF(gen,:)] = problem_function(X);
        optX(gen,:) = X;
    end
    nfunc = optF(1,end-3);

     P = paretoset(optF(:,1:nfunc)); 
     m = 1;
        for k = 1:length(P)
            if P(k) == 1
                Pareto(m,:) = optF(k,1:2); m = m+1;
            end
        end     

    hold on;
    plot(Pareto(:,1),Pareto(:,2),'gv','LineWidth',2,'MarkerSize',10)
    hold on; grid on; legend('MATLABs MOGA','Our MOGA')
    xlabel('f_1'); ylabel('f_2')
elseif runType == 2
    test = 1;
    load(['results_and_params',num2str(prob),'_nChr',num2str(nChrome),'_nRun',num2str(nRun),'_nTest',num2str(test)])
    close;
    
    figure
    plot(Fmoga(:,1),Fmoga(:,2),'bo','LineWidth',2);
    hold on; 
    plot(Pareto(:,1),Pareto(:,2),'gv','LineWidth',2,'MarkerSize',10)
    hold on; grid on; legend('MATLABs MOGA','Our MOGA')
    xlabel('f_1'); ylabel('f_2')
    
    CD = coverageDifference2(Pareto); %Coverage Difference of Our MOGA
    CD_M = coverageDifference2(Fmoga(:,1:2));  %Coverage Difference of MATLABs MOGA
    
    max_P1 = max(true_P(:,1)); min_P1 = min(true_P(:,1));
    max_P2 = max(true_P(:,2)); min_P2 = min(true_P(:,2));
    
    OS = ParetoSpread(Pareto,[max_P1 max_P2],[min_P1 min_P2]); %Pareto Spread of Our MOGA
    OS_M = ParetoSpread(Fmoga,[max_P1 max_P2],[min_P1 min_P2]); %Pareto Spread of MATLABs MOGA

end