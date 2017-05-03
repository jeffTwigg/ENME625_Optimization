function [ f ] = ZDT1( X )
%ZDT1 - First test problem from Deb
global Mmoga
nvar = length(X(1,:));
f1 = X(:,1);

g = 1+(9./(nvar-1)).*sum(X(:,2:end),2);
h = 1- sqrt(f1./g);
f2 = g.*h;

nfunc = 2*ones(length(X(:,1)),1);
nconstr = 0*ones(length(X(:,1)),1);
nconstr_lin = 0*ones(length(X(:,1)),1);
UNCT = 0*ones(length(X(:,1)),1);


if Mmoga == 0
    f = [f1,f2,[],nfunc,nconstr,nconstr_lin,UNCT];
else
    f = [f1,f2];
end
end

