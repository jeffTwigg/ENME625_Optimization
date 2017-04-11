function val = coverageDifference2(input)
%expecting input to be 
% [ f1_1, f2_1]
% [ f1_2, f2_2]
% [  ... , ...]
% [ f1_n ,f2_n]

vals = 1-input;

% check to make sure input is correct
[rows,~] = size(vals);
%if rows ==1
%    vals = [1-f1_vals',1-f2_vals'];
%end


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


