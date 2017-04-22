%function [optX,optF]=MasterCode(prob,nChrome,nRun,alpha_,sigma_,epsilon_,save_figure,use_matlabs_moga)
% load .mat file
nargin=0;
current_dir = pwd;
%file_name = 'results_and_params.mat';
if(contains(current_dir,'/ENME625_Optimization')) %linux or mac
    path_prefix = [current_dir, current_dir(1)];
elseif(contains(current_dir,'/ENME625_Optimization')) %windows
    path_prefix = [current_dir, '\'];
else
    fprintf('not running from the correct directory')
    return
end
file_name = [path_prefix,'results_and_params.mat'];
results_and_params = load(file_name);
results_and_params = results_and_params.results_and_params;

global alpha sigma epsilon

if(nargin < 1)
    prompt = 'Which Test Problem Do You Want To Run? \n 1 - ZDT1\n 2 - ZDT2 \n 3 - ZDT3 \n 4 - OSY \n 5 - TNK \n 6 - CTP \n 7 - Robust TNK \n';
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
if nargin < 4
    prompt4 = 'What value for alpha? ';
    alpha = input(prompt4);
else
    alpha = alpha_;
end
if nargin < 5
    prompt5 = 'What value for sigma? (Nominal 0.158) ';
    sigma = input(prompt5);
else
    sigma = sigma_;
end
if nargin < 6
    prompt6 = 'What value for epsilon? (Nominal 0.22) ';
    epsilon = input(prompt6);
else
    epsilon = epsilon_;
end
if nargin <7
    prompt7 = 'Autosave figures [ 1 or 0 ]?';
    save_figure=input(prompt7);
end
if nargin <8
    prompt8 = 'Use Matlabs MOGA [ 1 or 0 ]?';
    use_matlabs_moga=input(prompt8);
end

 problem = results_and_params{prob,1};

% ZD-func is our problem function
switch prob
    case 1
        problem_function = @(X) ZDT1(X);
        nvar = 30; LB = zeros(1,nvar); UB = ones(1,nvar);
        problem_constraints = [];
    case 2 
        problem_function = @(X) ZDT2(X);
        nvar = 30; LB = zeros(1,nvar); UB = ones(1,nvar);
        problem_constraints = [];
    case 3
        problem_function = @(X) ZDT3(X);
        nvar = 30; LB = zeros(1,nvar); UB = ones(1,nvar);
        problem_constraints = [];
    case 4
        problem_function = @(X) OSY(X);
        nvar = 6; LB = [0,0,1,0,1,0]; UB = [10,10,5,6,5,10];
        problem_constraints = @OSY_constraints; % Only used in matlab test
    case 5 
        problem_function = @(X) TNK(X);
        nvar = 2; LB = [0,0]; UB=[pi,pi];
        problem_constraints = @TNK_constraints; % Only used in matlab test

    case 6
        problem_function = @(X) CTP(X);
        nvar = 10; LB = -5*ones(1,10); UB = 5*ones(1,10); LB(1,1) = 0; UB(1,1) = 1;
        problem_constraints = @CTP_constraints; % Only used in matlab test
    case 7 
        DP=1;
        problem_function = @(X,DP) TNK_Robust(X,DP);
        nvar = 2; LB = [0,0]; UB=[pi,pi];
        robust_fitness = @(X,DP) TNK_NEGCN2(X,DP);
    otherwise 
        problem_function = @(X) 0;
end

A = []; b = []; Aeq = []; beq = [];
if use_matlabs_moga ==1
    % Modify options setting
    options = optimoptions('gamultiobj');
    options = optimoptions(options,'PopulationSize', nRun);
    options = optimoptions(options,'CrossoverFcn', @crossoverscattered);
    options = optimoptions(options,'Display', 'final');
    options = optimoptions(options,'PlotFcn', { @gaplotpareto });
    options = optimoptions(options,'ParetoFraction', 0.9);
    indexat = @(expr, index) expr(index);
    problem_function = @(X) indexat(problem_function(X), 1:2);
    [~,optF] = gamultiobj(problem_function,nvar,[],[],[],[],LB,UB,problem_constraints,options);
    %problem.prob = prob; problem.nChrome = nChrome; problem.nRun = nRun;
    problem.matlab_optF = optF;
    results_and_params{prob,1} = problem;
    save(file_name,'results_and_params')
    return
end

Pareto = [];
options = optimoptions(@ga,'PopulationSize',nChrome,'UseVectorized',true,'CrossoverFraction', 0.90);
optF =[];
for gen = 1:nRun
    Obj_fcn = @(X) fitFCN5(X,problem_function);
    if(prob==7);Obj_fcn = @(X) fitFCN5(X,problem_function,robust_fitness);end
    [X,~,~,~] = ga(Obj_fcn,nvar,A,b,Aeq,beq,LB,UB,[],options);
    if(prob==7)
        [optF(gen,:)] = problem_function(X,[0,0]);
    else
        [optF(gen,:)] = problem_function(X);
    end
    optX(gen,:) = X;
end
nfunc = 2; % Making this static because it will not change in this project

P = paretoset(optF(:,1:nfunc));
m = 1;
for k = 1:length(P)
    if P(k) == 1
        Pareto(m,:) = optF(k,1:2); m = m+1;
    end
end

% figure
hold on;
if isempty(problem)==false
    if(isfield(problem,'matlab_optF'))
        ml_optF = problem.matlab_optF;
        plot(ml_optF(:,1),ml_optF(:,2),'b*')
    end
end

if(isempty(Pareto) == false)
    plot(Pareto(:,1),Pareto(:,2),'gv','LineWidth',2,'MarkerSize',10)
end
 plot(optF(:,1),optF(:,2),'r*','LineWidth',2)
hold on; grid on;
xlabel('f_1'); ylabel('f_2')

handle = gcf;
if save_figure == 1
    %Save the figures
    dir_val = pwd;
    saveFigure(handle,[dir_val,dir_val(1),num2str(prob),'_',num2str(nChrome,'%03.0f'),'_',num2str(nRun,'%04.0f')]);
    print([path_prefix,num2str(prob),'_',num2str(nChrome,'%03.0f'),'_',num2str(nRun,'%04.0f'),'.png'],'-dpng');
    
    %Save the .mat file
    problem.prob = prob; problem.nChrome = nChrome; problem.nRun = nRun;
    problem.alpha = alpha; problem.sigma = sigma; problem.epsilon = epsilon;
    problem.optF = optF; problem.Pareto= Pareto;
    results_and_params{prob,1} = problem;
    save(file_name,'results_and_params')
end
%save(['ZDT',num2str(prob),'_Nchr',num2str(nChrome),'run',num2str(nRun),'alp',num2str(alpha,2),'epsi',num2str(epsilon,3),'sig',num2str(sigma,3)])


