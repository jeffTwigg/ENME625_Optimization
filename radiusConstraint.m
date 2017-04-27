function dist = radiusConstraint(PathPoints,sizeX,sizeY,xc,yc,radius)
% Tell you how close you will get to the exclusion zones with a path.  
% returns a value for each exclusion zone

METHOD = 'PCHIP';
%Convert waypooints to path
if isvector(PathPoints)
    PathPoints = [0 sizeY/2; reshape(PathPoints,2,[])'; sizeX sizeY/2];
    PathPoints = WayPoints_To_Path(PathPoints,METHOD,sizeX,sizeY,101);
end

dist = zeros(length(PathPoints),length(radius));

for i = 1:length(radius)
    dist(:,i) =  sqrt((PathPoints(:,1) - xc).^2 +(PathPoints(:,2) -yc).^2 ) - radius(i);
end
dist = min(dist,[],1);
%constraints = radius' - dist;
%closest_dist = sqrt(min(squared_dist));
