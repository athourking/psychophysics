% function analyze_visibility


inDir = './Data_results/';
outDir = './Data_results/';
figsDir = './Figures/';


addpath(genpath('../Programs/eeglab11_0_4_3b/'))


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

data_control = load([inDir 'freqExp_Control_Subjects_1  2  3  6  7  8  9.mat']);

data_frq = data_freq.Data;
data_ctr = data_control.Data;


%% Type II d prime

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
                display ('ERROR IN THE NUMBER OF TRIALS')
                return
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
plot(all_contrasts', mAuc_II(1,:), 's-', 'MarkerFaceColor', [0.1 0.1 0.1], 'Color', 'k')
errorbar(all_contrasts', mAuc_II(1,:), semAUCII(1,:), 'Color', 'k');

plot(all_contrasts', mAuc_II(2,:), 'o-',  'MarkerFaceColor', [0.1 0.1 0.1], 'Color', 'k')
errorbar(all_contrasts', mAuc_II(2,:), semAUCII(2,:), 'Color', 'k' );

plot(all_contrasts', mAuc_II(3,:), '^-', 'MarkerFaceColor', [0.1 0.1 0.1], 'Color', 'k')
errorbar(all_contrasts', mAuc_II(3,:), semAUCII(3,:), 'Color', 'k' );

set(gca, 'XTick', all_contrasts)




figure(2); clf;
hold on
plot(all_contrasts', mDprimeII(1,:), 's-', 'MarkerFaceColor', [0.1 0.1 0.1], 'Color', 'k')
errorbar(all_contrasts',mDprimeII(1,:), semDprimeII(1,:), 'Color', 'k');

plot(all_contrasts', mDprimeII(2,:), 'o-',  'MarkerFaceColor', [0.1 0.1 0.1], 'Color', 'k')
errorbar(all_contrasts', mDprimeII(2,:), semDprimeII(2,:), 'Color', 'k' );

plot(all_contrasts', mDprimeII(3,:), '^-', 'MarkerFaceColor', [0.1 0.1 0.1], 'Color', 'k')
errorbar(all_contrasts', mDprimeII(3,:), semDprimeII(3,:), 'Color', 'k' );

set(gca, 'XTick', all_contrasts)















