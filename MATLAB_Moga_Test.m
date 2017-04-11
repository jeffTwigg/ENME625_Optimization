options = optimoptions(@gamultiobj,'PopulationSize',50000,'PlotFcn',@gaplotpareto);
nvars = 30;
A = []; 
b = [];
Aeq = []; beq = [];
lb = zeros(1,nvars); ub = ones(1,nvars);

[x,fval,output,population] = gamultiobj(@ZDT1,nvars,[],[],[],[],lb,ub,options)

