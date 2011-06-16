
%For 'yes' the expectation is 100% correct responses
%For 'no' the expectation is 25% correct responses
    
%Take one contrast value and one timing condition
%Look at 'yes' answers to see if response and location match
%Look at 'no' answers to see if response and location are different
%2 graphs, x: contrast, y: %correct, 3 data sets for 3 masking cond's

% Trial(count, 3) = contrast; % contrasts 0.04 0.12 0.16 0.24 0.64 0.96
% Trial(count, 5) = j; % code for the timing conditions back, fwd, mid
% Trial(count, 6) = k; % location of the checkerboard 1 2 3 4
% Trial(count, 7) = 0; %  responses for locations 1 2 3 4
% Trial(count, 8) = 0; %  responses for subjective visibility 3yes 4no

contrast = [0.04 0.12 0.16 0.24 0.64 0.96]; 
checkLocation = [1 2 3 4];
timing = {[39 49 59 69] [32 42 52 62] [36 46 56 66] };

addpath('C:\Users\John.John-PC\Documents\MATLAB\CFS_Data\Data');
load ('S01_AF_06062011_01');

for i = 1:length(contrast)
    for j = 1:length(timing)
        %1st filter out the contrast and timing condition one after another
 dataFilter = Exp.Trial(Exp.Trial(:,3)==contrast(i) & Exp.Trial(:,5) == j,:)
        %2nd find accuracy of location judgment when subject said 'I saw the stimulus'
        %We expect close to 100% here
 yes_accuracy(j,i) = size(dataFilter(dataFilter(:,8)==3 & dataFilter(:,6)==dataFilter(:,7),:),1)...
     /size(dataFilter(dataFilter(:,8)==3,:),1)
        %find accuracy of location judgment when subject said 'I did not see the stimulus'
        %We expect around 25% here (1/4 of responses accidentaly correct)
 no_accuracy(j,i) = size(dataFilter(dataFilter(:,8)==4 & dataFilter(:,6)==dataFilter(:,7),:),1)...
     /size(dataFilter(dataFilter(:,8)==4,:),1)
 
     end
end

%Plotting: figure out how, because for low checkerboard contrasts 'yes' plots 
%produce NaN %as there are no 'yes' answers to calculate % from. 
%The same for 'no' answers at high contrasts.
%Also: perhaps also the number of yes answers given should be included so
%one knows how many yes answers there were from which % was calculated. 
%Or rather: the fraction of yes answers at that timing/concentration.
%So by looking at the 'yes' or 'no'graph one could see: for that timing 
%at that contrast level the subject said 'yes', say, 80% of the time and
%97% of the 'yes' responses gave the correct location judgment. 
%Or - the subject said 'no' 70% of the time and 29% of 'no' responses gave
%the correct location judgment.

% plot(yes_accuracy)
%   NaN   NaN     1     1     1     1
%   NaN   NaN     1     1     1     1
%   NaN     0   NaN     1     1     1

% plot(no_accuracy)
% 0.1250    0.3750    0.1667    0.5000         0       NaN
% 0.1250    0.1250         0    0.5000       NaN       NaN
% 0.2500    0.4286    0.5000    0.5000       NaN       NaN










