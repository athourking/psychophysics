function analyze_frequenciesExp 
%% --INFO START--
%Specify in localVariables what you wish to do before coming here!

% If you have a set of raw data files and you wish to concatenate,
% analyze, plot, and filter(optional) in one go, specify the raw data files
% in locVars.fileNamesIn and come run this function. It will do it all.

% If you already have a concatenated data file, specify, which one it is in
% locVars.fileName and then come execute the cells you're interested in:
% analyze, plot, or filter (filter is still work in progress).

% 'Can't get there from here' warning: you cannot go from 'concatenate' to
% 'plot' without executing also the 'analyze' cell. Else, there will be
% nothing to plot.
%   --INFO END--
%% CONCATENATE (only selected subjects, IF SPECIFIED) and SAVE
locVars = localVariables; % Load local variables
files = dir([locVars.rawDataDir locVars.fileNamesIn]); % Load the raw data files to be concatenated
[subjectNums Data] = analyze_concatenateData (files, locVars); % The concatenate function
save([locVars.resultsDir 'freqExp_allSubjects_' subjectNums], 'Data'); 

% If you wish to continue straight on with the analysis of the just-concatenated 
% file, you do not need to go to localVariables to enter the the file name
% in locVars.fileName. The cells below will take it from here: 
nameOfConcatFile= (['freqExp_allSubjects_' subjectNums]);

%% ANALYZE to APPEND number of ACCURACY measures AND SAVE (under the same name)
locVars = localVariables;
if exist('nameOfConcatFile','var') % This kicks in if and only if you've executed 'concatenate' cell just before
    locVars.fileName = nameOfConcatFile;
end

load ([locVars.resultsDir locVars.fileName]); % Load the main file
data = analyze_freqAccuracy (Data, locVars); % The data analysis function 
save([locVars.resultsDir locVars.fileName], 'data', '-append');

%% PLOT ALL single subjects (also z-scored), means (also z-scored), and subjective accuracies AND SAVE plot images
locVars = localVariables;
if exist('nameOfConcatFile','var') % This kicks in iff you've executed 'concatenate' cell just before 
    locVars.fileName = nameOfConcatFile;
end

load ([locVars.resultsDir locVars.fileName]);
analyze_plotfreqAccuracies (data, locVars) % The plotting function
% save: plots saved inside the plot function, not here

%% PLOT SPECIFIED SUBJECTS AS ONE GROUP
locVars = localVariables;
if exist('nameOfConcatFile','var') % This kicks in iff you've executed 'concatenate' cell just before
    locVars.fileName = nameOfConcatFile;
end

load ([locVars.resultsDir locVars.fileName]);
analyze_freqSubjectFilter (Data, locVars) %the initial concatenated data matrix, and local variables

