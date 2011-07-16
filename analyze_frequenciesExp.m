function analyze_frequenciesExp

%% CONCATENATE and SAVE
% Load local variables
locVars = localVariables;
% Load the raw data files to be concatenated
files = dir([locVars.rawDataDir locVars.fileNamesIn]); 
displayFiles (files);

% Concatenate files and save
Data = [];
for fi = 1: length(files)
    load ( [locVars.rawDataDir files(fi).name] );
    Data = cat(1,Data, Exp.Trial);
    clear Exp
end
numOfSubjects = num2str(length(unique(Data(:,1)))); %The number of subjects concatenated goes into the file name
save([locVars.resultsDir 'freqExp_all_' numOfSubjects 'subjects'], 'Data'); 

% If you wish to continue straight on with the analysis of the just-concatenated 
% file, you do not need to go enter this file name in local variables
nameOfConcatFile= (['freqExp_all_' numOfSubjects 'subjects']);

%% FILTER(if specified) and ANALYZE 
locVars = localVariables;
if exist('nameOfConcatFile','var')
    locVars.fileName = nameOfConcatFile;
end
load ([locVars.resultsDir locVars.fileName]); % Load the main file

if ~isempty(locVars.subjFilter)
    locVars.fileName = ([locVars.fileName num2str(locVars.subjFilter)]);
    Data = Data( ismember(Data(:,1), locVars.subjFilter),:);
    if ~isempty(locVars.blockFilter)
    Data = Data( ismember(Data(:,2), locVars.blockFilter),:); 
    end
    %Data = Data( ismember(Data(:,1), subjects), :)
    if isempty(locVars.blockFilter)
        locVars.blockFilter = 'allBlocks';
    end
    save([locVars.resultsDir 'subjectNum_' num2str(locVars.subjFilter) '_blockNum_' num2str(locVars.blockFilter)], 'Data');
end

% locVars = localVariables;
% locVars.fileName = ([locVars.resultsDir 'subjectNum_' num2str(locVars.subjFilter) '_blockNum_' num2str(locVars.blockFilter)]);
% load ([locVars.resultsDir locVars.fileName]);
analyze_freqAccuracy (Data, locVars) 

%% Plot single subjects accuracies, means, and subjective response accuracies
locVars = localVariables;
if exist('nameOfConcatFile','var')
    locVars.fileName = nameOfConcatFile;
end
load ([locVars.resultsDir locVars.fileName]);
analyze_plotfreqAccuracies (data, locVars)
