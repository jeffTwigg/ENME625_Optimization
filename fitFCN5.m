function [ fit ] = fitFCN5(X, ZD_func)
%NSGA algorithm. Use Approach 1 for sorting

func = ZD_func(X);
% 
% if isempty(existing_points)
%     fit = sum(ZD_func(X));
%     return 
% end

%% Find Dominate Points

% Modify existing code to find Pareto points to find dominant layers

% func = [existing_points;ZD_func(X)];
[nvar,nfunc] = size(func);
level = 0;
level_col = nfunc +2;
nc_col = nfunc + 3;
init_fit_col = nfunc + 4;
sim_col = nfunc+5;
indecies = [1:nvar]';
func = [func,indecies]; %We need to know indecies later so this should save time
P_temp = func;
func(:,level_col) = 0;
%
while ~isempty(P_temp)
    level = level+1;% increment the level value
    if length(P_temp(:,1))== 1
        %If there is only one value left at the end, assign this to a level
        func(P_temp(:,nfunc+1),level_col) = level;
        break 
    end
    place = paretoset(P_temp(:,1:nfunc)); % get all the indecies in the lowest layer
    for k = 1:length(place)
        if place(k) == 1
            current_level_indecies = P_temp(k,nfunc+1); %map them from
            func(current_level_indecies, level_col) = level; % assiged from prtp
        end
    end     
    
    P_temp(place, :) = [];
end

  
numLayer = level; 

%Make sure all variables have a layer number
flag = 0;
for k = 1:nvar
   if func(level_col)==0
       func(k,level_col) = numLayer+1;
       flag = 1;
   end
end
if flag == 1, numLayer = numLayer+1; end
    
%% Similarity
%Assess similarity layer-by-layer, assess in objective space.
sigma = 0.75;
epsilon = 0.25;
alpha = 1;
var_rem = 0;
F_min = nvar+epsilon;
for k = 1:numLayer
    Fitness = []; incl = []; 
    incl = find(func(:,level_col)==k);
    Fitness = func(incl,1:nfunc);
    var_rem = var_rem+length(Fitness(:,1));
    if(isempty(Fitness) == 0)
        if length(incl) == 1
            
            F_int = F_min-epsilon;
            Fit_share = F_int;
            func(incl,sim_col+1) = F_int;
            func(incl,sim_col) = F_int;
            func(incl,nc_col) = 1;
        else
            for m = 1:nfunc
                maxF(m) = max(Fitness(:,m));
                minF(m) = min(Fitness(:,m));
                func(m,init_fit_col) = minF(m);
            end
            d = []; similar = []; sh = [];
            for i = 1:length(incl)
                F_int = F_min-epsilon;
                for j = 1:length(incl)
                    for p = 1:nfunc
                        similar(p) = ((Fitness(i,p)-Fitness(j,p))/(maxF(p)-minF(p)))^2;
                    end
                    d(i,j) = sqrt(sum(similar));
                    if d(i,j)<=sigma
                        sh(i,j) = 1-(d(i,j)/sigma)^alpha;
                    else sh(i,j) = 0;
                    end
                end
                nc(i) = sum(sh(i,:));
                Fit_share(i) = F_int/nc(i);
                func(incl(i),nc_col) = nc(i);
                func(incl(i),sim_col) = Fit_share(i);
                func(incl(i),sim_col+1) = F_int;
                
            end
        end
        F_min = min(Fit_share);
    end
    
end
%Since a greater fitness value is a larger number, we use the inverse

% Shared Fitness function here
fit = -func(:,sim_col);
%10*func(end,level_col) -func(end,sim_col);% This is a hack
end
    
    
    
    