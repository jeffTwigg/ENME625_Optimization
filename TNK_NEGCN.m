%Fitness function for innerloop GA, used to evaluate fitness of MOGA
%results. Updated to be negative INSIDE the function.
function [g] = TNK_NEGCN(X,DP)

g1 = ((X(:,1).^2) +(X(:,2).^2) -1 -0.1.*cos(16.*atan2(X(:,1),X(:,2)))-0.2.*sin(1+DP).*cos(1+DP));
g2 = -((X(:,1)-0.5).^2) + ((X(:,2)-0.5).^2) -0.5;
g = max(g1,g2);
end

