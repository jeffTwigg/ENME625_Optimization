function [ineq, eq] = flightConstraints(PathPoints,sizeX,sizeY,xc,yc,radius)
ineq =  radius' - getDistanceExclustionZone(PathPoints,sizeX,sizeY,xc,yc,radius);
eq = 0;
pts = reshape(PathPoints,2,[])';
dist_constraint = zeros(length(pts),1);
for i = 1:length(dist_constraint)
    other_indecies = ones(length(dist_constraint),1); other_indecies(i) = 0;
    other_pts = pts(other_indecies ==1,:);
    dist_constraint(i) = 1 - min(sqrt( (pts(i,1) - other_pts(:,1)).^2 + (pts(i,2)-other_pts(:,2)).^2));
end
ineq = [ineq;dist_constraint];

