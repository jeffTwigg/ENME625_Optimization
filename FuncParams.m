function [ params,A,b,Aeq,beq,LB,UB,true_P ] = FuncParams( prob )
% Return the chosen optimization parameters given the problem number

switch prob
    case 1 % ZDT1
        nvar = 30; LB = zeros(1,nvar); UB = ones(1,nvar);
        A = []; b = []; Aeq = []; beq = [];
        nRun = 100; nChrome = 300;
        alpha = 1; sigma = 0.158;
        epsilon = 0.22;
        CF1 = []; CF2 = [];
        X_true = zeros(100,30);
        X_true(:,1) = linspace(0,1,100);
        true_P = ZDT1(X_true);
        DP=[];
    case 2 %ZDT2
        nvar = 30; LB = zeros(1,nvar); UB = ones(1,nvar);
        A = []; b = []; Aeq = []; beq = [];
        nRun = 100; nChrome = 300;
        alpha = 0.5; sigma = 0.5;
        epsilon = 0.22;
        CF1 = []; CF2 = [];
        X_true = zeros(100,30);
        X_true(:,1) = linspace(0,1,100);
        true_P = ZDT2(X_true);
        DP=[];
    case 3 %ZDT3
        nvar = 30; LB = zeros(1,nvar); UB = ones(1,nvar);
        A = []; b = []; Aeq = []; beq = [];
        nRun = 100; nChrome = 300;
        alpha = 1; sigma = 0.158;
        epsilon = 0.22;
        CF1 = []; CF2 = [];
        X_true = zeros(100,30);
        X_true(:,1) = linspace(0,1,100);
        true_P = ZDT3(X_true);
        DP=[];
    case 4 %OSY
        nvar = 6; LB = [0,0,1,0,1,0]; UB = [10,10,5,6,5,10];
        A = [-1 -1 0 0 0 0;1 1 0 0 0 0;-1 1 0 0 0 0;1 -3 0 0 0 0]; 
        b = [-2;6;2;2];
        Aeq = []; beq = [];
        nChrome = 60; nRun = 1000;
        alpha=[]; sigma=[]; epsilon=[];
        true_P = [5,-275;75,-45];
        CF1 = 0.005; CF2 = 0.015;
        DP=[];
    case 5 %TNK
        nvar = 2; LB = [0,0]; UB=[pi,pi];
        A = []; b = []; Aeq = []; beq = [];
        nChrome = 40; nRun = 200;
        alpha=[]; sigma=[]; epsilon=[];
        true_P = [1,0;0,1];
        CF1 = 0.01; CF2 = 0.01;
        DP=[];
    case 6 %CTP
        nvar = 10; LB = -5*ones(1,10); UB = 5*ones(1,10); LB(1,1) = 0; UB(1,1) = 1;
        A = []; b = []; Aeq = []; beq = [];
        nChrome = 100; nRun = 100;    
        alpha=[]; sigma=[]; epsilon=[];
        true_P = [1,0;0,1];
        CF1 = 0.01; CF2 = 0.01;
        DP=[];
    case 7 % Robust TNK
        nvar = 2; LB = [0,0]; UB=[pi,pi];
        %Find Maximize DP
        X = [pi/2,pi/2]; pop=20;
        constraint_function = @(X,DP) -robust_TNK_constraints(X,DP);
        DP = maximumDeltaP(X,[1.0,1.0],[-2,2;-2,2],constraint_function,pop);
        A = []; b = []; Aeq = []; beq = [];
        nChrome = 40; nRun = 200;
        alpha=[]; sigma=[]; epsilon=[];
        true_P = [1,0;0,1];
        CF1 = 0.01; CF2 = 0.01;
    otherwise 
end

params = [nvar,nRun,nChrome,alpha,sigma,epsilon,CF1,CF2,DP];
end