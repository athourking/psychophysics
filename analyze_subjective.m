function analyze_subjective(fileNameIn)
%fileNameIn is a string specifying the file(s) you wish to analyze. It goes
%through each file. This function treats each file as representing one
%subject. It outputs a grand total of 8 accuracy plots: ye/no responses X
%4 masking conditions.
%fileNameIn = 'Data_final'; 
inDir = 'C:\Users\John.John-PC\Documents\MATLAB\CFS_Checkerboard\Data_Concat\';
subjectsToAnalyze = dir(([inDir fileNameIn]));

contrast = [0.04 0.12 0.16 0.24 0.64]; 
checkLocation = [1 2 3 4];
timing = {[39 49 59 69] [32 42 52 62] [36 46 56 66] [6 6 6 6]};

for k = 1:length(subjectsToAnalyze)
    yes_accuracy = zeros(length(timing),length(contrast));
    yes_proportion = zeros(length(timing),length(contrast));
        
    load([inDir subjectsToAnalyze(k).name])
    i = 1;
    while i ~=length(timing)
    for i = 1:length(timing)
    for j = 1:length(contrast)
        %1st filter out the contrast and timing condition one after another
 dataFilter = allData(allData(:,3)==contrast(j) & allData(:,5) == i,:);
        %2nd find accuracy of location judgment when subject said 'I saw
        %the stimulus' AND when subject said 'I did not see the stimulus'
        yes_accuracy(i,j) = size(dataFilter(dataFilter(:,6)==dataFilter(:,7),:),1)/size(dataFilter,1);
        yes_proportion(i,j) = size(dataFilter(dataFilter(:,8)==3 ,:),1)/size(dataFilter,1);
    end
    end
    continue
    end
    
    markerColor = {'r','g','y','c','m'};
    markerStyle = {'s','^','o','d','v'};
    
    titlesYes = {'Backward masking', 'Forward masking', 'Middle masking', 'Control condition'};
    legends = {'4% contrast', '12% contrast','16% contrast','24% contrast','64% contrast'};
    
    %Plot location accuracy when subject said 'yes, I saw the stimulus'
    q = 1;
    while q ~=size(yes_accuracy,1)
    for q = 1:size(yes_accuracy,1) %timing conditions
        figure(q)
        set(gcf,'Position',[0 0 550 400]);
        title(titlesYes{q},'fontsize',14,'fontweight','b');
        set(gca,'fontSize',12);
        xlabel('Proportion of "yes" responses');
        ylabel('Proportion of correct responses');
        hold on;
        plot([0 1],[0.25 1],'-k','LineWidth',2);
        s = 1;
        while s ~= size(yes_accuracy,2)
        for s = 1:size(yes_accuracy,2)
        plot(yes_proportion(q,s),yes_accuracy(q,s), markerStyle{s},...
            'MarkerSize',13, 'MarkerFaceColor', markerColor{s});
        text(yes_proportion(q,s),yes_accuracy(q,s),num2str(allData(1,1)));
        legend(gca, (['Expected?' legends]),'Location','northwest');
        text(0.6,0.1,'1,2...,n: subject number')
        end
        continue
        end
        hold off
    end
    continue
    end
        
end