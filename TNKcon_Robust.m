function [c,ceq] = TNKcon_Robust(X)

global DP

c(1) = 1  +0.1*cos(16*atan2(X(:,1),X(:,2)))+0.2*sin(1+DP(:,1)).*cos(1+DP(:,2)) - X(:,1).^2 -X(:,2).^2;
c(2) = (X(:,1)-0.5).^2 + (X(:,2)-0.5).^2 -0.5;

ceq = [];

end