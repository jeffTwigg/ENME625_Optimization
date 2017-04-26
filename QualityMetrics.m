close all; clear all; clc;

prompt = 'Which problem to Evaluate?  \n 1 - ZDT1\n 2 - ZDT2 \n 3 - ZDT3 \n 4 - OSY \n 5 - TNK \n 6 - CTP \n';
prob = input(prompt);

for test = 1:10
   
    %% ZDT1
    if prob == 1
        nChrome = 300; nRun = 100;
        X_true = zeros(100,30);
        X_true(:,1) = linspace(0,1,100);
        true_P = ZDT1(X_true);     
   %% ZDT2
   elseif prob == 2
        nChrome = 300; nRun = 100;
        X_true = zeros(100,30);
        X_true(:,1) = linspace(0,1,100);
        true_P = ZDT2(X_true);
    %% ZDT3
   elseif prob == 3
        nChrome = 300; nRun = 100;
        X_true = zeros(100,30);
        X_true(:,1) = linspace(0,1,100);
        true_P = ZDT3(X_true);
    %% OSY
    elseif prob == 4
        nChrome = 60; nRun = 1000;
        true_P = [5,-275;75,-45];
        
    %% TNK
    elseif prob == 5
        nChrome = 40; nRun = 200;
        true_P = [1,0;0,1];
    %% CTP
    elseif prob == 6
        nChrome = 100; nRun = 100;        
        true_P = [1,0;0,1];
    end
    load(['results_and_params',num2str(prob),'_nChr',num2str(nChrome),'_nRun',num2str(nRun),'_nTest',num2str(test)])
    
    
    figure
    plot(Fmoga(:,1),Fmoga(:,2),'bo','LineWidth',2);
    hold on
    hold on; 
    plot(Pareto(:,1),Pareto(:,2),'gv','LineWidth',2,'MarkerSize',10)
%     plot(optF(:,1),optF(:,2),'r*','LineWidth',2)
    hold on; grid on; legend('MATLABs MOGA','Our MOGA')
    xlabel('f_1'); ylabel('f_2')
    
    CD(test) = coverageDifference2(Pareto);
    CD_M(test) = coverageDifference2(Fmoga(:,1:2));  

    OS(test) = ParetoSpread(Pareto,[max(true_P(:,1)) max(true_P(:,2))],[min(true_P(:,1)) min(true_P(:,2))]);
    OS_M(test) = ParetoSpread(Fmoga,[max(true_P(:,1)) max(true_P(:,2))],[min(true_P(:,1)) min(true_P(:,2))]);
    
    
end