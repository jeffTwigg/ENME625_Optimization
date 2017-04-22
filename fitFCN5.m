function [ fit ] = fitFCN5(X, ZD_func,robust_constraint_fitness)
%NSGA algorithm. Use Approach 1 for sorting
global alpha sigma epsilon

cheat = 1;

if nargin < 3
    robust_constraint_fitness = [];
end

%Check is this is a robust problem
delta_P = [];
if isempty(robust_constraint_fitness)
    func = ZD_func(X);
else%Evaluates feasible solutions with uncertaintly applied in problems with
%uncertainy
    if cheat ==1
        delta_P = [0.5708*ones(length(X),1),-1*ones(length(X),1)];
    else
        [M,~] = size(X);
        for k = 1:M
            options = optimoptions(@ga,'PopulationSize',10,'UseVectorized',true);
            lb = [-2,-2]; ub = [2,2];
            fitnessfn = @(DP) -TNK_NEGCN2(X(k,:),DP);
            [d_p,~] = ga(fitnessfn,2,[],[],[],[],lb,ub,[],options);
            delta_P = [delta_P ; d_p];
        end
    end
    func = ZD_func(X,delta_P);
end





% 
% if isempty(existing_points)
%     fit = sum(ZD_func(X));
%     return 
% end

%% Find Dominate Points

% Modify existing code to find Pareto points to find dominant layers

% func = [existing_points;ZD_func(X)];

nfunc = func(1,end-3);
nconstr = func(1,end-2);
g = func(:,nfunc+1:nfunc+nconstr);
nconstr_lin = func(1,end-1);
if nconstr_lin > 0
    fprintf('weird error here')
end
h = func(:,nfunc+nconstr+1:nfunc+nconstr+nconstr_lin);
func = func(:,1:nfunc);

[M,~] = size(X);




if nconstr == 0 && nconstr_lin ==0
    nc_col = nfunc + 3;
    init_fit_col = nfunc + 4;
    sim_col = nfunc+5;
    indecies = [1:M]';
    func = [func,indecies]; %We need to know indecies later so this should save time
    P_temp = func;
    level = 0;
    level_col = nfunc +2;
    func(:,level_col) = 0;
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

    %Make sure all individuals have a layer number
    flag = 0;
    for k = 1:M
       if func(level_col)==0
           func(k,level_col) = numLayer+1;
           flag = 1;
       end
    end
    if flag == 1, numLayer = numLayer+1; end

    %% Similarity
    %Assess similarity layer-by-layer, assess in objective space.

%     sigma = 0.158;
%     epsilon = 0.1;
%     alpha = 1;
    var_rem = 0;
    F_min = M+epsilon;
    for k = 1:numLayer
        Fitness = []; incl = []; 
        incl = find(func(:,level_col)==k); % incl = include
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
    fit = -func(:,sim_col);

%% Constraint Handling
else
    Cmax = 1.2; Cmin = 0.8; r = 0.8*M; 
    CF1 = 0.01;
    CF2 = 0.01;
    rank = zeros(1,M);
    
    % Assign moderate rank to all feasible solutions
     for k = 1:M
        flag = 0; flag_lin = 0;
        for p = 1:nconstr
            if g(k,p)>0, flag = 1;
            end
            if nconstr_lin ~= 0
                if h(k,p)~=0, flag_lin = 1;
                end            
            end            
        end
        if flag == 0 && flag_lin == 0
            rank(k) = 0.5*M;
        end
     end
    

     
     % Collect together feasible population
     feas_pop = []; infeas_pop = []; m = 1;
     for k = 1:M
         if rank(k) ~= 0
             if isempty(h)
                 feas_pop = [feas_pop;func(k,:),g(k,:)];
             else
                 feas_pop = [feas_pop;func(k,:),g(k,:),h(k,:)];
             end
         else
              if isempty(h)
                  infeas_pop = [infeas_pop;func(k,:),g(k,:)];
              else
                  infeas_pop = [infeas_pop;func(k,:),g(k,:),h(k,:)];                  
              end
              loc(m) = k; m = m+1; %keep track of which solutions were infeasible
         end
     end
     
     % Identify noninferior points
     if ~isempty(feas_pop)
          place = paretoset(feas_pop(:,1:nfunc)); 
          m = 1;
          for k = 1:length(place)
              if place(k) == 1
                  Pareto(m,:) = feas_pop(k,:); %Assign noninferior points along with constraint values            
                  rank(k) = 1; m = m+1;
              end
          end     
     end
    % Evaluate rank for infeasible individuals
    g = infeas_pop(:,nfunc+1:nconstr+nfunc);
    h = infeas_pop(:,nconstr+nfunc+1:end);
    
    for k = 1:length(g(:,1))
        for p = 1:nconstr
            if g(k,p)<=0
                feas_g(k,p) = 0; delta_g(k,p) = 0;
            else
                feas_g(k,p) = g(k,p); delta_g(k,p) = 1;
            end
        end
        if nconstr_lin == 0
            feas_h = zeros(length(g(:,1)),1);
            delta_h = zeros(length(g(:,1)),1);
        else
            for n = 1:nconstr_lin
                feas_h(k,n) = abs(h(k,n));
            end   
            if h(k,p)==0, delta_h(k,p) = 0;
            else delta_h(k,p) = 1;
            end
        end
    end
    num1 = sum(feas_g,2)+sum(feas_h,2);
    denom1 = (sum(sum(feas_g))+sum(sum(feas_h)))/M;
    J = nconstr; K = nconstr_lin;
    num2 = (sum(delta_g,2)+sum(delta_h,2));
    denom2 = (J+K);
 
    factor1 = CF1.*(num1./denom1);  
    factor2 = CF2.*(num2./denom2);
    
    
    
    for k = 1:length(g(:,1))
        if (factor1(k)> mean(factor1)) && (factor2(k) < mean(factor2))
            w1 = 0.75; w2 = 0.25;
        elseif (factor1(k) < mean(factor1)) && (factor2(k) > mean(factor2))
            w1 = 0.25; w2 = 0.75;
        else
            w1 = 0.5; w2 = 0.5;
        end
        fit_constr(k) = -((Cmax-(Cmax-Cmin)*(r-1)/(M-1))-(w1.*factor1(k)+w2.*factor2(k)));
    end
    
    for k = 1:length(loc)
        rank(loc(k)) = fit_constr(k);
    end
    fit = rank;


end
end
    
    
    
    