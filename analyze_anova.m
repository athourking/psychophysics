function analyze_anova %(fileName,inDir)

%Based on what is visible in the plot of mean accuracies across all subjects, 
%the biggest difference should be between backward and middle masking 
%conditions at 12% and 16% contrast. We will perform one-way ANOVA to 
%see if the difference is significant.

%Load the data
inDir = 'C:\Users\John.John-PC\Documents\MATLAB\CFS_Checkerboard\Data_Concat\';
fileName ='Data_final';
load([inDir fileName]);

%Filter our the relevant conditions
%1 column = 12 accuracies for bwd(1st row) masking at 12% (2nd col)
%2 column = 12 accuracies for mid(3rd row) masking at 12% (2nd col)
bwd_mid_at12(:,1) = reshape(accuracies_zscored(1,2,:),12,1);
bwd_mid_at12(:,2) = reshape(accuracies_zscored(3,2,:),12,1);

%1 column = 12 accuracies for bwd(1st row) masking at 16% (3nd col)
%2 column = 12 accuracies for mid(3rd row) masking at 12% (3nd col)
bwd_mid_at16(:,1) = reshape(accuracies_zscored(1,3,:),12,1);
bwd_mid_at16(:,2) = reshape(accuracies_zscored(3,3,:),12,1);

%Perform ANOVA
anova1(bwd_mid_at12)
title(gca,'BWD vs MID at 12% contrast');

anova1(bwd_mid_at16);
title(gca,'BWD vs MID at 16% contrast');
