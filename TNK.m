function [f] = TNK(X)

global Mmoga

f1 = X(:,1);
f2 = X(:,2);
g1 = -X(:,1).^2 - X(:,2).^2 + 1 + 0.1*cos(16*atan2(X(:,1),X(:,2)));
g2 = (X(:,1)-0.5).^2 + (X(:,2)-0.5).^2 -0.5;
constraint = [g1 g2];

nfunc = 2*ones(length(X(:,1)),1);
nconstr = 2*ones(length(X(:,1)),1);
nconstr_eq = 0*ones(length(X(:,1)),1);
UNCT = 0*ones(length(X(:,1)),1);

if Mmoga == 0,
    f = [f1,f2,constraint,nfunc,nconstr,nconstr_eq,UNCT];
else
    f = [f1,f2];
end

end