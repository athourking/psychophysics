% function analyze_visibility


inDir = './Data_results/';
outDir = './Data_results/';
figsDir = './Figures/';


addpath(genpath('../Programs/eeglab11_0_4_3b/'))
addpath(genpath('./rm_anova2/'))


% (1) subject number ; (2) Block number; (3) contrast value ; (4) timing
% value ('backwardMasking' 'forwardMasking' 'middleMasking' 'control'}; 1, 2, 3, 4);
% (5) code for the timing conditions ; (6) location of the checkerboard
% (7) responses for locations ; (8) responses for subjective visibility (3:
% Yes, 4: No)
data = load([ inDir 'Data_12Subjects.mat']);
data_main = data.Data;


% (1) subject number ; (2) Block number; (3) contrast value ; (4) timing of checkerboard;
% (5) mask frequencies; (6) location of the checkerboard
% (7) responses for locations ; (8) responses for subjective visibility
data_freq = load([inDir 'freqExp_Subjects_1   2   3   4   5   6   7   8   9  10  11  12.mat']);
data_frq = data_freq.Data;

data_control = load([inDir 'freqExp_Control_Subjects_1  2  3  6  7  8  9.mat']);
data_ctr = data_control.Data;


%% Test for adaptation effects

data_main = data_main(data_main(:,4) < 10 | data_main(:,4) > 40, :);

%Visibility
timing_conditions = unique(data_main(:,5)); 
all_contrasts = unique(data_main(:,3)); 
subjects = unique(data_main(:,1)); 


for subj = 1: length(subjects)
    for cond =1 : length(timing_conditions)
        for contrast =1 :length(all_contrasts)
            
            % Filter by subject, contrast and condition
            aux_data = data_main( data_main(:,1) == subjects(subj) & data_main(:,5) ==timing_conditions(cond)...
                & data_main(:,3)== all_contrasts(contrast), :) ; 
            
            % just a sanity check
            if size(aux_data, 1) ~= 48
%                 display ('ERROR IN THE NUMBER OF TRIALS')
%                 return
            end
            
             % Correct responses
            correct = aux_data( aux_data(:,6) == aux_data(:,7), :);
            nCorrect = size( correct, 1);
            prop_correct = nCorrect / size(aux_data, 1); 
            nCorrect_seen = size(correct(correct(:,8) == 3), 1);
            
            % Incorrect responses
            incorrect = aux_data( aux_data(:,6) ~= aux_data(:,7), :);
            nIncorrect = size(incorrect, 1);
            nIncorrect_seen = size(incorrect(incorrect(:,8) == 3), 1);
            
            
            % Collect data
            accuracies(cond, contrast, subj) = prop_correct; %#ok
            
            
        end
    end
end

acc = accuracies(1:3,:, :); % we don't take into acount the control condition (row 4)
overall_mean = mean(acc(:));
for su = 1 : length(subjects)
    subject_mean(su) = mean(mean(accuracies(1:3,:,su))); %#ok
    accuracies(1:3,:,su) =  accuracies(1:3,:,su) - (subject_mean(su) - overall_mean); %#ok
end

mAccuracy = mean(accuracies, 3);
semAccuracy = std(accuracies, [], 3) / sqrt(length(subjects));
markerSize = 8;

figure(1); clf;
hold on
p1 = plot(all_contrasts', mAccuracy(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k', 'MarkerSize', markerSize);
errorbar(all_contrasts', mAccuracy(1,:), semAccuracy(1,:), 'Color', [0 0 0]);

p2 = plot(all_contrasts', mAccuracy(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k', 'MarkerSize', markerSize);
errorbar(all_contrasts', mAccuracy(2,:), semAccuracy(2,:), 'Color', [0.5 0.5 0.5] );

p3 = plot(all_contrasts', mAccuracy(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k', 'MarkerSize', markerSize);
errorbar(all_contrasts', mAccuracy(3,:), semAccuracy(3,:), 'Color', [0.75 0.75 0.75] );

ylim([0.15 1.05])
set(gca, 'XTick', all_contrasts)
title('Exp 1')
xlabel('Contrast')
ylabel('p(correct)')
legend([p1 p2 p3],'Backward', 'Forward', 'Middle', 'Location', 'SouthEast')
legend boxoff
print(gcf, '-dpng', [figsDir 'Exp1_accuracies.png'])



%% HISTOGRAM MIDDLE VS CONTROL (ADAPTATION)

figure(3); clf;
hold on
bh = bar(1:5, mAccuracy(3:4,:)');
errorbar( (1:5) - 0.15, mAccuracy(3,:), semAccuracy(3,:), 'Color', [0 0 0], 'LineStyle', 'none' );
errorbar( (1:5) + 0.15,  mAccuracy(4,:), semAccuracy(4,:), 'Color', [0 0 0], 'LineStyle', 'none' );

set(bh(1), 'FaceColor', [0.2 0.2 0.2])
set(bh(2), 'FaceColor', [0.5 0.5 0.5])
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', all_contrasts)
ylim([0 1])
xlabel('Contrast')
ylabel('p(correct)')
legend('Middle', 'Control', 'Location', 'NorthWest')
legend boxoff
print(gcf, '-dpng', [figsDir 'Exp1_middleVsControl.png'])


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





%% Type II d prime experiment 1

%  timingConds = { 'backwardMasking' 'forwardMasking' 'middleMasking'}; %
%  1, 2, 3

%Visibility
timing_conditions = 1:3; % unique(data_main(:,5)); 
all_contrasts = unique(data_main(:,3)); 
subjects = unique(data_main(:,1)); 


for subj = 1: length(subjects)
    for cond =1 : length(timing_conditions)
        for contrast =1 :length(all_contrasts)
            
            % Filter by subject, contrast and condition
            aux_data = data_main( data_main(:,1) == subjects(subj) & data_main(:,5) ==timing_conditions(cond)...
                & data_main(:,3)== all_contrasts(contrast), :) ; 
            
            % just a sanity check
            if size(aux_data, 1) ~= 48
%                 display ('ERROR IN THE NUMBER OF TRIALS')
%                 return
            end
            
            % Correct responses
            correct = aux_data( aux_data(:,6) == aux_data(:,7), :);
            nCorrect = size( correct, 1);
            prop_correct = nCorrect / size(aux_data, 1); 
            nCorrect_seen = size(correct(correct(:,8) == 3), 1);
            
            % Incorrect responses
            incorrect = aux_data( aux_data(:,6) ~= aux_data(:,7), :);
            nIncorrect = size(incorrect, 1);
            nIncorrect_seen = size(incorrect(incorrect(:,8) == 3), 1);
            
            
            % Collect data
            accuracies(cond, contrast, subj) = prop_correct;            
            
            if nCorrect == 0
                phit(cond, contrast, subj) = 0;
            else
                phit(cond, contrast, subj) = nCorrect_seen / nCorrect;
            end
            
            if nIncorrect == 0 
                pfa(cond, contrast, subj) = 0;
            else
                pfa(cond, contrast, subj) = nIncorrect_seen / nIncorrect;
            end
            
            
            phit(phit == 0) = 0.01; phit(phit == 1) = 0.99;
            pfa(pfa == 0) = 0.01; pfa(pfa == 1) = 0.99;
            
            dPrimeII(cond, contrast, subj) = dprime( phit(cond, contrast, subj),...
                pfa(cond, contrast, subj) );
            
            auc_II(cond, contrast, subj) = AreaUnderROC([0 phit(cond, contrast, subj) 1; ...
                0 pfa(cond, contrast, subj) 1; ]');            
            
        end
    end
end

% d_primes_type1(su, bi) = dprime( hit_rate(su, bi), falseAlarm_rate(su, bi)); %#ok / sqrt(2);       
         

mAuc_II     = mean(auc_II, 3);
semAUCII    = std(auc_II, [],3) / sqrt(length(subjects));
mDprimeII   = mean(dPrimeII, 3);
semDprimeII = std(dPrimeII, [], 3) / sqrt(length(subjects));

figure(1); clf;
hold on
p1= plot(all_contrasts', mAuc_II(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k');
errorbar(all_contrasts', mAuc_II(1,:), semAUCII(1,:), 'Color', [0 0 0]);

p2= plot(all_contrasts', mAuc_II(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k');
errorbar(all_contrasts', mAuc_II(2,:), semAUCII(2,:), 'Color', [0.5 0.5 0.5] );

p3= plot(all_contrasts', mAuc_II(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k');
errorbar(all_contrasts', mAuc_II(3,:), semAUCII(3,:), 'Color', [0.75 0.75 0.75] );

ylim([0.45 1])
set(gca, 'XTick', all_contrasts)
title('Exp 1')
xlabel('Contrast')
ylabel('Type II AUC')
legend([p1 p2 p3], 'Backward', 'Forward', 'Middle', 'Location', 'SouthEast')
legend boxoff
print(gcf, '-dpng', [figsDir 'Exp1_AUC.png'])

figure(2); clf;
hold on
plot(all_contrasts', mDprimeII(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k')
errorbar(all_contrasts',mDprimeII(1,:), semDprimeII(1,:), 'Color', [0 0 0]);

plot(all_contrasts', mDprimeII(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k')
errorbar(all_contrasts', mDprimeII(2,:), semDprimeII(2,:), 'Color', [0.5 0.5 0.5] );

plot(all_contrasts', mDprimeII(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k')
errorbar(all_contrasts', mDprimeII(3,:), semDprimeII(3,:), 'Color', [0.75 0.75 0.75] );

set(gca, 'XTick', all_contrasts)
title('Exp 1')
xlabel('Contrast')
ylabel('Type II d Prime')
legend('Backward', 'Forward', 'Middle', 'Location', 'SouthEast')
legend boxoff
print(gcf, '-dpng', [figsDir 'Exp1_dPrime.png'])

close all
clear accuracies phit pfa dPrimeII auc_II

%% Type II d prime experiment 2

% (1) subject number ; (2) Block number; (3) contrast value ; (4) timing of checkerboard;
% (5) mask frequencies; (6) location of the checkerboard
% (7) responses for locations ; (8) responses for subjective visibility


%Visibility
mask_freq     = unique(data_frq(:,5)); 
all_contrasts = unique(data_frq(:,3)); 
subjects      = unique(data_frq(:,1)); 


for subj = 1: length(subjects)
    for contrast =1 :length(all_contrasts)
        for cond =1 : length(mask_freq)
        
            
            % Filter by subject, contrast and condition
            aux_data = data_frq( data_frq(:,1) == subjects(subj) & data_frq(:,5) ==mask_freq(cond)...
                & data_frq(:,3)== all_contrasts(contrast), :) ; 
            
            % just a sanity check
            if size(aux_data, 1) ~= 40
%                 display ('ERROR IN THE NUMBER OF TRIALS')
%                 return
            end
            
            % Correct responses
            correct = aux_data( aux_data(:,6) == aux_data(:,7), :);
            nCorrect = size( correct, 1);
            prop_correct = nCorrect / size(aux_data, 1); 
            nCorrect_seen = size(correct(correct(:,8) == 3), 1);
            
            % Incorrect responses
            incorrect = aux_data( aux_data(:,6) ~= aux_data(:,7), :);
            nIncorrect = size(incorrect, 1);
            nIncorrect_seen = size(incorrect(incorrect(:,8) == 3), 1);
            
            
            % Collect data
            accuracies(contrast, cond, subj) = prop_correct;            
            
            if nCorrect == 0
                phit(contrast, cond, subj) = 0;
            else
                phit(contrast, cond, subj) = nCorrect_seen / nCorrect;
            end
            
            if nIncorrect == 0 
                pfa(contrast, cond, subj) = 0;
            else
                pfa(contrast, cond, subj) = nIncorrect_seen / nIncorrect;
            end
            
            
            phit(phit == 0) = 0.01; phit(phit == 1) = 0.99;
            pfa(pfa == 0) = 0.01; pfa(pfa == 1) = 0.99;
            
            dPrimeII(contrast, cond, subj) = dprime( phit(contrast, cond, subj),...
                pfa(contrast, cond, subj) );
            
            auc_II(contrast, cond, subj) = AreaUnderROC([0 phit(contrast, cond, subj) 1; ...
                0 pfa(contrast, cond, subj) 1; ]');            
            
        end
    end
end

mAuc_II     = mean(auc_II, 3);
semAUCII    = std(auc_II, [],3) / sqrt(length(subjects));
mDprimeII   = mean(dPrimeII, 3);
semDprimeII = std(dPrimeII, [], 3) / sqrt(length(subjects));

figure(1); clf;
hold on
p1= plot(mask_freq', mAuc_II(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k');
errorbar(mask_freq', mAuc_II(1,:), semAUCII(1,:), 'Color', [0 0 0]);

p2= plot(mask_freq', mAuc_II(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k');
errorbar(mask_freq', mAuc_II(2,:), semAUCII(2,:), 'Color', [0.5 0.5 0.5] );

p3= plot(mask_freq', mAuc_II(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k');
errorbar(mask_freq', mAuc_II(3,:), semAUCII(3,:), 'Color', [0.75 0.75 0.75] );

ylim([0.45 1])
set(gca, 'XTick', mask_freq)
title('Exp 2')
xlabel('Mondrian Frequency')
ylabel('Type II AUC')
legend([p1 p2 p3],'12', '16', '64', 'Location', 'Best')
legend boxoff
print(gcf, '-dpng', [figsDir 'Exp2_AUC.png'])

figure(2); clf;
hold on
p1= plot(mask_freq', mDprimeII(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k');
errorbar(mask_freq',mDprimeII(1,:), semDprimeII(1,:), 'Color', [0 0 0]);

p2= plot(mask_freq', mDprimeII(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k');
errorbar(mask_freq', mDprimeII(2,:), semDprimeII(2,:), 'Color', [0.5 0.5 0.5] );

p3= plot(mask_freq', mDprimeII(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k');
errorbar(mask_freq', mDprimeII(3,:), semDprimeII(3,:), 'Color', [0.75 0.75 0.75] );

set(gca, 'XTick', mask_freq)
title('Exp 2')
xlabel('Mondrian Frequency')
ylabel('Type II d Prime')
legend([p1 p2 p3],'12', '16', '64', 'Location', 'Best')
legend boxoff
print(gcf, '-dpng', [figsDir 'Exp2_dPrime.png'])

close all
clear accuracies phit pfa dPrimeII auc_II


%% Type II d prime experiment 3

%  timingConds = { 'backwardMasking' 'forwardMasking' 'middleMasking'}; %
%  1, 2, 3

%Visibility
mask_freq       = unique(data_ctr(:,5)); 
all_contrasts   = unique(data_ctr(:,3)); 
subjects        = unique(data_ctr(:,1)); 


for subj = 1: length(subjects)
    for contrast = 1 :length(all_contrasts)
        for cond =1 : length(mask_freq)
        
            
            % Filter by subject, contrast and condition
            aux_data = data_ctr( data_ctr(:,1) == subjects(subj) & data_ctr(:,5) ==mask_freq(cond)...
                & data_ctr(:,3)== all_contrasts(contrast), :) ; 
            
            % just a sanity check
            if size(aux_data, 1) ~= 40
%                 display ('ERROR IN THE NUMBER OF TRIALS')
%                 return
            end
            
            % Correct responses
            correct = aux_data( aux_data(:,6) == aux_data(:,7), :);
            nCorrect = size( correct, 1);
            prop_correct = nCorrect / size(aux_data, 1); 
            nCorrect_seen = size(correct(correct(:,8) == 3), 1);
            
            % Incorrect responses
            incorrect = aux_data( aux_data(:,6) ~= aux_data(:,7), :);
            nIncorrect = size(incorrect, 1);
            nIncorrect_seen = size(incorrect(incorrect(:,8) == 3), 1);
            
            
            % Collect data
            accuracies(contrast, cond, subj) = prop_correct;            
            
            if nCorrect == 0
                phit(contrast, cond, subj) = 0;
            else
                phit(contrast, cond, subj) = nCorrect_seen / nCorrect;
            end
            
            if nIncorrect == 0 
                pfa(contrast, cond, subj) = 0;
            else
                pfa(contrast, cond, subj) = nIncorrect_seen / nIncorrect;
            end
            
            
            phit(phit == 0) = 0.01; phit(phit == 1) = 0.99;
            pfa(pfa == 0) = 0.01; pfa(pfa == 1) = 0.99;
            
            dPrimeII(contrast, cond, subj) = dprime( phit(contrast, cond, subj),...
                pfa(contrast, cond, subj) );
            
            auc_II(contrast, cond, subj) = AreaUnderROC([0 phit(contrast, cond, subj) 1; ...
                0 pfa(contrast, cond, subj) 1; ]');            
            
        end
    end
end

% d_primes_type1(su, bi) = dprime( hit_rate(su, bi), falseAlarm_rate(su, bi)); %#ok / sqrt(2);       
         

mAuc_II     = mean(auc_II, 3);
semAUCII    = std(auc_II, [],3) / sqrt(length(subjects));
mDprimeII   = mean(dPrimeII, 3);
semDprimeII = std(dPrimeII, [], 3) / sqrt(length(subjects));


figure(1); clf;
hold on
p1= plot(mask_freq', mAuc_II(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k');
errorbar(mask_freq', mAuc_II(1,:), semAUCII(1,:), 'Color', [0 0 0]);

p2= plot(mask_freq', mAuc_II(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k');
errorbar(mask_freq', mAuc_II(2,:), semAUCII(2,:), 'Color', [0.5 0.5 0.5] );

p3= plot(mask_freq', mAuc_II(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k');
errorbar(mask_freq', mAuc_II(3,:), semAUCII(3,:), 'Color', [0.75 0.75 0.75] );

ylim([0.45 1])
set(gca, 'XTick', mask_freq)
title('Exp 3')
xlabel('Mondrian Frequency')
ylabel('Type II AUC')
legend([p1 p2 p3],'12', '16', '64', 'Location', 'Best')
legend boxoff
print(gcf, '-dpng', [figsDir 'Exp3_AUC.png'])

figure(2); clf;
hold on
p1= plot(mask_freq', mDprimeII(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k');
errorbar(mask_freq',mDprimeII(1,:), semDprimeII(1,:), 'Color', [0 0 0]);

p2= plot(mask_freq', mDprimeII(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k');
errorbar(mask_freq', mDprimeII(2,:), semDprimeII(2,:), 'Color', [0.5 0.5 0.5] );

p3= plot(mask_freq', mDprimeII(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k');
errorbar(mask_freq', mDprimeII(3,:), semDprimeII(3,:), 'Color', [0.75 0.75 0.75] );

set(gca, 'XTick', mask_freq)
title('Exp 3')
xlabel('Mondrian Frequency')
ylabel('Type II d Prime')
legend([p1 p2 p3],'12', '16', '64', 'Location', 'Best')
legend boxoff
print(gcf, '-dpng', [figsDir 'Exp3_dPrime.png'])

close all









