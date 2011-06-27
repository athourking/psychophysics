function analyze_subjective(fileNameIn)
%fileNameIn is a string specifying the file(s) you wish to analyze
inDir = 'C:\Users\John.John-PC\Documents\MATLAB\CFS_Checkerboard\Data_Concat\';
subjectsToAnalyze = dir(([inDir fileNameIn]));

contrast = [0.04 0.12 0.16 0.24 0.64]; 
checkLocation = [1 2 3 4];
timing = {[39 49 59 69] [32 42 52 62] [36 46 56 66] [6 6 6 6]};

for k = 1:length(subjectsToAnalyze)
    yes_accuracy = zeros(length(timing),length(contrast));
    yes_proportion = zeros(length(timing),length(contrast));
    no_accuracy = zeros(length(timing),length(contrast));
    no_proportion = zeros(length(timing),length(contrast));
    
    load([inDir subjectsToAnalyze(k).name])
    i = 1;
    while i ~=length(timing)
    for i = 1:length(timing)
    for j = 1:length(contrast)
        %1st filter out the contrast and timing condition one after another
 dataFilter = allData(allData(:,3)==contrast(j) & allData(:,5) == i,:);
        %2nd find accuracy of location judgment when subject said 'I saw
        %the stimulus' AND when subject said 'I did not see the stimulus'
        yes_accuracy(i,j) = size(dataFilter(dataFilter(:,8)==3 & dataFilter(:,6)==dataFilter(:,7),:),1)...
            /size(dataFilter,1);
        yes_proportion(i,j) = size(dataFilter(dataFilter(:,8)==3 ,:),1)/size(dataFilter,1);
        no_accuracy(i,j) = size(dataFilter(dataFilter(:,8)==4 & dataFilter(:,6)==dataFilter(:,7),:),1)...
            /size(dataFilter,1);
        no_proportion(i,j) = size(dataFilter(dataFilter(:,8)==4 ,:),1)/size(dataFilter,1);       
    end
    end
    continue
    end
    
    markerColor = {'r','g','y','c','m'};
    markerStyle = {'s','^','o','d','v'};
    
    titlesYes = {'"YES" accuracy / Backward masking', '"YES" accuracy / Forward masking', '"YES" accuracy / Middle masking', '"YES" accuracy / Control condition'};
    titlesNo = {'"NO" accuracy / Backward masking', '"NO" accuracy / Forward masking', '"NO" accuracy / Middle masking', '"NO" accuracy / Control condition'};
    legends = {'25% accuracy', '4% contrast', '12% contrast','16% contrast','24% contrast','64% contrast'};
    
    %Plot location accuracy when subject said 'yes, I saw the stimulus'
    q = 1;
    while q ~=size(yes_accuracy,1)
    for q = 1:size(yes_accuracy,1) %timing conditions
        figure(q)
        set(gcf,'Position',[0 0 550 400]);
        title(titlesYes{q},'fontsize',14,'fontweight','b');
        set(gca,'fontSize',12);
        xlabel('Proportion of "yes" responses');
        ylabel('Proportion of correct when response was "yes"');
        hold on;
        plot([0 1],[0 1],'-k','LineWidth',2);
        s = 1;
        while s ~= size(yes_accuracy,2)
        for s = 1:size(yes_accuracy,2)
        plot(yes_proportion(q,s),yes_accuracy(q,s), markerStyle{s},...
            'MarkerSize',13, 'MarkerFaceColor', markerColor{s});
        text(yes_proportion(q,s),yes_accuracy(q,s),num2str(k));
        legend(gca, legends,'Location','northwest');
        text(0.6,0.1,'1,2...,n: subject number')
        end
        continue
        end
        hold off
    end
    continue
    end
    
        %Plot location accuracy when subject said 'no, I did not see the stimulus'
    for q = 1:size(no_accuracy,1) %timing conditions
        figure(q+4)
        set(gcf,'Position',[0 0 550 400]);
        title(titlesNo{q},'fontsize',14,'fontweight','b');
        set(gca,'fontSize',12);
        xlabel('Proportion of "no" responses');
        ylabel('Proportion of correct when response was "no"');
        hold on;
        plot([0 1],[0 0.25],'-k','LineWidth',2);
        r = 1;
        while r ~= size(yes_accuracy,2)
        for r = 1:size(yes_accuracy,2)
        plot(no_proportion(q,r),no_accuracy(q,r), markerStyle{r},...
            'MarkerSize',13, 'MarkerFaceColor', markerColor{r});
        text(no_proportion(q,r),no_accuracy(q,r),num2str(k));
        legend(gca, legends,'Location','northeast');
        text(0.05,0.9,'1,2...,n : subject number')
        axis([0 1 0 1]);
        end
        continue
        end
        hold off
    end
    
end

%% Below are some code leftovers, which I do not want to delete just yet.

%Nothing relevant, though.
%fileNameIn is a string specifying the file(s) you wish to analyze

%For 'yes' the expectation is 100% correct responses
%For 'no' the expectation is 25% correct responses
    
%Take one contrast value and one timing condition
%Look at 'yes' responses to see if location response and the acutal 
%location match
%Look at 'no' responses to see if location response and the location are different
%2 graphs, x: contrast, y: %correct, 3 data sets for 3 masking cond's

% Trial(count, 3) = contrast; % contrasts 0.04 0.12 0.16 0.24 0.64 0.96
% Trial(count, 5) = j; % code for the timing conditions back, fwd, mid, con
% Trial(count, 6) = k; % location of the checkerboard 1 2 3 4
% Trial(count, 7) = 0; %  responses for locations 1 2 3 4
% Trial(count, 8) = 0; %  responses for subjective visibility 3yes 4no

% dataFolders = ...
% {'C:\Users\John.John-PC\Documents\MATLAB\CFS_Checkerboard\Data_Raw\'...
% 'C:\Users\John.John-PC\Documents\MATLAB\CFS_Checkerboard\Data_Concat\'};
% for i = 1:length(dataFolders)
%     if exist(([dataFolders{i} fileNameIn]),'file')==2
%         load([dataFolders{i} fileNameIn]);
%         break
%     end
% end
% 
% if exist('Exp')
%     allData = Exp.Trial
% end
% 
% 
% 
% for i = 1:length(contrast)
%     for j = 1:length(timing)
%         %1st filter out the contrast and timing condition one after another
%  dataFilter = allData(allData(:,3)==contrast(i) & allData(:,5) == j,:);
%         %2nd find accuracy of location judgment when subject said 'I saw the stimulus'
%         %We expect close to 100% here
%  yes_accuracy(j,i) = size(dataFilter(dataFilter(:,8)==3 & dataFilter(:,6)==dataFilter(:,7),:),1)...
%      /size(dataFilter(dataFilter(:,8)==3,:),1);
%         %3rd find accuracy of location judgment when subject said 'I did not see the stimulus'
%         %We expect around 25% here (1/4 of responses accidentaly correct)
%  no_accuracy(j,i) = size(dataFilter(dataFilter(:,8)==4 & dataFilter(:,6)==dataFilter(:,7),:),1)...
%      /size(dataFilter(dataFilter(:,8)==4,:),1);
%         %What proportion of answers were 'yes' and 'no' for each condition&timing
%  yes_proportion(j,i) = size(dataFilter(dataFilter(:,8)==3,:),1)/size(dataFilter,1);
%  
%  no_proportion(j,i) = 1 - yes_proportion(j,i);
%  
%      end
% end
% 
% no_OverallAccu = no_proportion.*no_accuracy;
% yes_overallAccu = yes_proportion.*yes_accuracy;
% 
% 
% styleColorMarker = {'-rs','-g^','-bo','-cd'};
% 
% line_width = 1;
% marker_size = 8;
% marker_color = {'r','g','b','c'};
% 
% 
% for i = 1:size(yes_proportion,1)
%     figure()
%     set(gcf,'Position',[0 0 550 400]);
%     hold on;
%     plot([0 1],[0 1],'-k','LineWidth',2);
%     plot(yes_proportion(i,:),yes_overallAccu(i,:), styleColorMarker{i},...
%         'LineWidth',line_width,'MarkerSize',marker_size,'MarkerFaceColor',...
%         marker_color{i});
%     g = text(yes_proportion(i,:)+0.03,yes_overallAccu(q,:),{'4%','12%','16%','24%','64%'});
%     hold off
% end
% %Plotting: figure out how, because for low checkerboard contrasts 'yes' plots 
% %produce NaN %as there are no 'yes' answers to calculate % from. 
% %The same for 'no' answers at high contrasts.
% %Also: perhaps also the number of yes answers given should be included so
% %one knows how many yes answers there were from which % was calculated. 
% %Or rather: the fraction of yes answers at that timing/concentration.
% %So by looking at the 'yes' or 'no'graph one could see: for that timing 
% %at that contrast level the subject said 'yes', say, 80% of the time and
% %97% of the 'yes' responses gave the correct location judgment. 
% %Or - the subject said 'no' 70% of the time and 29% of 'no' responses gave
% %the correct location judgment.
% 
% condLabels= {'bacward' 'forward' 'middle' 'control'};
% 
% %'Yes' accuracy bar-graph
% figure()
% bar(contrast, yes_proportion','r');
% hold on
% bar(contrast, (yes_accuracy.*yes_proportion)');
% set(gca,'XTick', contrast);
% legend(condLabels,'Location','Best');
% 
% %'Yes' accuracy bar-graph
% figure
% bar(contrast, no_proportion');
% hold on
% bar(contrast, (no_accuracy.*no_proportion)', 'r');
% set(gca,'XTick', contrast);
% legend(condLabels,'Location','Best');
%     
% 
% 
% 
% 
% %plot(yes_accuracy)
% %   NaN   NaN     1     1     1     1
% %   NaN   NaN     1     1     1     1
% %   NaN     0   NaN     1     1     1
% 
% %plot(no_accuracy)
% % 0.1250    0.3750    0.1667    0.5000         0       NaN
% % 0.1250    0.1250         0    0.5000       NaN       NaN
% % 0.2500    0.4286    0.5000    0.5000       NaN       NaN










