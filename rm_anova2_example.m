

% function stats = rm_anova2(Y,S,F1,F2,FACTNAMES)
%
% Two-factor, within-subject repeated measures ANOVA.
% For designs with two within-subject factors.
%
% Parameters:
% Y dependent variable (numeric) in a column vector
% S grouping variable for SUBJECT
% F1 grouping variable for factor #1
% F2 grouping variable for factor #2
% FACTNAMES a cell array w/ two char arrays: {'factor1', 'factor2'}
%
% Y should be a 1-d column vector with all of your data (numeric).
% The grouping variables should also be 1-d numeric, each with same
% length as Y. Each entry in each of the grouping vectors indicates the
% level # (or subject #) of the corresponding entry in Y. 

 
middle = reshape(accuracies(3, :, :), 60,1);
control = reshape(accuracies(4, :, :), 60,1);
Y = [middle ; control];

subjs = repmat(subjects, 10, 1);
contrast = repmat(all_contrasts, 24, 1);
condition = [ones(60, 1); ones(60, 1)+1];
FACTNAMES = {'contrast', 'condition'};

stats = rm_anova2(Y, subjs, contrast, condition, FACTNAMES);
disp(stats)


%%


back = reshape(accuracies(1, :, :), 60,1);
forwd = reshape(accuracies(2, :, :), 60,1);
middle = reshape(accuracies(3, :, :), 60,1);
Y = [back; forwd; middle];

subjs = repmat(subjects, 15, 1);
contrast = repmat(all_contrasts, 36, 1);
condition = [ones(60, 1); ones(60, 1)+1; ones(60, 1)+2];
FACTNAMES = {'Contrast', 'Masking Condition'};

stats = rm_anova2(Y, subjs, contrast, condition, FACTNAMES);
disp(stats)





