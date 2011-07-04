function analyze_concatenateData

% Concatenate all single subjects into one Matrix. This is done ONCE in the beginning.
% After this is done we can filter the data for sub-groups of subjects and plot results

rawDataDir = '/home/lisandro/Work/Project_CFS/CFS_Checkerboard/Data/Final_Subjects/';
resultsDir = '/home/lisandro/Work/Project_CFS/CFS_Checkerboard/Data_results/';

fileName = 'Data_final'; % DEFINE THE NAME TO SAVE THE FILE
files = dir([rawDataDir 'S*.mat']);
displayFiles (files)

Data = [];
for fi = 1: length(files)
    load ( [rawDataDir files(fi).name] )
    Data = cat(1,Data, Exp.Trial);
    clear Exp
end

save([resultsDir fileName], 'Data')


%% Analyze accuracy: Filter subjects here if needed

resultsDir = '/home/lisandro/Work/Project_CFS/CFS_Checkerboard/Data_results/';
figsDir = '/home/lisandro/Work/Project_CFS/CFS_Checkerboard/Figures/';
load ([resultsDir 'Data_final']); % Load the main file
% Filter subjects
subjects = []; % vector of subjects to analyse
fileName = 'Subjects';
if ~isempty(subjects)
    Data = Data( ismember(Data(:,1), subjects), :);
end

analyze_Accuracy (Data, fileName, resultsDir, resultsDir)

%% Plot Results

analyze_plotAccuracies (fileName, resultsDir, figsDir)


