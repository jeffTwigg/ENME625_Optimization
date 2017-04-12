function [ fit ,func] = fitFCN4(X, ZD_func, V,existing_points)
%NSGA algorithm. Use Approach 1 for sorting
%global func nfunc V

%func = ZD_func(X);

if isempty(existing_points)
    fit = sum(ZD_func(X));
    return 
end

%% Find Dominate Points
% Modify existing code to find Pareto points to find dominant layers

func = [existing_points;ZD_func(X)];
[nvar,nfunc] = size(func);
level = 0;
level_col = nfunc +2;
sim_col = nfunc+3;
indecies = [1:nvar]';
func = [func,indecies]; %We need to know indecies later so this should save time
P_temp = func;
func(:,level_col) = 0;
%
while ~isempty(P_temp)
    level = level+1;% increment the level value
    %Not neccesary because exiting in this case
    if length(P_temp(:,1))== 1
        func(P_temp(:,nfunc+1),level_col) = level;
        break 
    end
    [~,place] = prtp(P_temp); % get all the indecies in the lowest layer
    current_level_indecies = P_temp(place,nfunc+1);
    %current_level_indecies = sum(P_temp(:,nfunc+1) == place,2)==1;
    func(current_level_indecies, level_col) = level;
    P_temp(place, :) = [];
end

  
numLayer = level; 

%Make sure all variables have a layer number
%flag = 0;
%for k = 1:nvar
%    if func(level_col)==0
%        func(k,level_col) = numLayer+1;
%        flag = 1;
%    end
%end
%if flag == 1, numLayer = numLayer+1; end
    
%% Similarity
%Assess similarity layer-by-layer, assess in objective space.
sigma = 0.75;
epsilon = 0.25;
alpha = 5;

F_min = nvar+epsilon;
for k = 1:numLayer
    Fitness = []; incl = [];
 
    incl = find(func(:,level_col)==k);
    Fitness = func(incl,:);
    if(isempty(Fitness) == 0)
        if length(incl) == 1
            d = 0;
            sh = 1;
            nc = 1;
            Fit_share = (F_min-epsilon)/nc;
            F_min = min(Fit_share);
            func(incl,sim_col) = Fit_share;
        else
            for m = 1:nfunc
                maxF(m) = max(Fitness(:,m));
                minF(m) = min(Fitness(:,m));
            end
            d = []; similar = [];
            for i = 1:length(incl)
                F_int = F_min-epsilon;
                for j = 1:length(incl)
                    for k = 1:nfunc
                        similar(k) = ((Fitness(i,k)-Fitness(j,k))/(maxF(k)-minF(k)))^2;
                    end
                    d(i,j) = sqrt(sum(similar));
                    if d(i,j)<=sigma
                        sh(i,j) = 1-(d(i,j)/sigma)^alpha;
                    else sh(i,j) = 0;
                    end
                end
                nc(i) = sum(sh(i,:));
                Fit_share(i) = F_int/nc(i);
                
                func(incl(i),sim_col) = Fit_share(i);
                
            end
        end
    end
    F_min = min(Fit_share);
end
%Since a greater fitness value is a larger number, we use the inverse
fit =  10*func(end,level_col)-func(end,sim_col);
end
    
    
    
    
    