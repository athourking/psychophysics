function analyze_concatenateData
% Concatenate all single subjects into one Matrix. This is done ONCE at the beginning.
% After this is done we can filter the data for sub-groups of subjects and plot results

%% This will load the directory and file names needed to execute this function
locVars = localVariables;

%% Load the chosen raw data files 
files = dir([locVars.rawDataDir locVars.fileNameIn]); 
displayFiles (files);

%% Concatenate files and save
Data = [];
for fi = 1: length(files)
    load ( [locVars.rawDataDir files(fi).name] );
    Data = cat(1,Data, Exp.Trial);
    clear Exp
end
numOfSubjects = num2str(length(unique(Data(:,1)))); %This will tell you how many subjects' data have been concatenated
save([locVars.resultsDir 'all_' numOfSubjects 'subjects'], 'Data'); 
end