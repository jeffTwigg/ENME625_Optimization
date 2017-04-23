function dist = getDistanceExclustionZone(PathPoints,sizeX,sizeY,xc,yc,radius)
% Tell you how close you will get to the exclusion zones with a path.  
% returns a value for each exclusion zone

METHOD = 'PCHIP';

%Convert waypooints to path
if isvector(PathPoints)
    PathPoints = [0 sizeY/2; reshape(PathPoints,2,[])'; sizeX sizeY/2];
    PathPoints = WayPoints_To_Path(PathPoints,METHOD,sizeX,sizeY,101);
end

dist = zeros(length(radius),1);

for i = 1:length(radius)
    dist(i) = sqrt(min((PathPoints(:,1) - xc(i)).^2 +(PathPoints(:,2) -yc(i)).^2 ));
end

constraints = radius' - dist;
%closest_dist = sqrt(min(squared_dist));
