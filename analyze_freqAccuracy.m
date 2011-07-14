function analyze_freqAccuracy (Data, fileName, outDir)
%This function is embedded in the script analyze_concatenateData. It takes
%the data of the subjects that have been concatenated into a single matrix
%(either all subjects or the ones filtered out in that function) called 
%Data and appends a number of new variables. See the bottom of this
%function to see which ones. 'Data' - the matrix, 'fileName' - how to save it,
%outDir - where to save it. analyze_Accuracy puts it back into the same
%folder, with the same name as the file of the concatenated data matrix.
%% Conditions :
% (1) subject number ; (2) Block number; (3) contrast value ; (4) mask
% frequencies; (5) code for the mask frequencies; (6) location of the checkerboard
% (7) responses for locations ; (8) responses for subjective visibility

all_contrasts = unique(Data(:,3));
frequencies = unique(Data(:,5));
subjects = unique(Data(:,1));

accuracies =  zeros(length(all_contrasts), length(frequencies), length(subjects)); % 6 x 2 x subjects
yesProportion =  zeros(length(all_contrasts), length(frequencies), length(subjects));

for su = 1: length(subjects)
    for con = 1: length(all_contrasts)
        for freq = 1: length(frequencies)
            % row:contrast, col:frequency, layer:subject; filtering subject,contrast, frequency AND when location 
            % is equal to location response, dividing the whole with the number of trials for this subject for this 
            % contrast and frequency
            accuracies(con, freq, su) = size(Data(Data(:,1) == su & Data(:,3)== all_contrasts(con) & Data(:,5)== frequencies(freq)...
                & Data(:,6)== Data(:,7),:),1)  ...
                / size(Data(Data(:,1) == su & Data(:,3)== all_contrasts(con) & Data(:,5)== frequencies(freq)),1);
            % positions identical; filtering subject, contrast, frequency and when subject said 'yes', dividing the whole 
            % with the number of trials trials for this subject for this contrast and frequency
            yesProportion(con, freq, su) = ...
                size(Data(Data(:,8)==3 & Data(:,1) == su & Data(:,3)== all_contrasts(con) & Data(:,5)== frequencies(freq),:),1)...
                / size(Data(Data(:,1) == su & Data(:,3)== all_contrasts(con) & Data(:,5)== frequencies(freq)),1);
        end
    end
end

%Create labels to be used for plotting frequencies 
for m=1: length(frequencies)
    cols{m} = ([num2str(frequencies(m)) ' Hz']); %#ok
end


% cols=  {'5'    '8.5'    '10.6'    '16.6'    '20.3'    '28.5'}
rows = {'backward at 12%' 'backward at 16%'}; %#ok

accuracies_means = mean(accuracies, 3);%#ok
accuracies_std = std(accuracies, 0, 3);%#ok
accuracies_sems = std(accuracies,0, 3) ./ sqrt(size(accuracies, 3));%#ok

for m=1: size(accuracies, 3)
    vector_accuracies = zscore(reshape(accuracies(:,:,m), length(frequencies) * length(all_contrasts), 1));
    accuracies_zscored(:,:,m) = reshape(vector_accuracies, length(all_contrasts), length(frequencies)); %#ok
%     accuracies_zscored(:,:,m) = zscore(accuracies(:,:,m)); %#ok
end
accuracies_means_zscored = mean(accuracies_zscored, 3);%#ok
accuracies_std_zscored = std(accuracies_zscored, 0, 3);%#ok
accuracies_sems_zscored = std(accuracies_zscored,0, 3) / sqrt(size(accuracies_zscored, 3));%#ok

% Variables that will be used for subjective responses' plot
meanProportion = mean(yesProportion,3); %#ok
proportion_sem = std(accuracies,0, 3) ./ sqrt(size(accuracies, 3)); % Will be used for the errorbar
meanProportion_sem_half = proportion_sem / 2; %#ok Will be used the horizontal error bar


%% Saving all variables to file
% What is different from the first (masking conditions) experiment:
% matrices ar now 2 x 6 x n (used to be 4 x 5 x n)
% variable 'timing_conditions' has been renamed to 'frequencies' because
% the data in column 5 of data matrix now signify the mask frequencies.

save([outDir fileName], 'accuracies', 'accuracies_means', 'accuracies_std', 'accuracies_sems', ...
    'accuracies_zscored', 'accuracies_means_zscored', 'accuracies_std_zscored', 'accuracies_sems_zscored', ...
    'rows', 'cols', 'frequencies', 'subjects', 'all_contrasts', 'yesProportion','meanProportion',...
    'proportion_sem','meanProportion_sem_half', '-append')

