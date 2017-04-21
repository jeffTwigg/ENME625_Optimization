function [c,ceq] = TNK_constraints(X)
g1 = -(X(:,1).^2 +X(:,2).^2 -1 -0.1*cos(16*atan2(X(:,1),X(:,2))));
g2 = (X(:,1)-0.5).^2 + (X(:,2)-0.5).^2 -0.5;
c=[g1,g2];
ceq = zeros(size(X));