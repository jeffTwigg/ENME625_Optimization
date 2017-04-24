function [ineq, eq] = flightConstraints(PathPoints,sizeX,sizeY,xc,yc,radius)
ineq =  radius' - getDistanceExclustionZone(PathPoints,sizeX,sizeY,xc,yc,radius);
eq = 0;