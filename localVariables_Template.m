function locVars = localVariables_Template
%% Enable the cell, which corresponds to the experiment you want to analyze

%% MASKING CONDITIONS EXPERIMENT. Variables used by analyze_maskingExp and functions embedded there
% % Locally static variables
% locVars.rawDataDir = ''; % Where individual blocks' files are stored. Used in analyze_concatenateData
% locVars.resultsDir = ''; % Where the concatenated+analyzed .mat files are stored. Used in analyze_concatenateData, analyze_freqAccuracy, analyze_plotFreqAccuracy
% locVars.figsDir = ''; % Where plots .jpeg are stored. Used in analyze_plotFreqAccuracies
% 
% % Locally changing variables
% locVars.fileNamesIn = ''; % FROM WHICH raw data FILES to CONCATENATE the CHOSEN SUBJECTS data matrix; Used in analyze_concatenateData 
% locVars.expName = ''; % What ALL the analysis and plots' FILE NAMES WILL START WITH. Automatically added are subject numbers, 'accuracy', and 'zscored'
% locVars.subjFilter = []; %1, 2,..N. WHICH SUBJECTS to CONCATENATE and ANALYZE; produces BOTH INDIVIDUAL and GROUP analysis files
% locVars.whichPlot = []; % 1, 2, 3. WHICH PLOTS to draw; 1: indv accuracies (+z); 2: group means (+z); 3 subjective accuracies

%% MASKING FREQUENCIES EXPERIMENT. Variables used by analyze_frequenciesExp and functions embedded there
% Locally static variables
locVars.rawDataDir =''; % Where individual blocks' files are stored. Used in analyze_concatenateData
locVars.resultsDir = ''; % Where the concatenated+analyzed .mat files are stored. Used in analyze_concatenateData, analyze_freqAccuracy, analyze_plotFreqAccuracy
locVars.figsDir = ''; % Where plots .jpeg are stored. Used in analyze_plotFreqAccuracies

% Locally changing variables
locVars.fileNamesIn = ''; % FROM WHICH raw data FILES to CONCATENATE the CHOSEN SUBJECTS data matrix; Used in analyze_concatenateData
locVars.expName = ''; % What ALL the analysis and plots' FILE NAMES WILL START WITH. Automatically added are subject numbers, 'accuracy', and 'zcored'
locVars.subjFilter = []; %1, 2,..N. WHICH SUBJECTS to CONCATENATE and ANALYZE; produces BOTH INDIVIDUAL and GROUP analysis files
locVars.whichPlot = []; % 1, 2, 3.  WHICH PLOTS to draw; 1: indv accuracies (+z); 2: group means (+z); 3 subjective accuracies
