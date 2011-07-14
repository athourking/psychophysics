function analyze_plotFreqAccuracies (fileName, inDir, outDir)
%This function is embedded in the script analyze_concatenateData. It
%uses the variables produced by analyze_Accuracy to draw plots.

% Load desired file
load ([inDir fileName])

%% 1. Single subject plots

types = {accuracies accuracies_zscored};
names = {'_Accuracy_Subject' '_Accuracy_zscored_Subject'};
ylimits = {[0 1] [-2.5 2.5]};

for type = 1 : length(types)

    for subj = 1 : size(types{type}, 3)
        figure();
        set(gcf,'Position',[0 0 600 300],'Color','w')
        set(gcf,'PaperPositionMode','auto')
        set(gcf,'InvertHardcopy','off')
        hold on

        markers = {'-kd' '-ks'};% '-ok' '-ks'}; 
        MarkerFaceColor = {'b' 'k'};% 'g' 'r'};
        markerSize = {8 7};
        %markerColor = {'k' 'k'};% 'k' 'k'};
     
        for cond =1 : size(types{type},1)
            plot(frequencies, types{type}(cond, : , subj), markers{cond},...
                'MarkerFaceColor', MarkerFaceColor{cond}, 'MarkerSize', markerSize{cond}); 
        end
        
        % Anotate the figure
        title(['Subject :  ' num2str(subjects(subj))], 'fontsize',14,'fontweight','b');
        ylabel('Accuracies', 'fontsize',12,'fontweight','b');
        xlabel('Frequencies', 'fontsize',12,'fontweight','b');
        set(gca,'XTick', frequencies,'XTickLabel',cols,'fontsize',8)
        legend(rows, 'Location', 'SouthWest')

        set(gca,'YLim', ylimits{type})
        print(gcf, '-djpeg', [outDir fileName names{type} num2str(subjects(subj))])

    end

end

%The above loops first plot an accuracy plot for each subject. Then a
%z-scored accuracy plot for each subject. So each subject gets 2 plots and
%the total number of plots is subject number x 2. E.g., 4 subjects->8 plots

%The loops below take the averages of all subjects and creates two plots:
%one with average accuracies, the other with average accuracies z-scored.
%% 2. Plot means across participants

types = {accuracies_means accuracies_means_zscored};
sems_types = {accuracies_sems accuracies_sems_zscored};
names = {'_Accuracy_All_Subjects' '_Accuracy_zscored_All_Subjects'};
ylimits = { [0 1] [-2.5 2.5]};

for type = 1 : length(types)
    
    figure();
    set(gcf,'Position',[0 0 600 300],'Color','w')
    set(gcf,'PaperPositionMode','auto')
    set(gcf,'InvertHardcopy','off')
    hold on

    markers = {'-kd' '-ks'};% '-ok' '-ks'};
    MarkerFaceColor = {'b' 'k'};% 'g' 'r'};
    markerSize = {8 7};
    %markerColor = {'k' 'k'};% 'k' 'k'};

    for cond =1 : size(accuracies_means,1)
        errorbar(frequencies, types{type}(cond, :), sems_types{type}(cond,:),...
        markers{cond}, 'MarkerFaceColor', MarkerFaceColor{cond}, 'MarkerSize', markerSize{cond}); 
    end


    % Anotate the figure
    title('All Subjects', 'fontsize',14,'fontweight','b');
    ylabel('Accuracies', 'fontsize',12,'fontweight','b');
    xlabel('Frequencies', 'fontsize',12,'fontweight','b');
    set(gca,'XTick', frequencies,'XTickLabel',cols,'fontsize',8)
    legend(rows, 'Location', 'SouthWest')
    set(gca,'YLim', ylimits{type})
    print(gcf, '-djpeg', [outDir fileName names{type}])

end

%% 3. Plot mean subjective response accuracy vs. actual accuracy 

figure()
hold on
line([0 1],[0.25 1],'color','k'); % linear trend expected    

%shapes for frequencies
shapes = {'o' 'v' 's' '^' 'd' 'p'};
%color for contrast
MarkerFaceColor = {'b' 'k'};% 'g' 'r'};
markerSize = 8;


for contr = 1:size(accuracies_means,1)
    for frq = 1:size(accuracies_means,2)
        
        % plot the markers with the y errorbars
        plotHandle(contr,frq) = errorbar(meanProportion(contr, frq),accuracies_means(contr,frq),...
            accuracies_sems(contr,frq), [MarkerFaceColor{contr} shapes{frq}], ...
            'MarkerFaceColor', MarkerFaceColor{contr}, 'MarkerSize', markerSize); %#ok
        % x error bars
        herrorbar(meanProportion(contr,frq), accuracies_means(contr,frq), ...
            meanProportion_sem_half(contr,frq), meanProportion_sem_half(contr,frq),...
            [MarkerFaceColor{contr} shapes{frq}]);
        
    end
end

title('Accuracy as a function of visibility','fontsize',14)
xlabel('Visibility','fontsize',12)
ylabel('Accuracies','fontsize',12)
legend(plotHandle(1,:), cols, 'Location','SouthEast');
set(gca,'Xlim', [0 1])
print(gcf, '-djpeg', [outDir fileName '_subjective'])

close all
