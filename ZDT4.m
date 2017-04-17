function [ f,g_ ] = ZDT4( X )
%ZDT1 - First test problem from Deb
% global nvar nfunc
[rows,cols] = size(X);
quadf = @(y,offset) (y-offset).^2;
F1 = -(25*quadf(X(:,1),-2) + quadf(X(:,2),-2) + quadf(X(:,3),-1) + ...
    quadf(X(:,4),-4) + quadf(X(:,5),-1));
F2 = sum(X.^2,2);
f= [F1,F2];
g_ = zeros(rows,cols);
g_(:,1) = 1-(X(:,1)-X(:,2))/2;
g_(:,2) = (X(:,1)-X(:,2))/6 -1;
g_(:,3) = (X(:,2)-X(:,1))/2 -1;
g_(:,4) = (X(:,1)-3*X(:,2))/2 -1;
g_(:,5) = ((X(:,2)-3).^2 + X(:,4))/4 -1;
g_(:,6) = 1-((X(:,5)-3).^2 + X(:,6))/4;

end

