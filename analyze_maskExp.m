function analyze_maskExp
%% Load local variables
locVars = localVariables;
%% Load files
files = dir([locVars.rawDataDir locVars.fileNamesIn]); 
%% Concatenate raw data of specified subjects, analyze as group, save to one file.
[subjectNums Data] = analyze_concatenateData (files, locVars);
data = analyze_Accuracy (Data);
save([locVars.resultsDir locVars.expName '_Subjects_' subjectNums], 'Data', 'data');
%% Analyze all specified subjects individually, save to individual files.
for subj = 1: length(locVars.subjFilter)
    singleSubjMx = Data( ismember (Data(:,1) == locVars.subjFilter(subj), Data),:);
    data = analyze_Accuracy(singleSubjMx);
    nameToSave = (['_singleSubject_' num2str(locVars.subjFilter(subj))]);
    save([locVars.resultsDir  locVars.expName nameToSave], 'singleSubjMx', 'data');
end
%% Plot the specified subjects individually and as as a group, save all plots.
fileName = ([locVars.expName '_Subjects_' num2str(unique(locVars.subjFilter))]);
load ([locVars.resultsDir fileName]);
analyze_plotAccuracies (fileName, data, locVars)