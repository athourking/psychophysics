function analyze_concatenateData

% Concatenate all single subjects into one Matrix. This is done ONCE in the beginning.
% After this is done we can filter the data for sub-groups of subjects and plot results

%% This will load the directory and file names needed to execute this function

[rawDataDir resultsDir figsDir fileName] = directories;

%%

files = dir([rawDataDir 'S*.mat']);
displayFiles (files);

Data = [];
for fi = 1: length(files)
    load ( [rawDataDir files(fi).name] );
    Data = cat(1,Data, Exp.Trial);
    clear Exp
end

save([resultsDir fileName], 'Data'); %this will save the matrix with name Data_final in folder Data_concat
dlmwrite([resultsDir fileName '.txt'], Data, 'delimiter', '\t', 'precision', 8);

%% Analyze accuracy: Filter subjects here if needed
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

analyze_Accuracy (Data, fileName, resultsDir)
%Data - the matrix, fileName - how to save it, resultsDir - the inDir,
%resulsDir - the outDir (here the same as the inDir).
%This takes the Data and the other variables from above
%and appends more variables to be plotted by analyze_plotAccuracies
%(below).

%% Plot Results

analyze_plotAccuracies (fileName, resultsDir, figsDir) %


