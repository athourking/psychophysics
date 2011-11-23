function data = analyze_freqAccuracy (Data)
%This function is embedded in the script analyze_concatenateData. It takes
%the data of the subjects that have been concatenated into a single matrix
%(either all subjects or the ones filtered out in that function) called 
%Data and appends a number of new variables. See the bottom of this
%function to see which ones. 'Data' - the matrix, 'fileName' - how to save it,
%outDir - where to save it. analyze_Accuracy puts it back into the same
%folder, with the same name as the file of the concatenated data matrix.
%% Conditions :
% (1) subject number ; (2) Block number; (3) contrast value ; (4) timing of checkerboard;
% (5) mask frequencies; (6) location of the checkerboard
% (7) responses for locations ; (8) responses for subjective visibility

data.all_contrasts = unique(Data(:,3));
data.frequencies = unique(Data(:,5));
data.subjects = unique(Data(:,1));

data.accuracies =  zeros(length(data.all_contrasts), length(data.frequencies), length(data.subjects)); % 5 x 3 x subjects
data.yesProportion =  zeros(length(data.all_contrasts), length(data.frequencies), length(data.subjects));

for su = 1: length(data.subjects)
    for con = 1: length(data.all_contrasts)
        for freq = 1: length(data.frequencies)
            % row:contrast, col:frequency, layer:subject; filtering subject,contrast, frequency AND when location 
            % is equal to location response, dividing the whole with the number of trials for this subject for this 
            % contrast and frequency
            data.accuracies(con, freq, su) = size(Data(Data(:,1) == data.subjects(su) & Data(:,3)== data.all_contrasts(con) & Data(:,5)== data.frequencies(freq)...
                & Data(:,6) == Data(:,7),:), 1)  ...
                / size(Data(Data(:,1) == data.subjects(su) & Data(:,3)== data.all_contrasts(con) & Data(:,5)== data.frequencies(freq)),1);
            % positions identical; filtering subject, contrast, frequency and when subject said 'yes', dividing the whole 
            % with the number of trials trials for this subject for this contrast and frequency
            data.yesProportion(con, freq, su) = ...
                size( Data(Data(:,8) == 3 & Data(:,1) == data.subjects(su) & Data(:,3)== data.all_contrasts(con) & Data(:,5)== data.frequencies(freq),:),1)...
                / size( Data(Data(:,1) == data.subjects(su) & Data(:,3)== data.all_contrasts(con) & Data(:,5)== data.frequencies(freq)),1);
        end
    end
end

%Create labels to be used for plotting frequencies (used for x axis) 
for m= 1: length(data.frequencies)
    data.cols{m} = ([num2str(data.frequencies(m)) ' Hz']); 
end

%Create labels to be used for plotting contrasts (used for the legend)
for n= 1: length(data.all_contrasts)
    data.rows{n}= (['backward at ' num2str(data.all_contrasts(n)*100) '%']);
end

data.accuracies_means = mean(data.accuracies, 3);
data.accuracies_std = std(data.accuracies, 0, 3);
data.accuracies_sems = std(data.accuracies,0, 3) ./ sqrt(size(data.accuracies, 3));

for m=1: size(data.accuracies, 3)
    vector_accuracies = zscore(reshape(data.accuracies(:,:,m), length(data.frequencies) * length(data.all_contrasts), 1));
    data.accuracies_zscored(:,:,m) = reshape(vector_accuracies, length(data.all_contrasts), length(data.frequencies)); 
%     data.accuracies_zscored(:,:,m) = zscore(data.accuracies(:,:,m)); 
end
data.accuracies_means_zscored = mean(data.accuracies_zscored, 3);
data.accuracies_std_zscored = std(data.accuracies_zscored, 0, 3);
data.accuracies_sems_zscored = std(data.accuracies_zscored,0, 3) / sqrt(size(data.accuracies_zscored, 3));

% Variables that will be used for subjective responses' plot
data.meanProportion = mean(data.yesProportion,3); %
data.proportion_sem = std(data.accuracies,0, 3) ./ sqrt(size(data.accuracies, 3)); % Will be used for the errorbar
data.meanProportion_sem_half = data.proportion_sem / 2; % Will be used the horizontal error bar


%% Saving all variables to file
% What is different from the first (masking conditions) experiment:
% matrices ar now 2 x 6 x n (used to be 4 x 5 x n)
% variable 'timing_conditions' has been renamed to 'frequencies' because
% the data in column 5 of data matrix now signify the mask frequencies.

%save([locVars.resultsDir.fileName], 'data', '-append');
% saved outside, therefore, this function does not need locVars as input
