 %Pareto Spread
function val = ParetoSpread(f,pg,pb)
%expecting input to be 
% [ f1_1, f2_1]
% [ f1_2, f2_2]
% [  ... , ...]
% [ f1_n ,f2_n]
% pg = [pg_1 pg_2]
% pb = [pb_1 pb_2]

h1 = abs(max(f(:,1))-min(f(:,1)));
h2 = abs(max(f(:,2))-min(f(:,2)));

H1 = abs(pg(1)-pb(1));
H2 = abs(pg(2)-pb(2));

val = h1*h2/(H1*H2);

end