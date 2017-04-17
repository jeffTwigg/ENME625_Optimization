function [ f ] = ZDT1( X )
%ZDT1 - First test problem from Deb

nvar = length(X(1,:));
F1 = X(:,1);

g = 1+(9./(nvar-1)).*sum(X(:,2:end),2);
h = 1- sqrt(F1./g);
F2 = g.*h;
f = [F1,F2];

end

