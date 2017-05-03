%For incorporation into exisiting code
function [f,constraint] = TNK_Robust(X)

global Mmoga DP

f1 = X(:,1);
f2 = X(:,2);
g1 = 1  +0.1*cos(16*atan2(X(:,1),X(:,2)))+0.2*sin(1+DP(:,1)).*cos(1+DP(:,2)) - X(:,1).^2 -X(:,2).^2;
g2 = (X(:,1)-0.5).^2 + (X(:,2)-0.5).^2 -0.5;
constraint = [g1 g2];

nfunc = 2*ones(length(X(:,1)),1);
nconstr = 2*ones(length(X(:,1)),1);
nconstr_lin = 0*ones(length(X(:,1)),1);
UNCT = 0*ones(length(X(:,1)),1);

if Mmoga == 0,
    f = [f1,f2,constraint,nfunc,nconstr,nconstr_lin,UNCT];
else
    f = [f1,f2];
end
end