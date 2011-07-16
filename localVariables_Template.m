function locVars = localVariables_Template
whichExp = 1;  % MASKING CONDITIONS: 1   FREQUENCIES: 2
%% 
if whichExp == 1
%% Masking conditions experiment. Variables used by analyze_maskingExp and functions embedded there
% Locally static variables
locVars.rawDataDir = ''; % Used in analyze_concatenateData
locVars.resultsDir = ''; % Used in analyze_concatenateData, analyze_freqAccuracy, analyze_plotFreqAccuracy
locVars.figsDir = ''; %Used in analyze_plotFreqAccuracies

% Locally changing variables
locVars.fileNamesIn = ''; % JUST CONCATENATE all the specified raw data files into one data matrix; Used in analyze_concatenateData
locVars.fileName = ''; % WHICH already-concatenated data FILE TO ANALYZE. EMPTY IF you concatenate, analyze, and plot in one go. (No need to load a file for analysis or plotting because the function will just carry straight on with the concatenated file just generated) 
locVars.subjFilter = []; % Specify SUBJECT NUMBERS to be selected for analysis. Used in analyze_Exp 'Filter' cell
locVars.blockFilter = []; %Indicate WHICH SINGLE SUBJECT BLOCKS, OR leave EMPTY IF ALL. Used in analyze_Exp 'Filter' cell
%%
elseif whichExp == 2
%% Masking frequencies experiment. Variables used by analyze_frequenciesExp and functions embedded there
% Locally static variables
locVars.rawDataDir =''; %Used in analyze_concatenateData
locVars.resultsDir = ''; %Used in analyze_concatenateData, analyze_freqAccuracy, analyze_plotFreqAccuracy
locVars.figsDir = ''; %Used in analyze_plotFreqAccuracies

% Locally changing variables
locVars.fileNamesIn = ''; % JUST CONCATENATE all the specified raw data files into one data matrix; Used in analyze_concatenateData
locVars.fileName = ''; % WHICH already-concatenated data FILE TO ANALYZE. EMPTY IF you concatenate, analyze, and plot in one go. (No need to load a file for analysis or plotting because the function will just carry straight on with the concatenated file just generated) 
locVars.subjFilter = []; % Specify SUBJECT NUMBERS to be selected for analysis. Used in analyze_Exp 'Filter' cell
locVars.blockFilter = []; % %Indicate WHICH SINGLE SUBJECT BLOCKS, OR leave EMPTY IF ALL. Used in analyze_Exp 'Filter' cell
end