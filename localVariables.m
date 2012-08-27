function locVars = localVariables
%% Enable the cell, which corresponds to the experiment you want to analyze

%% MASKING CONDITIONS EXPERIMENT. Variables used by analyze_maskingExp and functions embedded there
% % Locally static variables
% locVars.rawDataDir = 'C:\Users\John.John-PC\Documents\MATLAB\CFS_Checkerboard\Data_Mask_Raw\'; % Where individual blocks' files are stored. Used in analyze_concatenateData
% locVars.resultsDir = 'C:\Users\John.John-PC\Documents\MATLAB\CFS_Checkerboard\Data_Mask_Concat\'; % Where the concatenated+analyzed .mat files are stored. Used in analyze_concatenateData, analyze_freqAccuracy, analyze_plotFreqAccuracy
% locVars.figsDir = 'C:\Users\John.John-PC\Documents\MATLAB\CFS_Checkerboard\Data_Mask_Figures\'; % Where plots .jpeg are stored. Used in analyze_plotFreqAccuracies
% 
% % Locally changing variables
% locVars.fileNamesIn = 'S*.mat'; % FROM WHICH raw data FILES to CONCATENATE the CHOSEN SUBJECTS data matrix; Used in analyze_concatenateData 
% locVars.expName = 'maskExpFinal'; % What ALL the analysis and plots' FILE NAMES WILL START WITH. Automatically added are subject numbers, 'accuracy', and 'zscored'
% locVars.subjFilter = [1:12]; %1, 2,..N. WHICH SUBJECTS to CONCATENATE and ANALYZE; produces BOTH INDIVIDUAL and GROUP analysis files
% locVars.whichPlot = [1:3]; % 1, 2, 3. WHICH PLOTS to draw; 1: indv accuracies (+z); 2: group means (+z); 3 subjective accuracies

%% MASKING FREQUENCIES EXPERIMENT. Variables used by analyze_frequenciesExp and functions embedded there
% Locally static variables
locVars.rawDataDir ='/home/lisandro/Work/Project_CFS/CFS_Checkerboard/Data/FInal_Subjects_Frequency/'; % Where individual blocks' files are stored. Used in analyze_concatenateData
locVars.resultsDir = '/home/lisandro/Work/Project_CFS/CFS_Checkerboard/Data_results/'; % Where the concatenated+analyzed .mat files are stored. Used in analyze_concatenateData, analyze_freqAccuracy, analyze_plotFreqAccuracy
locVars.figsDir = '/home/lisandro/Work/Project_CFS/CFS_Checkerboard/Figures/Final_Subjects_Frequency/'; % Where plots .jpeg are stored. Used in analyze_plotFreqAccuracies

% Locally changing variables
locVars.fileNamesIn = 'Sfb*.mat'; % FROM WHICH raw data FILES to CONCATENATE the CHOSEN SUBJECTS data matrix; Used in analyze_concatenateData
locVars.expName = 'freqExp'; % What ALL the analysis and plots' FILE NAMES WILL START WITH. Automatically added are subject numbers, 'accuracy', and 'zcored'
locVars.subjFilter = [1 2 3 4 5 6 7 8 9 10 11 12]; %1, 2,..N. WHICH SUBJECTS to CONCATENATE and ANALYZE; produces BOTH INDIVIDUAL and GROUP analysis files
locVars.whichPlot = [1 2 3]; % 1, 2, 3.  WHICH PLOTS to draw; 1: indv accuracies (+z); 2: group means (+z); 3 subjective accuracies


