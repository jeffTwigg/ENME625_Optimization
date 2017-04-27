function [constraints] = robust_TNK_constraints(X,DP)
g1 = 1  +0.1*cos(16*atan2(X(:,1),X(:,2)))+0.2*sin(DP(:,1)).*cos(DP(:,2)) - X(:,1).^2 -X(:,2).^2;
g2 = (X(:,1)-0.5).^2 + (X(:,2)-0.5).^2 -0.5;

constraints = [g1];  % ignoring g2 because it is not a function of p