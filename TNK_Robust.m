%For incorporation into exisiting code
function [f,constraint] = TNK_Robust(X,DP)


f1 = X(:,1);
f2 = X(:,2);
g1 = 1  +0.1*cos(16*atan2(X(:,1),X(:,2)))+0.2*sin(DP(:,1)+1).*cos(DP(:,2)+1) - X(:,1).^2 -X(:,2).^2;
g2 = (X(:,1)-0.5).^2 + (X(:,2)-0.5).^2 -0.5;
constraint = [g1 g2];

nfunc = 2*ones(length(X(:,1)),1);
nconstr = 2*ones(length(X(:,1)),1);
nconstr_lin = 0*ones(length(X(:,1)),1);
UNCT = 1*ones(length(X(:,1)),1);

f = [f1,f2,constraint,nfunc,nconstr,nconstr_lin,UNCT];

end