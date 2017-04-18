function [f,constraint] = CTP(X)

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
constraint = right_ineq-left_ineq;

nfunc = 2*ones(length(X(:,1)),1);
nconstr = 1*ones(length(X(:,1)),1);
nconstr_lin = 0*ones(length(X(:,1)),1);

f = [f1,f2,constraint,nfunc,nconstr,nconstr_lin];

end