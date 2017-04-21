function [c_ineq,ceq] = CTP_constraints(X)
f1 = X(:,1);
G = 1+ sum(X(:,2:end),2).^0.25;
f2 = G.*(1-sqrt(f1/G));
theta = -0.2*pi;
a = 0.2;
b=10;
c=1;
d=6;
e=1;

left_ineq = cos(theta)*(f2-e)-sin(theta)*f1;
right_ineq = a*abs(sin(b*pi*(sin(theta)*(f2-e)+cos(theta)*f1).^c)).^d;
c_ineq = real(right_ineq-left_ineq);
ceq = zeros(size(X));
