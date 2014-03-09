function analyze_visibility


close all

inDir = './Data_results/';
outDir = './Data_results/';
figsDir = './Figures/';

% close all

addpath(genpath('../Programs/eeglab11_0_4_3b/'))
addpath(genpath('./rm_anova2/'))
addpath(genpath('./teg_stats/'))


% (1) subject number ; (2) Block number; (3) contrast value ; (4) timing
% value ('backwardMasking' 'forwardMasking' 'middleMasking' 'control'}; 1, 2, 3, 4);
% (5) code for the timing conditions ; (6) location of the checkerboard
% (7) responses for locations ; (8) responses for subjective visibility (3:
% Yes, 4: No)
data = load([ inDir 'Data_12Subjects.mat']);
data_main = data.Data;
% data_main = data_main; %(data_main(:,4) < 10 | data_main(:,4) > 40, :);

% (1) subject number ; (2) Block number; (3) contrast value ; (4) timing of checkerboard;
% (5) mask frequencies; (6) location of the checkerboard
% (7) responses for locations ; (8) responses for subjective visibility
data_freq = load([inDir 'freqExp_Subjects_1   2   3   4   5   6   7   8   9  10  11  12.mat']);
data_frq = data_freq.Data;

data_control = load([inDir 'freqExp_Control_Subjects_1  2  3  6  7  8  9.mat']);
data_ctr = data_control.Data;


%% Test for adaptation effects

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
            
            prop_seen(cond, contrast, subj) = size(aux_data(aux_data(:,8) == 3), 1) / size(aux_data,1);
        end
    end
end


%% PROPORTION SEEN

mProp_seen = mean(prop_seen,3);
semProp_seen = std(prop_seen, [], 3) / sqrt(length(subjects));

f=figure(101); clf; 
set(f, 'Position', [0 0 800 600], 'PaperPositionMode', 'auto')
markerSize = 10;
hold on
x_axis = log10([4 12 16 24 64]); % all_contrasts'

p1 = plot(x_axis, mProp_seen(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(x_axis, mProp_seen(1,:), semProp_seen(1,:), 'Color', [0 0 0]);

p2 = plot(x_axis, mProp_seen(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(x_axis, mProp_seen(2,:), semProp_seen(2,:), 'Color', [0.5 0.5 0.5] );

p3 = plot(x_axis, mProp_seen(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(x_axis, mProp_seen(3,:), semProp_seen(3,:), 'Color', [0.75 0.75 0.75] );

ylim([0 1])
set(gca, 'XTick', x_axis, 'XTickLabel', all_contrasts * 100)
% title('Exp 1')
xlabel('Contrast', 'FontSize', 20, 'FontWeight', 'Bold')
ylabel('p(seen)','FontSize', 20, 'FontWeight', 'Bold')
set(gca, 'FontSize', 15, 'FontWeight', 'Bold')
legend([p1 p2 p3],'Backward', 'Forward', 'Middle', 'Location', 'East')
legend boxoff
print(gcf, '-depsc', [figsDir 'Exp1_propSeen'])

% M is an N x k matrix of N observations of k nested combinations of factors, 
% as ordered in SPSS. levels is a vector of number-of-levels per factor, from highest 
% to lowest level. varnames is a cell array of variable names.
acc = [];
acc = prop_seen(1:3, :, :);
levels = [3 5];
varnames = {'Masking Condition' 'Contrast'};
for su = 1 : length(subjects)    
    M(su,:) = reshape(acc(:,:, su)', levels(1) * levels(2), 1)';
end
aov_propSeen_exp1 = teg_repeated_measures_ANOVA(M, levels, varnames);

% Post hoc t-tests

% 12% contrast
bw = squeeze(prop_seen(1,2,:));
fw = squeeze(prop_seen(2,2,:));
md = squeeze(prop_seen(3,2,:));
[h,p1,ci,stats] = ttest(bw, fw);
[h,p2,ci,stats] = ttest(bw, md);
[h,p3,ci,stats] = ttest(md, fw);

% 12% contrast
bw = squeeze(prop_seen(1,3,:));
fw = squeeze(prop_seen(2,3,:));
md = squeeze(prop_seen(3,3,:));
[h,p4,ci,stats] = ttest(bw, fw);
[h,p5,ci,stats] = ttest(bw, md);
[h,p6,ci,stats] = ttest(md, fw);

close all

%% ACCURACY (P CORRECT)

% acc = accuracies(1:3,:, :); % we don't take into acount the control condition (row 4)

% overall_mean = mean(acc(:));
% for su = 1 : length(subjects)
%     subject_mean(su) = mean(mean(accuracies(1:3,:,su))); %#ok
%     accuracies(1:3,:,su) =  accuracies(1:3,:,su); % - (subject_mean(su) - overall_mean); %#ok
% end

mAccuracy = mean(accuracies, 3); 
semAccuracy = std(accuracies, [], 3) / sqrt(length(subjects)) / 2;


f = figure(1); clf;
set(f, 'Position', [0 0 800 600], 'PaperPositionMode', 'auto')
markerSize = 10;
hold on
x_axis = log10([4 12 16 24 64]); % all_contrasts'
p1 = plot(x_axis, mAccuracy(1,:), '-s', 'MarkerFaceColor', [0 0 0], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(x_axis, mAccuracy(1,:), semAccuracy(1,:), 'Color', [0 0 0], 'LineStyle', '-'); %

p2 = plot(x_axis, mAccuracy(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(x_axis, mAccuracy(2,:), semAccuracy(2,:), 'Color', [0.5 0.5 0.5], 'LineStyle', '-' );

p3 = plot(x_axis, mAccuracy(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(x_axis, mAccuracy(3,:), semAccuracy(3,:), 'Color', [0.75 0.75 0.75], 'LineStyle', '-' );

ylim([0.2 1])
set(gca, 'XTick', x_axis, 'XTickLabel', all_contrasts * 100)
xlabel('Contrast', 'FontSize', 20, 'FontWeight', 'Bold')
ylabel('p(correct)', 'FontSize', 20, 'FontWeight', 'Bold')
set(gca, 'FontSize', 15, 'FontWeight', 'Bold')
line([0.5 1.9], [0.25 0.25], 'LineStyle', '--', 'LineWidth', 2, 'Color', 'k')
legend([p1 p2 p3],'Backward', 'Forward', 'Middle', 'Location', 'East')
legend boxoff
print(gcf, '-depsc', [figsDir 'Exp1_accuracies'])

close all

%%

% REPEATED MEASURES ANOVA for accuracy of experiment 1
acc = [];
acc = accuracies(1:4, :, :);
M = [];
levels = [4 5];
varnames = {'Masking Condition' 'Contrast'};

for su = 1 : length(subjects)    
    M(su,:) = reshape(acc(:,:, su)', levels(1) * levels(2), 1)';
end
levels = [4 5];
varnames = {'Masking Condition' 'Contrast'};

aov_acc_exp1 = teg_repeated_measures_ANOVA(M, levels, varnames);

% 12% contrast
bw = squeeze(accuracies(1,2,:));
fw = squeeze(accuracies(2,2,:));
md = squeeze(accuracies(3,2,:));
ctr = squeeze(accuracies(4,2,:));
[h,p1,ci,stats] = ttest(bw, fw); % paired samples t-test
[h,p2,ci,stats] = ttest(bw, md); % Only this is significant after correcting for 0.05 / 6 = 0.008
[h,p3,ci,stats] = ttest(md, fw);
[h,p4,ci,stats] = ttest(ctr, fw);
[h,p5,ci,stats] = ttest(ctr, bw);
[h,p6,ci,stats] = ttest(ctr, md);

% 16% contrast
bw = squeeze(accuracies(1,3,:));
fw = squeeze(accuracies(2,3,:));
md = squeeze(accuracies(3,3,:));
ctr = squeeze(accuracies(4,3,:));
[h,p7,ci,stats] = ttest(bw, fw);
[h,p8,ci,stats] = ttest(bw, md); % Only this is significant after correcting for 0.05 / 6 = 0.008
[h,p9,ci,stats] = ttest(md, fw);
[h,p10,ci,stats] = ttest(ctr, fw);
[h,p11,ci,stats] = ttest(ctr, bw);
[h,p12,ci,stats] = ttest(ctr, md);



%% HISTOGRAM MIDDLE VS CONTROL (ADAPTATION)

figure(3); clf;
hold on
bh = bar(1:5, mAccuracy(3:4,:)');
errorbar( (1:5) - 0.15, mAccuracy(3,:), semAccuracy(3,:), 'Color', [0 0 0], 'LineStyle', 'none' );
errorbar( (1:5) + 0.15,  mAccuracy(4,:), semAccuracy(4,:), 'Color', [0 0 0], 'LineStyle', 'none' );

set(bh(1), 'FaceColor', [0.2 0.2 0.2])
set(bh(2), 'FaceColor', [0.5 0.5 0.5])
set(gca, 'XTick', 1:5, 'XTickLabel', all_contrasts * 100)
ylim([0 1])
xlabel('Contrast', 'FontSize', 20, 'FontWeight', 'Bold')
ylabel('p(correct)', 'FontSize', 20, 'FontWeight', 'Bold')
set(gca, 'FontSize', 15)
legend('Middle', 'Control', 'Location', 'NorthWest')
legend boxoff
% print(gcf, '-dpng', [figsDir 'Exp1_middleVsControl.png'])


% M is an N x k matrix of N observations of k nested combinations of factors, 
% as ordered in SPSS. levels is a vector of number-of-levels per factor, from highest 
% to lowest level. varnames is a cell array of variable names.
acc = []; M = [];
acc = accuracies(3:4, :, :);
for su = 1 : length(subjects)    
    M(su,:) = reshape(acc(:,:, su)', 10, 1)';
end
levels = [2 5];
varnames = {'Masking Condition' 'Contrast'};

% MiddvsControl = teg_repeated_measures_ANOVA(M, levels, varnames);


clear accuracies mAccuracy semAccuracy prop_seen mProp_seen  semProp_seen O

close all

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
            
            prop_seen(cond, contrast, subj) = size(aux_data(aux_data(:,8) == 3), 1) / size(aux_data,1);

            
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

%% Plot false alarm rate and hit rate for near-threshold stimuli

aux = squeeze(phit(:,2,:));
mean_phit = mean(aux, 2);
sem_phit = std(aux, [], 2) ./ sqrt(size( aux, 2));
aux = squeeze(pfa(:,2,:));
mean_pfa = mean(aux, 2);
sem_pfa = std(aux, [], 2) ./ sqrt(size(aux, 2));


data = [ mean_phit(1) mean_pfa(1); mean_phit(2) mean_pfa(2); mean_phit(3) mean_pfa(3)   ];

f =figure(30); clf;
set(f, 'Position', [0 0 800 600], 'PaperPositionMode', 'auto')
hold on
bh= bar (1:3, data);
errorbar( (1:3) - 0.145, mean_phit, sem_phit, 'Color', [0 0 0], 'LineStyle', 'none', 'LineWidth', 1);
errorbar( (1:3) + 0.145,  mean_pfa, sem_pfa, 'Color', [0 0 0], 'LineStyle', 'none', 'LineWidth', 1 );

set(bh(1), 'FaceColor', [0.2 0.2 0.2])
set(bh(2), 'FaceColor', [0.5 0.5 0.5])
set(gca, 'XTick', 1:3, 'XTickLabel', {'Backward' 'Forward' 'Middle'})
ylim([0 1])
xlabel('Masking Condition', 'FontSize', 20, 'FontWeight', 'Bold')
ylabel('Rate', 'FontSize', 20, 'FontWeight', 'Bold')
set(gca, 'FontSize', 15)
legend('Hits', 'False Alarms', 'Location', 'NorthWest')
legend boxoff
print(gcf, '-depsc', [figsDir 'Exp1_Hit_Fa_rate'])

close all

% REPEATED MEASURES ANOVA for accuracy of experiment 1
aux_hit = reshape(phit(:,2,:), 1, 3, 12);
aux_fa = reshape(pfa(:,2,:), 1, 3, 12);

acc = [];
acc = cat(1, aux_hit, aux_fa);
M = [];
levels = [2 3];
varnames = {'Rates' 'Masking Condition'};

for su = 1 : length(subjects)    
    M(su,:) = reshape(acc(:,:, su)', levels(1) * levels(2), 1)';
end

aov_acc_exp1 = teg_repeated_measures_ANOVA(M, levels, varnames);




%%
% mProp_seen = mean(prop_seen,3);
% semProp_seen = std(prop_seen, [], 3) / sqrt(length(subjects));
% 
% f = figure(100); clf;
% set(f, 'Position', [0 0 800 600], 'PaperPositionMode', 'auto')
% markerSize = 10;
% hold on
% x_axis = log10([4 12 16 24 64]); % all_contrasts'
% p1 = plot(all_contrasts', mProp_seen(1,:), 's--', 'MarkerFaceColor', [0 0 0], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 2);
% errorbar(all_contrasts', mProp_seen(1,:), semProp_seen(1,:), 'Color', [0 0 0]);
% 
% p2 = plot(all_contrasts', mProp_seen(2,:), 'o--',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 2);
% errorbar(all_contrasts', mProp_seen(2,:), semProp_seen(2,:), 'Color', [0.5 0.5 0.5] );
% 
% p3 = plot(all_contrasts', mProp_seen(3,:), '^--', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 2);
% errorbar(all_contrasts', mProp_seen(3,:), semProp_seen(3,:), 'Color', [0.75 0.75 0.75] );
% 
% ylim([0 1])
% set(gca, 'XTick', all_contrasts, 'XTickLabel', all_contrasts * 100)
% xlabel('Contrast', 'FontSize', 20, 'FontWeight', 'Bold')
% ylabel('p(seen)', 'FontSize', 20, 'FontWeight', 'Bold')
% set(gca, 'FontSize', 15)
% legend([p1 p2 p3],'Backward', 'Forward', 'Middle', 'Location', 'SouthEast')
% legend boxoff
% print(gcf, '-dpng', [figsDir 'Exp2_propSeen.png']) 

% 
% mAuc_II     = mean(auc_II, 3);
% semAUCII    = std(auc_II, [],3) / sqrt(length(subjects));

% 
% f = figure(1); clf;
% set(f, 'Position', [0 0 800 600], 'PaperPositionMode', 'auto')
% hold on
% x_axis = log10([4 12 16 24 64]); % all_contrasts'
% p1= plot(all_contrasts', mAuc_II(1,:), 's--', 'MarkerFaceColor', [0 0 0], 'Color', 'k', 'LineWidth', 2);
% errorbar(all_contrasts', mAuc_II(1,:), semAUCII(1,:), 'Color', [0 0 0]);
% 
% p2= plot(all_contrasts', mAuc_II(2,:), 'o--',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k', 'LineWidth', 2);
% errorbar(all_contrasts', mAuc_II(2,:), semAUCII(2,:), 'Color', [0.5 0.5 0.5] );
% 
% p3= plot(all_contrasts', mAuc_II(3,:), '^--', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k', 'LineWidth', 2);
% errorbar(all_contrasts', mAuc_II(3,:), semAUCII(3,:), 'Color', [0.75 0.75 0.75] );
% 
% ylim([0.45 1])
% set(gca, 'XTick', all_contrasts, 'XTickLabel', all_contrasts * 100)
% xlabel('Contrast', 'FontSize', 20, 'FontWeight', 'Bold')
% ylabel('Type II AUC', 'FontSize', 20, 'FontWeight', 'Bold')
% set(gca, 'FontSize', 15, 'FontWeight', 'Bold')
% legend([p1 p2 p3], 'Backward', 'Forward', 'Middle', 'Location', 'SouthEast')
% legend boxoff
% print(gcf, '-dpng', [figsDir 'Exp1_AUC.png'])

close all


mDprimeII   = mean(dPrimeII, 3);
semDprimeII = std(dPrimeII, [], 3) / sqrt(length(subjects));


f= figure(2); clf;
set(f, 'Position', [0 0 800 600], 'PaperPositionMode', 'auto')
hold on
markerSize = 10;
x_axis = log10([4 12 16 24 64]); % all_contrasts'
p1= plot(x_axis, mDprimeII(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Markersize', markerSize,  'Color', 'k', 'LineWidth', 1);
errorbar(x_axis, mDprimeII(1,:), semDprimeII(1,:), 'Color', [0 0 0]);

p2= plot(x_axis, mDprimeII(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Markersize', markerSize, 'Color', 'k', 'LineWidth', 1);
errorbar(x_axis, mDprimeII(2,:), semDprimeII(2,:), 'Color', [0.5 0.5 0.5] );

p3= plot(x_axis, mDprimeII(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Markersize', markerSize, 'Color', 'k', 'LineWidth', 1);
errorbar(x_axis, mDprimeII(3,:), semDprimeII(3,:), 'Color', [0.75 0.75 0.75] );

set(gca, 'XTick', x_axis, 'XTickLabel', all_contrasts * 100)
xlabel('Contrast', 'FontSize', 20, 'FontWeight', 'Bold')
ylabel('Type II d Prime', 'FontSize', 20, 'FontWeight', 'Bold')
set(gca, 'FontSize', 15, 'FontWeight', 'Bold')
legend([p1 p2 p3], 'Backward', 'Forward', 'Middle', 'Location', 'East')
legend boxoff
print(gcf, '-depsc', [figsDir 'Exp1_dPrime'])


% Repeated measures anova
acc = []; M = [];
acc = dPrimeII(1:3, :, :);
levels = [3 5];
varnames = {'Masking Condition' 'Contrast'};
for su = 1 : length(subjects)    
    M(su,:) = reshape(acc(:,:, su)', levels(1) * levels(2), 1)';
end
aov_dP2_exp1 = teg_repeated_measures_ANOVA(M, levels, varnames);

% Post hoc t-tests

% 12% contrast
bw = squeeze(prop_seen(1,4,:));
fw = squeeze(prop_seen(2,4,:));
md = squeeze(prop_seen(3,4,:));
[h,p1,ci,stats] = ttest(bw, fw);
[h,p2,ci,stats] = ttest(bw, md);
[h,p3,ci,stats] = ttest(md, fw);

% 12% contrast
bw = squeeze(prop_seen(1,3,:));
fw = squeeze(prop_seen(2,3,:));
md = squeeze(prop_seen(3,3,:));
[h,p4,ci,stats] = ttest(bw, fw);
[h,p5,ci,stats] = ttest(bw, md);
[h,p6,ci,stats] = ttest(md, fw);


close all
clear accuracies phit pfa dPrimeII auc_II
clear accuracies mAccuracy semAccuracy prop_seen mProp_seen  semProp_seen



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
            
            prop_seen(contrast, cond, subj) = size(aux_data(aux_data(:,8) == 3), 1) / size(aux_data,1);

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


% acc = accuracies(1:3,:, :); % we don't take into acount the control condition (row 4)
% overall_mean = mean(acc(:));
% for su = 1 : length(subjects)
%     subject_mean(su) = mean(mean(accuracies(1:3,:,su))); %#ok
%     accuracies(1:3,:,su) =  accuracies(1:3,:,su) - (subject_mean(su) - overall_mean); %#ok
% end

mAccuracy = mean(accuracies, 3);
semAccuracy = std(accuracies, [], 3) / sqrt(length(subjects));


f = figure(90); clf;
set(f, 'Position', [0 0 800 600], 'PaperPositionMode', 'auto')
markerSize = 10;
hold on
p1 = plot(mask_freq', mAccuracy(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(mask_freq', mAccuracy(1,:), semAccuracy(1,:), 'Color', [0 0 0]);

p2 = plot(mask_freq', mAccuracy(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(mask_freq', mAccuracy(2,:), semAccuracy(2,:), 'Color', [0.5 0.5 0.5] );

% p3 = plot(mask_freq', mAccuracy(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k', 'MarkerSize', markerSize);
% errorbar(mask_freq', mAccuracy(3,:), semAccuracy(3,:), 'Color', [0.75 0.75 0.75] );

ylim([0.15 1.05])
set(gca, 'XTick', mask_freq)
xlabel('Mondrian Frequency', 'FontSize', 20, 'FontWeight', 'Bold')
ylabel('p(correct)', 'FontSize', 20, 'FontWeight', 'Bold')
set(gca, 'FontSize', 15, 'FontWeight', 'Bold')
legend([p1 p2],'12', '16', 'Location', 'Best')
legend boxoff
line([0 30], [0.25 0.25], 'LineStyle', '--', 'LineWidth', 2, 'Color', 'k')

print(gcf, '-depsc', [figsDir 'Exp2_accuracies'])
close all

mProp_seen = mean(prop_seen,3);
semProp_seen = std(prop_seen, [], 3) / sqrt(length(subjects));

f =figure(102); clf;
set(f, 'Position', [0 0 800 600], 'PaperPositionMode', 'auto')
markerSize = 10;
hold on
p1 = plot(mask_freq', mProp_seen(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(mask_freq', mProp_seen(1,:), semProp_seen(1,:), 'Color', [0 0 0]);

p2 = plot(mask_freq', mProp_seen(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(mask_freq', mProp_seen(2,:), semProp_seen(2,:), 'Color', [0.5 0.5 0.5] );

% p3 = plot(mask_freq', mProp_seen(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k', 'MarkerSize', markerSize);
% errorbar(mask_freq', mProp_seen(3,:), semProp_seen(3,:), 'Color', [0.75 0.75 0.75] );

ylim([0 1])
set(gca, 'XTick', mask_freq)
xlabel('Mondrian Frequency', 'FontSize', 20, 'FontWeight', 'Bold')
ylabel('p(seen)', 'FontSize', 20, 'FontWeight', 'Bold')
set(gca, 'FontSize', 15, 'FontWeight', 'Bold')
legend([p1 p2],'12', '16', 'Location', 'Best')
legend boxoff
print(gcf, '-depsc', [figsDir 'Exp2_propSeen']) 

mAuc_II     = mean(auc_II, 3);
semAUCII    = std(auc_II, [],3) / sqrt(length(subjects));
mDprimeII   = mean(dPrimeII, 3);
semDprimeII = std(dPrimeII, [], 3) / sqrt(length(subjects));

% figure(1); clf;
% hold on
% p1= plot(mask_freq', mAuc_II(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k');
% errorbar(mask_freq', mAuc_II(1,:), semAUCII(1,:), 'Color', [0 0 0]);
% 
% p2= plot(mask_freq', mAuc_II(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k');
% errorbar(mask_freq', mAuc_II(2,:), semAUCII(2,:), 'Color', [0.5 0.5 0.5] );
% % 
% % p3= plot(mask_freq', mAuc_II(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k');
% % errorbar(mask_freq', mAuc_II(3,:), semAUCII(3,:), 'Color', [0.75 0.75 0.75] );
% 
% ylim([0.45 1])
% set(gca, 'XTick', mask_freq)
% xlabel('Mondrian Frequency', 'FontSize', 20, 'FontWeight', 'Bold')
% ylabel('Type II AUC', 'FontSize', 20, 'FontWeight', 'Bold')
% set(gca, 'FontSize', 15)
% legend([p1 p2],'12', '16', 'Location', 'Best')
% legend boxoff
% print(gcf, '-dpng', [figsDir 'Exp2_AUC.png'])



f =figure(2); clf;
set(f, 'Position', [0 0 800 600], 'PaperPositionMode', 'auto')
markerSize = 10;
hold on
p1= plot(mask_freq', mDprimeII(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'MarkerSize', markerSize, 'Color', 'k', 'LineWidth', 1);
errorbar(mask_freq',mDprimeII(1,:), semDprimeII(1,:), 'Color', [0 0 0]);

p2= plot(mask_freq', mDprimeII(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerSize', markerSize,'Color', 'k', 'LineWidth', 1);
errorbar(mask_freq', mDprimeII(2,:), semDprimeII(2,:), 'Color', [0.5 0.5 0.5] );

% p3= plot(mask_freq', mDprimeII(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k');
% errorbar(mask_freq', mDprimeII(3,:), semDprimeII(3,:), 'Color', [0.75 0.75 0.75] );

set(gca, 'XTick', mask_freq)
xlabel('Mondrian Frequency', 'FontSize', 20, 'FontWeight', 'Bold')
ylabel('Type II d Prime', 'FontSize', 20, 'FontWeight', 'Bold')
set(gca, 'FontSize', 15, 'FontWeight', 'Bold')
legend([p1 p2],'12', '16', 'Location', 'Best')
legend boxoff
print(gcf, '-depsc', [figsDir 'Exp2_dPrime'])


%% REPEATED MEASURES ANOVA

% ACCURACY
acc = []; M = [];
acc = accuracies(1:2, :, :);
for su = 1 : length(subjects)    
    M(su,:) = reshape(acc(:,:, su)', 10, 1)';
end
levels = [2 5];
varnames = {'Constrast' 'Mondrian Frequency'};
aov_acc_exp2 = teg_repeated_measures_ANOVA(M, levels, varnames);

% PROPORTION SEEN
acc = []; M = [];
acc = prop_seen(1:2, :, :);
for su = 1 : length(subjects)    
    M(su,:) = reshape(acc(:,:, su)', 10, 1)';
end
levels = [2 5];
varnames = {'Contrast' 'Mondrian Frequency'};
aov_propSeen_exp2 = teg_repeated_measures_ANOVA(M, levels, varnames);


% TYPE II D PRIME
acc = []; M = [];
acc = dPrimeII(1:2, :, :);
for su = 1 : length(subjects)    
    M(su,:) = reshape(acc(:,:, su)', 10, 1)';
end
levels = [2 5];
varnames = {'Contrast' 'Mondrian Frequency'};
aov_dP2_exp2 = teg_repeated_measures_ANOVA(M, levels, varnames);



close all
clear accuracies phit pfa dPrimeII auc_II
clear accuracies mAccuracy semAccuracy prop_seen mProp_seen  semProp_seen


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
            
            prop_seen(contrast, cond, subj) = size(aux_data(aux_data(:,8) == 3), 1) / size(aux_data,1);

            
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


% acc = accuracies(1:3,:, :); % we don't take into acount the control condition (row 4)
% overall_mean = mean(acc(:));
% for su = 1 : length(subjects)
%     subject_mean(su) = mean(mean(accuracies(1:3,:,su))); %#ok
%     accuracies(1:3,:,su) =  accuracies(1:3,:,su) - (subject_mean(su) - overall_mean); %#ok
% end



mAccuracy = mean(accuracies, 3);
semAccuracy = std(accuracies, [], 3) / sqrt(length(subjects));


f =figure(92); clf;
set(f, 'Position', [0 0 800 600], 'PaperPositionMode', 'auto')
markerSize = 10;
hold on
p1 = plot(mask_freq', mAccuracy(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(mask_freq', mAccuracy(1,:), semAccuracy(1,:), 'Color', [0 0 0]);

p2 = plot(mask_freq', mAccuracy(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(mask_freq', mAccuracy(2,:), semAccuracy(2,:), 'Color', [0.5 0.5 0.5] );

% p3 = plot(mask_freq', mAccuracy(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k', 'MarkerSize', markerSize);
% errorbar(mask_freq', mAccuracy(3,:), semAccuracy(3,:), 'Color', [0.75 0.75 0.75] );

ylim([0.15 1.05])
set(gca, 'XTick', mask_freq)
xlabel('Mondrian Frequency', 'FontSize', 20, 'FontWeight', 'Bold')
ylabel('p(correct)', 'FontSize', 20, 'FontWeight', 'Bold')
set(gca, 'FontSize', 15, 'FontWeight', 'Bold')
legend([p1 p2],'12', '16', 'Location', 'Best')
legend boxoff
line([0 30], [0.25 0.25], 'LineStyle', '--', 'LineWidth', 2, 'Color', 'k')

print(gcf, '-depsc', [figsDir 'Exp3_accuracies'])
close all


mProp_seen = mean(prop_seen,3);
semProp_seen = std(prop_seen, [], 3) / sqrt(length(subjects));

f= figure(103); clf;
set(f, 'Position', [0 0 800 600], 'PaperPositionMode', 'auto')
markerSize = 10;
hold on
p1 = plot(mask_freq', mProp_seen(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(mask_freq', mProp_seen(1,:), semProp_seen(1,:), 'Color', [0 0 0]);

p2 = plot(mask_freq', mProp_seen(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k', 'MarkerSize', markerSize, 'LineWidth', 1);
errorbar(mask_freq', mProp_seen(2,:), semProp_seen(2,:), 'Color', [0.5 0.5 0.5] );

% p3 = plot(mask_freq', mProp_seen(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k', 'MarkerSize', markerSize);
% errorbar(mask_freq', mProp_seen(3,:), semProp_seen(3,:), 'Color', [0.75 0.75 0.75] );

ylim([0 1])
set(gca, 'XTick', mask_freq)
xlabel('Mondrian Frequency', 'FontSize', 20, 'FontWeight', 'Bold')
ylabel('p(seen)', 'FontSize', 20, 'FontWeight', 'Bold')
set(gca, 'FontSize', 15, 'FontWeight', 'Bold')
legend([p1 p2],'12', '16', 'Location', 'Best')
legend boxoff
print(gcf, '-depsc', [figsDir 'Exp3_propSeen'])          
close all


mAuc_II     = mean(auc_II, 3);
semAUCII    = std(auc_II, [],3) / sqrt(length(subjects));
mDprimeII   = mean(dPrimeII, 3);
semDprimeII = std(dPrimeII, [], 3) / sqrt(length(subjects));


% figure(1); clf;
% hold on
% p1= plot(mask_freq', mAuc_II(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'Color', 'k');
% errorbar(mask_freq', mAuc_II(1,:), semAUCII(1,:), 'Color', [0 0 0]);
% 
% p2= plot(mask_freq', mAuc_II(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'Color', 'k');
% errorbar(mask_freq', mAuc_II(2,:), semAUCII(2,:), 'Color', [0.5 0.5 0.5] );
% 
% % p3= plot(mask_freq', mAuc_II(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k');
% % errorbar(mask_freq', mAuc_II(3,:), semAUCII(3,:), 'Color', [0.75 0.75 0.75] );
% 
% ylim([0.45 1])
% set(gca, 'XTick', mask_freq)
% xlabel('Mondrian Frequency', 'FontSize', 20, 'FontWeight', 'Bold')
% ylabel('Type II AUC', 'FontSize', 20, 'FontWeight', 'Bold')
% set(gca, 'FontSize', 15)
% legend([p1 p2 ],'12', '16', 'Location', 'Best')
% legend boxoff
% print(gcf, '-dpng', [figsDir 'Exp3_AUC.png'])



f=figure(2); clf;
set(f, 'Position', [0 0 800 600], 'PaperPositionMode', 'auto')
markerSize = 10;
hold on
p1= plot(mask_freq', mDprimeII(1,:), 's-', 'MarkerFaceColor', [0 0 0], 'MarkerSize', markerSize, 'Color', 'k', 'LineWidth', 1);
errorbar(mask_freq',mDprimeII(1,:), semDprimeII(1,:), 'Color', [0 0 0]);

p2= plot(mask_freq', mDprimeII(2,:), 'o-',  'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerSize', markerSize, 'Color', 'k', 'LineWidth', 1);
errorbar(mask_freq', mDprimeII(2,:), semDprimeII(2,:), 'Color', [0.5 0.5 0.5] );

% p3= plot(mask_freq', mDprimeII(3,:), '^-', 'MarkerFaceColor', [0.75 0.75 0.75], 'Color', 'k');
% errorbar(mask_freq', mDprimeII(3,:), semDprimeII(3,:), 'Color', [0.75 0.75 0.75] );

set(gca, 'XTick', mask_freq)
xlabel('Mondrian Frequency', 'FontSize', 20, 'FontWeight', 'Bold')
ylabel('Type II d Prime', 'FontSize', 20, 'FontWeight', 'Bold')
set(gca, 'FontSize', 15, 'FontWeight', 'Bold')
legend([p1 p2],'12', '16', 'Location', 'Best')
legend boxoff
print(gcf, '-depsc', [figsDir 'Exp3_dPrime'])



% REPEATED MEASURES ANOVA

% ACCURACY
acc = []; M = [];
acc = accuracies(1:2, :, :);
for su = 1 : length(subjects)    
    M(su,:) = reshape(acc(:,:, su)', 10, 1)';
end
levels = [2 5];
varnames = {'Contrast' 'Mondrian Frequency'};
aov_acc_exp3 = teg_repeated_measures_ANOVA(M, levels, varnames);


% PROPORTION SEEN
acc = []; M = [];
acc = prop_seen(1:2, :, :);
for su = 1 : length(subjects)    
    M(su,:) = reshape(acc(:,:, su)', 10, 1)';
end
levels = [2 5];
varnames = {'Contrast' 'Mondrian Frequency'};
aov_propSeen_exp3 = teg_repeated_measures_ANOVA(M, levels, varnames);


% TYPE II D PRIME
acc = []; M = [];
acc = dPrimeII(1:2, :, :);
for su = 1 : length(subjects)    
    M(su,:) = reshape(acc(:,:, su)', 10, 1)';
end
levels = [2 5];
varnames = {'Contrast' 'Mondrian Frequency'};
aov_dP2_exp3 = teg_repeated_measures_ANOVA(M, levels, varnames);



close all

clear accuracies mAccuracy semAccuracy prop_seen mProp_seen  semProp_seen








