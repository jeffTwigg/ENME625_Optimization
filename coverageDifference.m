function val = coverageDifference(f1_vals,f2_vals)

if(length(f1_vals)<2)
    val=0.0;
    return;
end

%Normalize the values so that none are greater than 1
%f1_vals = f1_vals/max(f1_vals);
%f2_vals = f2_vals/max(f2_vals);

vals = [1-f1_vals,1-f2_vals];
% check to make sure input is correct
[rows,~] = size(vals);
if rows ==1
    vals = [1-f1_vals',1-f2_vals'];
end


%sort values from greatest to smallest in f1
vals = sortrows(vals,1,'descend');

%check if they are  smallest to greatest in f2 and remove pair if the are
%not, that way we do not consider dominated points
i=1;
while i > length(vals)
    if vals(i+1,2)<val(i,2)
        vals(i+1,:) = [];
    else
        i=i+1;
    end
end


f1_vals = vals(:,1);
f2_vals = vals(:,2);

%Calculate Space
individuals= f1_vals'*f2_vals;

%Each Region individually
intersections = [f1_vals(2:end,1);f1_vals(end,1)]'*[f2_vals(1:end-1,1);f2_vals(1,1)];

%Intersection shared by all regions
shared = f1_vals(end)*f2_vals(1);


val = 1 - (individuals - intersections + shared);



% x_max = zeros(cols);
% one_mat = ones(rows,cols);
% 
% for i = 1:cols
%     x_max(i) = max(combined(:,i));
%     combined(:,i) = combined(:,i)/x_max(i); 
% end
% 
% % Get the Inferior Space
%  inf_areas = prod(ones - combined,0);
%  overlap_indeces = nchoosek(1:n,2);
%  set_1=overlap_indecies
%  inf_space = sum(inf_areas);
%  for i=1:length(overlap_indeces)
%      inf_space = inf_space - combined(set_1)*combined(set_2);
%  end
%  inf_space = inf_space + prod(
%  
%  
%  
%  
% inf_areas = zeros(1,rows);
% dom_areas = zeros(1,rows);
% for i = 1:cols
%     inf_areas = prod(ones - combined,0)
%     dom_areas = prod(combind,0)
% end