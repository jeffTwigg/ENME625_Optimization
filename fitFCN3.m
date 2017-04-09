function [ fit ] = fitFCN3( pop)
%NSGA algorithm. Use Approach 1 for sorting
global V prob w1 w2


if prob == 1
    %% ZDT1
    F1 = pop(1);
    g = 1+(9/(V-1))*sum(pop(2:end));
    h = 1- sqrt(F1/g);
    F2 = g*h;
    func = [w1*F1,w2*F2];
    nfunc = 2;

elseif prob == 2
    %% ZDT2
    F1 = pop(1);
    g = 1+(9/(V-1))*sum(pop(2:end));
    h = 1- (F1/g)^2;
    F2 = g*h;
    func = [F1,F2];
    nfunc = 2;
elseif prob == 3
    %% ZDT3
    F1 = pop(1);
    g = 1+(9/(V-1))*sum(pop(2:end));
    h = 1- sqrt(F1/g) - (F1/g)*sin(10*pi*F1);
    F2 = g*h;
    func = [F1,F2];
    nfunc = 2;

end

chrome = V;
%% Find Dominate Points
% Modify existing code to find Pareto points to find dominant layers

P_temp = func;
Pprime = func;
level = 1;
func(:,nfunc+1) = 0;
while ~isempty(P_temp)
    if length(P_temp(:,1))== 1        
        break 
    end
    [~,place] = prtp(P_temp);
    q = 0; m = 1;
    for k = 1:length(place)
        marker= find(P_temp(place(k),1)==func(:,1));
        func(marker,nfunc+1) = level; marker= [];
    end
    level = level+1;
    P_temp(place,:) = []; place = []; 
end

  
numLayer = level-1; 

%Make sure all variables have a layer number
flag = 0;
for k = 1:chrome
    if func(nfunc+1)==0
        func(k,nfunc+1) = numLayer+1;
        flag = 1;
    end
end
if flag == 1, numLayer = numLayer+1; end
    
%% Similarity
%Assess similarity layer-by-layer, assess in objective space.
sigma = 0.75;
epsilon = 0.25;
alpha = 5;

F_min = chrome+epsilon;
for k = 1:numLayer
    Fitness = []; incl = [];
 
    incl = find(func(:,nfunc+1)==k);
    Fitness = func(incl,:);
    
    if length(incl) == 1
        d = 0;
        sh = 1;
        nc = 1;
        Fit_share = (F_min-epsilon)/nc;
        F_min = min(Fit_share);
        func(incl,nfunc+2) = Fit_share;
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
            
            func(incl(i),nfunc+2) = Fit_share(i);
            
        end           
    end    
    F_min = min(Fit_share);
end

fit = func(:,nfunc+2);
end
    
    
    
    
    