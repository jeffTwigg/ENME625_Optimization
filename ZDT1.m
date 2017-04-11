function [ f ] = ZDT1( X )
%ZDT1 - First test problem from Deb
%global nfunc
nvar = length(X);
F1 = X(1);

g = 1+(9/(nvar-1))*sum(X(2:end));
h = 1- sqrt(F1/g);
F2 = g*h;
f = [F1,F2];
nfunc = 2;


end

