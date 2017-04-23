function closest_dist = getDistanceExclustionZone(P,sizeX,sizeY,xc,yc,radius)
% Tell you how close you will get to the exclusion zone with a path.  

METHOD = 'PCHIP';

%Convert waypooints to path
if isvector(P)
    PathPoints = [0 sizeY/2; reshape(P,2,[])'; sizeX sizeY/2];
    PathPoints = WayPoints_To_Path(PathPoints,METHOD,sizeX,sizeY,101);
end

squared_dist = zeros(length(radius),1);

for i = 1:length(radius)
    squared_dist(i) = min((PathPoints(:,1) - xc(i)).^2 +(PathPoints(:,2) -yc(i)).^2 );
end


closest_dist = sqrt(min(squared_dist));
