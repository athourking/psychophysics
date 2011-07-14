function analyze_Accuracy (Data, fileName, outDir)
%This function is embedded in the script analyze_concatenateData. It takes
%the data of the subjects that have been concatenated into a single matrix
%(either all subjects or the ones filtered out in that function) called 
%Data and appends a number of new variables. See the bottom of this
%function to see which ones. 'Data' - the matrix, 'fileName' - how to save it,
%outDir - where to save it. analyze_Accuracy puts it back into the same
%folder, with the same name as the file of the concatenated data matrix.
%% Conditions :
% (1) subject number ; (2) Block number; (3) contrast value ; (4) timing
% value ; (5) code for the timing conditions ; (6) location of the checkerboard
% (7) responses for locations ; (8) responses for subjective visibility


% Filter the less than 5 masks condition
Data = Data(Data(:,4) < 10 | Data(:,4) > 40, :);

%  timingConds = { 'backwardMasking' 'forwardMasking' 'middleMasking'}; %
%  1, 2, 3
timing_conditions = unique(Data(:,5)); % -In Exp.2 these are mask timing codes (i.e., frequency)
all_contrasts = unique(Data(:,3)); % -In Exp.2 these are also contrasts
subjects = unique(Data(:,1));  

accuracies =  zeros(length(timing_conditions), length(all_contrasts), length(subjects)); 
yesProportion =  zeros(length(timing_conditions), length(all_contrasts), length(subjects));

for subj = 1: length(subjects)
    for cond =1 : length(timing_conditions)
        for contrast =1 :length(all_contrasts)
            
            % Filter subjects
            aux_data = Data( Data(:,1) == subjects(subj) & Data(:,5) == timing_conditions(cond)...
                & Data(:,3)== all_contrasts(contrast), :) ; 
            % just a sanity check
%             if size(aux_data, 1) ~= 48 %|| size(aux_data, 1) ~= 36 
%                 display ('ERROR IN THE NUMBER OF TRIALS')
%                 return
%             end
            
            correct = size( aux_data( aux_data(:,6) == aux_data(:,7), :), 1) / size(aux_data, 1);            
            accuracies(cond, contrast, subj) = correct;
            yesProportion(cond,contrast,subj) = size(aux_data(aux_data(:,8) == 3 ,:),1) / size(aux_data,1);
        end
    end
end

for m=1: length(all_contrasts)
    cols{m} = num2str(all_contrasts(m)); %#ok
end

% cols= {'0.04' '0.04' '0.08' '0.16' '0.32' '0.64' '0.96'};
rows = {'backward' 'forward' 'middle' 'start'}; %#ok

accuracies_means = mean(accuracies, 3);%#ok
accuracies_std = std(accuracies, 0, 3);%#ok
accuracies_sems = std(accuracies,0, 3) ./ sqrt(size(accuracies, 3));%#ok

for m=1: size(accuracies, 3)
    vector_accuracies = zscore(reshape(accuracies(:,:,m), length(timing_conditions) * length(all_contrasts), 1));
    accuracies_zscored(:,:,m) = reshape(vector_accuracies, length(timing_conditions), length(all_contrasts)); %#ok
%     accuracies_zscored(:,:,m) = zscore(accuracies(:,:,m)); %#ok
end
accuracies_means_zscored = mean(accuracies_zscored, 3);%#ok
accuracies_std_zscored = std(accuracies_zscored, 0, 3);%#ok
accuracies_sems_zscored = std(accuracies_zscored,0, 3) / sqrt(size(accuracies_zscored, 3));%#ok

% Variables that will be used for subjective responses' plot
meanProportion = mean(yesProportion,3);
proportion_sem = std(accuracies,0, 3) ./ sqrt(size(accuracies, 3)); %This for the errorbar
meanProportion_sem_half = proportion_sem / 2; %This for the horizontal error bar


%% Saving all variables to file

save([outDir fileName], 'accuracies', 'accuracies_means', 'accuracies_std', 'accuracies_sems', ...
    'accuracies_zscored', 'accuracies_means_zscored', 'accuracies_std_zscored', 'accuracies_sems_zscored', ...
    'rows', 'cols', 'timing_conditions', 'subjects', 'all_contrasts', 'yesProportion','meanProportion',...
    'proportion_sem','meanProportion_sem_half', '-append')



