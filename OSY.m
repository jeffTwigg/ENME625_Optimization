function [ f ] = OSY( X )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

F1 = -(25*(X(:,1)-2).^2+(X(:,2)-2).^2+(X(:,3)-1).^2+(X(:,4)-4).^2+(X(:,5)-1).^2);
F2 = sum(X,2);

g1 = 1-(X(:,1)+X(:,2))./2;
g2 = (X(:,1)+X(:,2))./6 - 1;
g3 = (X(:,2)-X(:,1))./2 - 1;
g4 = (X(:,1)-3*X(:,2))./2 - 1;
g5 = ((X(:,3)-3).^2+X(:,4))./4 - 1;
g6 = 1 - ((X(:,5)-3).^2 +X(:,6))./4;

nfunc = 2*ones(length(X(:,1)),1);
nconstr = 6*ones(length(X(:,1)),1);
nconstr_lin = 0*ones(length(X(:,1)),1);
UNCT = 0*ones(length(X(:,1)),1);

f = [F1,F2,g1,g2,g3,g4,g5,g6,nfunc,nconstr,nconstr_lin,UNCT];

end

