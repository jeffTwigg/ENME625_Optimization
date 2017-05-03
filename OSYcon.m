function [c,ceq] = OSYcon(X)
c(1) = ((X(:,3)-3).^2+X(:,4))/4 -1;
c(2) = 1-((X(:,5)-3).^2+X(:,6))/4;

ceq = [];

end
