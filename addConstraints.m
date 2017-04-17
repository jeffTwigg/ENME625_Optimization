function fitness = addConstraints(g)
[rows,cols] = size(g);
M = rows;
J = cols;
r = 0.8*M;
C_max = 1.2;
C_min = 0.8;
CF1 = 0.01;  %[0.0005, 0.015];
CF2 = 0.01;  %[0.0005, 0.015];

factor1 = CF1 * sum(max(g,0),2)/sum(sum(max(g,0)));
factor2 = CF2 * sum(max(g,0)~=0,2)/J;

w1 = 0.5;
w2 = 0.5;

fitness = (C_max - (C_max - C_min)*(r-1)/(M-1)) - (w1*factor1 +w2*factor2);
