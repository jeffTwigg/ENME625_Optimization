function [ f ] = ZDT2( X )
%ZDT1 - First test problem from Deb
global nvar nfunc
F1 = X(1);

g = 1+(9/(nvar-1))*sum(X(2:end));
h = 1- (F1/g)^2;
F2 = g*h;
f = [F1,F2];
nfunc = 2;


end

