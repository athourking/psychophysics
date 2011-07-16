function analyze_plotFreqAccuracies (data, locVars)
%This function is embedded in the script analyze_concatenateData. It
%uses the variables produced by analyze_Accuracy to draw plots.

%% 1. Single subject plots

types = {data.accuracies data.accuracies_zscored};
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
            plot(data.frequencies, types{type}(cond, : , subj), markers{cond},...
                'MarkerFaceColor', MarkerFaceColor{cond}, 'MarkerSize', markerSize{cond}); 
        end
        
        % Anotate the figure
        title(['Subject :  ' num2str(data.subjects(subj))], 'fontsize',14,'fontweight','b');
        ylabel('Accuracy', 'fontsize',12,'fontweight','b');
        xlabel('Frequencies', 'fontsize',12,'fontweight','b');
        set(gca,'XTick', data.frequencies,'XTickLabel',data.cols,'fontsize',8)
        legend(data.rows, 'Location', 'SouthWest')

        set(gca,'YLim', ylimits{type})
        print(gcf, '-djpeg', [locVars.figsDir locVars.fileName names{type} num2str(data.subjects(subj))])

    end

end

%The above loops first plot an accuracy plot for each subject. Then a
%z-scored accuracy plot for each subject. So each subject gets 2 plots and
%the total number of plots is subject number x 2. E.g., 4 subjects->8 plots

%The loops below take the averages of all subjects and creates two plots:
%one with average accuracies, the other with average accuracies z-scored.
%% 2. Plot means across participants

types = {data.accuracies_means data.accuracies_means_zscored};
sems_types = {data.accuracies_sems data.accuracies_sems_zscored};
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

    for cond =1 : size(data.accuracies_means,1)
        errorbar(data.frequencies, types{type}(cond, :), sems_types{type}(cond,:),...
        markers{cond}, 'MarkerFaceColor', MarkerFaceColor{cond}, 'MarkerSize', markerSize{cond}); 
    end


    % Anotate the figure
    title('All Subjects', 'fontsize',14,'fontweight','b');
    ylabel('Accuracy', 'fontsize',12,'fontweight','b');
    xlabel('Frequencies', 'fontsize',12,'fontweight','b');
    set(gca,'XTick', data.frequencies,'XTickLabel',data.cols,'fontsize',8)
    legend(data.rows, 'Location', 'SouthWest')
    set(gca,'YLim', ylimits{type})
    print(gcf, '-djpeg', [locVars.figsDir locVars.fileName names{type}])

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


for contr = 1:size(data.accuracies_means,1)
    for frq = 1:size(data.accuracies_means,2)
        
        % plot the markers with the y errorbars
        plotHandle(contr,frq) = errorbar(data.meanProportion(contr, frq),data.accuracies_means(contr,frq),...
            data.accuracies_sems(contr,frq), [MarkerFaceColor{contr} shapes{frq}], ...
            'MarkerFaceColor', MarkerFaceColor{contr}, 'MarkerSize', markerSize); %#ok
        % x error bars
        herrorbar(data.meanProportion(contr,frq), data.accuracies_means(contr,frq), ...
            data.meanProportion_sem_half(contr,frq), data.meanProportion_sem_half(contr,frq),...
            [MarkerFaceColor{contr} shapes{frq}]);
        
    end
end

title('Accuracy as a Function of Visibility','fontsize',14)
xlabel('Visibility','fontsize',12)
ylabel('Accuracy','fontsize',12)
legend(plotHandle(1,:), data.cols, 'Location','SouthEast');
set(gca,'Xlim', [0 1])
print(gcf, '-djpeg', [locVars.figsDir locVars.fileName '_subjective'])

close all
