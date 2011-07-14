function analyze_concatenateData
% Concatenate all single subjects into one Matrix. This is done ONCE in the beginning.
% After this is done we can filter the data for sub-groups of subjects and plot results

%% This will load the directory and file names needed to execute this function

[rawDataDir resultsDir figsDir inDir fileName] = directories;

%% Pick the experiment
files = dir([rawDataDir 'F*.mat']); %specify here which files to concatenate
displayFiles (files);

%% Concatenate files and save
Data = [];
for fi = 1: length(files)
    load ( [rawDataDir files(fi).name] );
    Data = cat(1,Data, Exp.Trial);
    clear Exp
end

save([resultsDir fileName], 'Data'); %this will save the matrix with name 'fileName' in folder Data_concat
%dlmwrite([concatDataDir fileName '.txt'], Data, 'delimiter', '\t',
%'precision', 8); % This saves the matrix in a txt file

%% Filter subjects here if needed
%All the subjects' data have been concatenated above. Here, by entering
%subject numbers in subjects = [], you can specify which subjects will be
%retained in the variable 'Data' for furher analysis. If you do not enter
%anything, the functions analyze_Accuracy and analyze_plotAccuracies will
%be applied to the entire matrix, i.e., all the subjects.

load ([resultsDir fileName]); % Load the main file
% Filter subjects
subjects = []; % vector of subjects to analyse
%fileName = 'Subject';
if ~isempty(subjects)
    fileName = (['Subject' num2str(subjects)]);
    Data = Data( ismember(Data(:,1), subjects), :);
end

%% Analyze accuracies and plot for first (masking conditions) experiment 

%analyze_Accuracy (Data, fileName, resultsDir) %<-----

%Data - the matrix, fileName - how to save it, concatDataDir - where the 
% file will go - the same place it came from, just with more accuracy 
% measures appended to the file. They will be plotted by analyze_plotAccuracies
%(below).

% Plot single subjects accuracies, means, and subjective response accuracies

%analyze_plotAccuracies (fileName, resultsDir, figsDir) %<-----

%% Analyze accuracies and plot for second (mask frequencies)experiment 

% Data = Data( Data(:,4) < 111, :); % to play with the timing condition
% Similar to the first experiment, this function appends a number of
% variables to the file containing the data matrix.
analyze_FreqAccuracy (Data, fileName, resultsDir)

% This function creates accuracies, mean accuracies, subjective response accuracies
analyze_plotFreqAccuracies (fileName, resultsDir, figsDir) 




