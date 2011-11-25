function data = analyze_maskAccuracy (Data)
%This function is embedded in the script analyze_concatenateData. It takes
%the data of the subjects that have been concatenated into a single matrix
%(either all subjects or the ones filtered out in that function) called 
%Data and appends a number of new variables. See the bottom of this
%function to see which ones. 'Data' - the matrix, 'fileName' - how to save it,
%outDir - where to save it. analyze_Accuracy puts it back into the same
%folder, with the same name as the file of the concatenated data matrix.
%% Conditions :
% (1) subject number ; (2) Block number; (3) contrast value ; (4) timing
% conditions ; (5) code for the timing conditions ; (6) location of the checkerboard
% (7) responses for locations ; (8) responses for subjective visibility


% Filter the less than 5 masks condition
Data = Data(Data(:,4) < 10 | Data(:,4) > 40, :); %Some data was like that.

%  timingConds = { 'backwardMasking' 'forwardMasking' 'middleMasking'}; %
%  1, 2, 3
data.timing_conditions = unique(Data(:,5)); % -In Exp.2 these are mask timing codes (i.e., frequency)
data.all_contrasts = unique(Data(:,3)); % -In Exp.2 these are also contrasts
data.subjects = unique(Data(:,1));  

data.accuracies =  zeros(length(data.timing_conditions), length(data.all_contrasts), length(data.subjects)); 
data.yesProportion =  zeros(length(data.timing_conditions), length(data.all_contrasts), length(data.subjects));

for subj = 1: length(data.subjects)
    for cond =1 : length(data.timing_conditions)
        for contrast =1 :length(data.all_contrasts)
            
            % Filter subjects
            aux_data = Data( Data(:,1) == data.subjects(subj) & Data(:,5) == data.timing_conditions(cond)...
                & Data(:,3)== data.all_contrasts(contrast), :) ; 
            % just a sanity check
%             if size(aux_data, 1) ~= 48 %|| size(aux_data, 1) ~= 36 
%                 display ('ERROR IN THE NUMBER OF TRIALS')
%                 return
%             end
            
            correct = size( aux_data( aux_data(:,6) == aux_data(:,7), :), 1) / size(aux_data, 1);            
            data.accuracies(cond, contrast, subj) = correct;
            data.yesProportion(cond,contrast,subj) = size(aux_data(aux_data(:,8) == 3 ,:),1) / size(aux_data,1);
        end
    end
end

for m=1: length(data.all_contrasts)
    data.cols{m} = ([num2str(data.all_contrasts(m)*100) '%']); % Used for x axis
end

% data.cols= {'0.04' '0.04' '0.08' '0.16' '0.32' '0.64' '0.96'};
data.rows = {'backward' 'forward' 'middle' 'start'}; % Used for the legend

data.accuracies_means = mean(data.accuracies, 3);
data.accuracies_std = std(data.accuracies, 0, 3);
data.accuracies_sems = std(data.accuracies,0, 3) ./ sqrt(size(data.accuracies, 3));

for m=1: size(data.accuracies, 3)
    vector_accuracies = zscore(reshape(data.accuracies(:,:,m), length(data.timing_conditions) * length(data.all_contrasts), 1));
    data.accuracies_zscored(:,:,m) = reshape(vector_accuracies, length(data.timing_conditions), length(data.all_contrasts)); 
%     data.accuracies_zscored(:,:,m) = zscore(data.accuracies(:,:,m)); %#ok
end
data.accuracies_means_zscored = mean(data.accuracies_zscored, 3);
data.accuracies_std_zscored = std(data.accuracies_zscored, 0, 3);
data.accuracies_sems_zscored = std(data.accuracies_zscored,0, 3) / sqrt(size(data.accuracies_zscored, 3));

% Variables that will be used for subjective responses' plot
data.meanProportion = mean(data.yesProportion,3);
data.proportion_sem = std(data.accuracies,0, 3) ./ sqrt(size(data.accuracies, 3)); %This for the errorbar
data.meanProportion_sem_half = data.proportion_sem / 2; %This for the horizontal error bar


%% Saving all variables to file
% save([locVars.resultsDir locVars.fileName], 'data', '-append');
% Saving is done outside, in analyze_maskExp.
