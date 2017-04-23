% This script demonstrates the use of the optimization toolbox to solve a
% simple pathfinding problem. We are given an airplane with a fixed
% airspeed and a vector field of wind in which to navigate. The objective
% is to find the path which minimizes the time taken to travel from the
% starting point to the finish point.
%
% Copyright (c) 2012, MathWorks, Inc. 
%

%% First make some random vector field of wind, and set parameters

clear; clf;

AirSpeed = 500;
sizeX = 50;
sizeY = 25;
numWayPoints = 5;
rng(50);

W_x = makeWindFun(sizeX,sizeY);
W_y = makeWindFun(sizeX,sizeY);

[Xgrid,Ygrid] = meshgrid(0:sizeX,0:sizeY);
hq = quiver(Xgrid,Ygrid,W_x,W_y,'k');
hold on;
xlabel('Units = 100 [km]');
axis equal tight
plot([0 sizeX],[sizeY sizeY]/2,'k.','markersize',16)

%% Add some color to make it more visible
L = (sqrt((Xgrid-sizeX).^2 + (Ygrid-sizeY/2).^2));
Favorability = ((sizeX-Xgrid).*W_x +  (sizeY/2-Ygrid).*W_y)./L; 
Favorability(~isfinite(Favorability)) = 0; 

hold on;
h_im = imagesc(Favorability); % This will be the background for the vector field

set(h_im,'Xdata',[0 sizeX],'Ydata',[0 sizeY]);
uistack(h_im,'bottom');

% Change the colormap...
colormap(interp1([0,1,2],[1 0 0; 1 1 1; 0 1 0],0:0.01:2));
caxis(max(abs(Favorability(:)))*[-1 1]);

h_colorbar = colorbar;
title(h_colorbar,'Tailwind (km/h)')
xlabel(h_colorbar,'Headwind')

%% Generate a default set of way points
xWayPoints = linspace(0,sizeX,numWayPoints+2)';
yWayPoints = sizeY/2 * ones(numWayPoints+2,1);

h_wp = plot(xWayPoints,yWayPoints,'color','k','linestyle','none','marker','.','markersize',16);

%% Generate a continuous path from the waypoints
PathPoints = WayPoints_To_Path([xWayPoints,yWayPoints],'linear',sizeX,sizeY,101);
h_path = plot(PathPoints(:,1),PathPoints(:,2),'k','linewidth',2);

%% Calculate the time taken:
StraightLineTime = getTimeFromPath(PathPoints,W_x,W_y,AirSpeed);

% Display in Hours/Minutes
fprintf('Straight Line Travel Time: %d hours, %.1f minutes\n',floor(StraightLineTime),rem(StraightLineTime,1)*60);

%% For example, a different set:
% Randomly choose waypoints
xWayPoints = linspace(0,sizeX,numWayPoints+2)' .* (1+0.05*randn(size(xWayPoints)));
yWayPoints = sizeY/2 + (0.1*sizeY*randn(numWayPoints+2,1));
xWayPoints([1 end]) = [0 sizeX];
yWayPoints([1 end]) = sizeY/2;

%Plot them
delete([h_wp h_path]);
h_wp = plot(xWayPoints,yWayPoints,'color','k','linestyle','none','marker','.','markersize',16);

% Generate a continuous path from the waypoints
PathPoints = WayPoints_To_Path([xWayPoints,yWayPoints],'PCHIP',sizeX,sizeY,101);
h_path = plot(PathPoints(:,1),PathPoints(:,2),'k','linewidth',2);

LineTime = getTimeFromPath(PathPoints,W_x,W_y,AirSpeed);
fprintf('Travel Time: %d hours, %.1f minutes\n',floor(LineTime),rem(LineTime,1)*60);
%% Add No Fly Zone
xc = 40; yc = 20; radius = 10;
for i = 1:length(xc)
    t = linspace(0,2*pi);
    x_bounds = xc(i)+radius(i)*cos(t);
    x_bounds(x_bounds >sizeX) = sizeX;
    x_bounds(x_bounds < 0) =0;
    y_bounds = yc(i)+radius(i)*sin(t);
    y_bounds(y_bounds >sizeY) = sizeY;
    y_bounds(y_bounds < 0) = 0;
    plot(x_bounds,y_bounds);
end

%% Optimization
% Initial Conditions
xWayPoints = linspace(0,sizeX,numWayPoints+2)';
yWayPoints = sizeY/2 * ones(numWayPoints+2,1);
ic = [xWayPoints(2:end-1)'; yWayPoints(2:end-1)'];
ic = ic(:);

% Bounds
lb = zeros(size(ic(:)));
ub = reshape([sizeX*ones(1,numWayPoints); sizeY*ones(1,numWayPoints)],[],1);

% Define 1st Objective Function
objectiveFun = @(P) getTimeFromPath(P,W_x,W_y,AirSpeed,sizeX,sizeY,'PCHIP');


single_objective = 0;

if(single_objective == 1)
    %% Find an optimal path using FMINCON
    
    % Set optimization options
    opts = optimset('fmincon');
    opts.Display = 'iter';
    opts.Algorithm = 'active-set';
    opts.MaxFunEvals = 2000;
    
    %Do the optimization using fmincon
    optimalWayPoints = fmincon(objectiveFun, ic(:), [],[],[],[],lb,ub,[],opts);
else
    %% Find an optimal path using GAMultiobh
    %Define 2nd Objective Function
    %distanceFromExclusionZone =@(P) -max(sum((P(:,1) - xc(1)).^2 +(P(:,2) -yc(1)).^2,10) );
    distanceFromExclusionZone =@(P) 1;
    
    %Define bi-objective Function
    problem_function= @(P) [objectiveFun(P) distanceFromExclusionZone(P)];

    %Define Constraint Function
    ineq_constraints = @(P) -sum((P(:,1) - xc(1)).^2 +(P(:,2) -yc(1)).^2 -radius(1));
    problem_constraints = @(P) deal(ineq_constraints(P),0);
    problem_constraints = []; % Removing problem constraints for now
    %Do the optimization using multiobjective optimizations
    options = optimoptions('gamultiobj');
    options = optimoptions(options,'PopulationSize',100);
    options = optimoptions(options,'CrossoverFcn', @crossoverscattered);
    options = optimoptions(options,'Display', 'final');
    %options = optimoptions(options,'PlotFcn', { @gaplotpareto });
    options = optimoptions(options,'ParetoFraction', 0.9);
    [X,FVAL,EXITFLAG,OUTPUT,POPULATION,SCORE] = gamultiobj(problem_function,length(ic),[],[],[],[],lb,ub,problem_constraints,options);
    optimalWayPoints = X;
end

%% Plot the optimal solution:
delete([h_wp h_path]);
optimalWayPoints = [0 sizeY/2; reshape(optimalWayPoints,2,[])'; sizeX sizeY/2];

xWayPoints = optimalWayPoints(:,1);
yWayPoints = optimalWayPoints(:,2);
h_wp = plot(xWayPoints,yWayPoints,'color','k','linestyle','none','marker','.','markersize',16);

PathPoints = WayPoints_To_Path([xWayPoints,yWayPoints],'PCHIP',sizeX,sizeY,101);
h_path = plot(PathPoints(:,1),PathPoints(:,2),'k','linewidth',2);
LineTime = getTimeFromPath(PathPoints,W_x,W_y,AirSpeed);
fprintf('Optimal Travel Time: %d hours, %.1f minutes\n',floor(LineTime),rem(LineTime,1)*60);