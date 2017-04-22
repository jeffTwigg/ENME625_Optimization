%Fitness function for innerloop GA, used to evaluate fitness of MOGA
%results. Updated to be negative INSIDE the function.
function [eta_gnew] = TNK_NEGCN2(X,DP)

%Using page 4 of MORO.pdf
% assuming that p_0 will not change
g1   = 1+0.1.*cos(16.*atan2(X(1),X(2)))+0.2.*sin(1+DP(:,1)).*cos(1+DP(:,2))-X(1)^2 -X(2)^2;
g1_o = 1+0.1.*cos(16.*atan2(X(1),X(2)))+0.2.*sin(1).*cos(1)-X(1)^2 -X(2)^2;

g2   = (X(1)-0.5).^2 + (X(2)-0.5).^2 -0.5;
g2_o = (X(1)-0.5).^2 + (X(2)-0.5).^2 -0.5;

%get delta g_j 
[rows,~] = size(DP);
delta_g1 = zeros(rows,1);
val = (g1 -g1_o)/abs(g1_o);
delta_g1(g1 >= g1_o) = val(g1 >= g1_o);

delta_g2 = zeros(rows,1);
val = (g2 -g2_o)/abs(g2_o);
delta_g2(g2 >= g2_o) = val;

%return eta_gnew
eta_gnew = sqrt(sum([delta_g1,delta_g2].^2,2));
end

