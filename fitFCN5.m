function [ fit ] = fitFCN5(X, ZD_func)
%NSGA algorithm. Use Approach 1 for sorting

global alpha sigma epsilon CF1 CF2
func = ZD_func(X);

%% Find Dominate Points

% Modify existing code to find Pareto points to find dominant layers

% func = [existing_points;ZD_func(X)];

XOLin = X;
UNCT = func(1,end);
nfunc = func(1,end-3);
nconstr = func(1,end-2);
inequality_constraints = func(:,nfunc+1:nfunc+nconstr);
nconstr_eq = func(1,end-1);
equality_constraints = func(:,nfunc+nconstr+1:nfunc+nconstr+nconstr_eq);
func = func(:,1:nfunc);

[M,~] = size(X);



%% If there are no 
if nconstr == 0 && nconstr_eq ==0
    fit = NSGA(func);

%% Constraint Handling
else
    Cmax = 1.2; Cmin = 0.8; r = 0.8*M; 
    rank = zeros(M,1);
    
    % Assign moderate rank to all feasible solutions
    
    infeasible_indecies = max(inequality_constraints,[],2)>0;
    feasible_indecies = max(inequality_constraints,[],2)<0;
    rank(feasible_indecies) = 0.5*M;
    
%      for k = 1:M
%         flag = 0; flag_lin = 0;
%         for p = 1:nconstr
%             if g(k,p)>0, flag = 1;
%             end
%             if nconstr_eq ~= 0
%                 if h(k,p)~=0, flag_lin = 1;
%                 end            
%             end            
%         end
%         if flag == 0 && flag_lin == 0
%             rank(k) = 0.5*M;
%         end
%      end
%     
     %Evaluates feasible solutions with uncertaintly applied in problems with
    %uncertainy ( only for robust problems
     if UNCT == 1
         for k = 1:M
             if rank(k) == 0.5*M
                 options = optimoptions(@ga,'PopulationSize',10,'UseVectorized',true);
                 lb = -2; ub = 2;
                 fitnessfn = @(DP) -TNK_NEGCN2(XOLin(k,:),DP);
                 [DP,fval] = ga(fitnessfn,2,[],[],[],[],lb,ub,[],options);
                 Constval = fval;
                 if Constval > 0
                     rank(k) = 0;
                 else
                     rank(k) = 0.5*M;
                 end
             else
                 rank(k) = 0;
             end
         end        
     end 
     
     % Collect together feasible population
     %feas_pop = []; infeas_pop = []; %m = 1;
     
%      for k = 1:M
%          if rank(k) ~= 0
%              if isempty(h)
%                  feas_pop = [feas_pop;func(k,:),g(k,:)];
%              else
%                  feas_pop = [feas_pop;func(k,:),g(k,:),h(k,:)];
%              end
%          else
%               if isempty(h)
%                   infeas_pop = [infeas_pop;func(k,:),g(k,:)];
%               else
%                   infeas_pop = [infeas_pop;func(k,:),g(k,:),h(k,:)];             
%               end
%               loc(m) = k; m = m+1; %keep track of which solutions were infeasible
%          end
%      end
     
    infeas_pop = func(infeasible_indecies,:);
    feas_pop = func(feasible_indecies,:);
    fit_constr = 0;
    % Evaluate rank for infeasible individuals
    if ~isempty(infeas_pop)
        %g = infeas_pop(:,nfunc+1:nconstr+nfunc);
        %h = infeas_pop(:,nconstr+nfunc+1:end);

        g = inequality_constraints(infeasible_indecies,:);
        h = equality_constraints(infeasible_indecies,:);
        
        for k = 1:length(g(:,1))
            for p = 1:nconstr
                if g(k,p)<=0
                    feas_g(k,p) = 0; delta_g(k,p) = 0;
                else
                    feas_g(k,p) = g(k,p); delta_g(k,p) = 1;
                end
            end
            if nconstr_eq == 0
                feas_h = zeros(length(g(:,1)),1);
                delta_h = zeros(length(g(:,1)),1);
            else
                for n = 1:nconstr_eq
                    feas_h(k,n) = abs(h(k,n));
                end   
                if h(k,p)==0, delta_h(k,p) = 0;
                else delta_h(k,p) = 1;
                end
            end
        end
        num1 = sum(feas_g,2)+sum(feas_h,2);
        denom1 = (sum(sum(feas_g))+sum(sum(feas_h)))/M;
        J = nconstr; K = nconstr_eq;
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

        rank(infeasible_indecies) = fit_constr;
        %for k = 1:length(loc)
        %    rank(loc(k)) = fit_constr(k);
        %end
        
             % Identify noninferior points
     if ~isempty(feas_pop)
          place = paretoset(feas_pop(:,1:nfunc));
          dominant_feasible = zeros(M,1);
          dominant_feasible(feasible_indecies) = place;
          %rank(place == 1) = 1;
          if sum(feasible_indecies) > 1          
              fit = -NSGA(feas_pop(:,1:nfunc));
              %scaled_fit = -(1-fit/max(fit))+max(fit_constr);
              scaled_fit = fit;
              rank(feasible_indecies) = scaled_fit +100000;
          else
              rank(dominant_feasible ==1 ) = max(fit_constr)+100000;
          end
          
          
          
          %m = 1;
          %for k = 1:length(place)
          %    if place(k) == 1
          %        rank(k) = 1; m = m+1; %Assign noninferior points along with constraint values                            
          %    end
          %end     
     end
     
     if(sum(rank(infeasible_indecies)>0) > 0)
        fprintf('ah! what is happening') 
     end
     
     if(sum(rank>50000000000)>0)
         fprintf('somehow something is unnassigned')
     end
    
     %if(sum(feasible_indecies)>50)
     %    fprintf('feasible_pop')
     %end
    fit = -rank;
    
    figure(5)
    scatter(func(:,1),func(:,2),5*ones(length(func),1),rank)
    axis([0,3,0,3])

    colorbar
    pause(0.01)


end
end
