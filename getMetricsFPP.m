%Get Metrics:
function [CD,spread,fval] = getMetricsFPP(fval)
if nargin == 0 
    n=1; i =1;
    fval = cell(10,1);
    
    while n < 11
        
        f = FlightPathOpt(i+15);
        i=i+1;
        if length(f)>90
            CD = coverageDifference2(f);
            if( CD < 100)
                fval{n,1} =f;
                n=n+1;
            end
        end
    end    
end


CD = zeros(10,1);
all_points = [];
for i = 1:10
    CD(i) = coverageDifference2(fval{i,1});
    all_points = [all_points ; fval{i,1}];
end

spread = zeros(10,1);
ideal = min(all_points);
nadir = max(all_points);
for i =1:10
    spread(i) = ParetoSpread(fval{i,1},nadir,ideal);
end


