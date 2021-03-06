function [c,ceq] = TNKcon(X)

c(1) = -X(:,1).^2 - X(:,2).^2 + 1 + 0.1*cos(16*atan2(X(:,1),X(:,2)));
c(2) = (X(:,1)-0.5).^2 + (X(:,2)-0.5).^2 -0.5;

ceq = [];

end