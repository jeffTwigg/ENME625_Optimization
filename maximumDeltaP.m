% function delta_P = maximumDeltaP(X,lb,ub,constraint_function)
% 
% %[x1,x2] = meshgrid(linspace(lb(1),ub(1),20),linspace(lb(2),ub(2),20));
% %X = [x1,x2];
% %Check is this is a robust problem
% options = optimoptions(@ga,'PopulationSize',10,'UseVectorized',true);
% fitnessfn = @(DP) -constraint_function(X,DP);
% [d_p,~] = ga(fitnessfn,2,[],[],[],[],lb,ub,[],options);
% delta_P = [delta_P ; d_p];



function delta_P = maximumDeltaP(X,p0,bounds,constraint_function,pop)
lb = bounds(:,1);
ub = bounds(:,2);
%[x1,x2] = meshgrid(linspace(lb(1),ub(1),20),linspace(lb(2),ub(2),20));
%X = [x1,x2];
%Check is this is a robust problem
options = optimoptions(@ga,'PopulationSize',pop,'UseVectorized',true);
fitnessfn = @(DP) constraint_function(X,DP+p0);
[delta_P,~] = ga(fitnessfn,length(lb),[],[],[],[],lb,ub,[],options);