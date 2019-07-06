function [ stats_info ] = statsT( p_value, data1, data2 )
% statsT( p_value, data1, data2 )
%   p_value and data1 arguments are nessesary to create and return a
%   confidence interval.
%
%   p_value must be 0.2, 0.1, 0.05, 0.02 0.01, 0.005, 0.002, 0.001
%   data1 can not be more than 26 elements
%      
%   if data2 is provided a t-test is calcuated and function will;
%   return 1 if data1 and data2 are statistically different.
%   return 0 if data1 and data2 are NOT statistically different.
%   
%   data1 and data2 can not be more than 26 elements combined
%
% Michael Miller
% ENGR 297 - MATLAB Project Part 3
% April 26, 2016


% Example output
%
% a =
%
%      1     2     3     4     5
%
% i = [0.2 0.1 0.05]
%
% i =
%
%     0.2000    0.1000    0.0500
%
% statsT(i,a)
% Creating a confidence interval
%
% ans =
%
%     1.9160    4.0840
%     1.4924    4.5076
%     1.0371    4.9629
%
% b = 5:10
%
% b =
%
%      5     6     7     8     9    10
%
% statsT(i,a,b)
% Calculating a t-test
% The two samples are statistically different
%
% ans =
%
%      1

if exist('data2','var')
    fprintf('Calculating a t-test\n');
    n1 = numel(data1);
    n2 = numel(data2);
    x1_bar = mean(data1);
    x2_bar = mean(data2);
    s1 = sqrt(1/(n1-1)*sum((data1(1:n1)-x1_bar).^2));
    s2 = sqrt(1/(n2-1)*sum((data2(1:n2)-x2_bar).^2));
    
    %Calculated t-value
    t = (x1_bar-x2_bar)/sqrt(s1^2/n1+s2^2/n2);
    
    alpha = n1+n2-2;
    phi = p_value;
    
    %Critical t-value
    ct = csvread('T_Table.csv',0,2);
    ct = ct(alpha+1,ismember(ct(1,1:end),phi));
    
    if abs(t)>ct
        fprintf('The two samples are statistically different\n');
        stats_info = 1;
    else
        fprintf('The two samples are NOT statistically different\n')
        stats_info = 0;
    end
else
    fprintf('Creating a confidence interval\n');
    
    %unknown standard deviation s
    n = numel(data1);
    x_bar = mean(data1);
    alpha = n-1;
    phi = p_value;
    s = sqrt(1/(n-1)*sum((data1(1:n)-x_bar).^2));
    
    %degress of freedom index(alpha)begins in row 2
    t=csvread('T_Table.csv',0,2);
    t = t(alpha+1,ismember(t(1,1:end),phi));
    
    CI_1 = x_bar - t.*s/sqrt(n) ;
    CI_2 = x_bar + t.*s/sqrt(n) ;
    
    stats_info = [ CI_1', CI_2'];
end
end

