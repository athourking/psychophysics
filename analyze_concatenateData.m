function [subjectNums Data] = analyze_concatenateData (files, locVars)
% Concatenate all single subjects into one Matrix. This is done ONCE at the beginning.
% After this is done we can filter the data for sub-groups of subjects and plot results
%% Concatenate files
Data = [];
for fi = 1: length(files)
    load ( [locVars.rawDataDir files(fi).name] );
    if ismember (Exp.Trial(1,1), locVars.subjFilter)
        Data = cat(1,Data, Exp.Trial);
    end
    clear Exp
end
subjectNums = num2str(unique(Data(:,1)')); %Subject numbers will go into the concatenated data file name
