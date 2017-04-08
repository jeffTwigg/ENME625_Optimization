function [ f ] = ZDT3( X )
%ZDT1 - First test problem from Deb
global nvar nfunc
F1 = X(1);

g = 1+(9/(nvar-1))*sum(X(2:end));
h = 1- sqrt(F1/g) - (F1/g)*sin(10*pi*F1);
F2 = g*h;
f = [F1,F2];
nfunc = 2;


end