function analyze_plotMaskAccuracies (fileName, data, locVars)
%This function is also embedded in the script analyze_concatenateData. 
%It takes data which contains the data matrix + various accuracy measures,
%and variables specifying the relevant directories. Produces various plots.
%%
if ismember(1, locVars.whichPlot)
%% 1. Single subject plots

types = {data.accuracies data.accuracies_zscored};
names = {'_Accuracy_Subject' '_Accuracy_zscored_Subject'};
ylimits = {[0 1] [-2.5 2.5]};


for type = 1 : length(types)

    for subj = 1 : size(types{type}, 3)
        figure();
        grid on
        set(gcf,'Position',[0 0 600 300],'Color','w')
        set(gcf,'PaperPositionMode','auto')
        set(gcf,'InvertHardcopy','off')
        hold on

        markers = {'-ks' '-k^' '-ok' '-ks'}; 
        markerColor = {'k'  'k' 'k' 'k'};
        MarkerFaceColor = {'k' 'b' 'g' 'r'}; 
        markerSize = 7;
        for cond =1 : size(types{type},1)
            plot(data.all_contrasts, types{type}(cond, : , subj), markers{cond},'MarkerEdgeColor', markerColor{cond}, ...
                'MarkerFaceColor', MarkerFaceColor{cond}, 'MarkerSize', markerSize);
        end
        
        % Anotate the figure
        title(['Subject :  ' num2str(data.subjects(subj))], 'fontsize',14,'fontweight','b');
        ylabel('Accuracy', 'fontsize',12,'fontweight','b');
        xlabel('Contrast levels', 'fontsize',12,'fontweight','b');
        set(gca,'XTick', data.all_contrasts,'XTickLabel',data.cols,'fontsize',8)
        legend(data.rows, 'Location', 'SouthEast')
        set(gca,'YLim', ylimits{type})
        set(gca,'XLim', [data.all_contrasts(1) data.all_contrasts(end)])
        print(gcf, '-djpeg', [locVars.figsDir fileName names{type} num2str(data.subjects(subj))])

    end

end
%--
%The above loops first plot an accuracy plot for each subject. Then a
%z-scored accuracy plot for each subject. So each subject gets 2 plots and
%the total number of plots is subject number x 2. E.g., 4 subjects->8 plots

%The loops below take the averages of all subjects and creates two plots:
%one with average accuracies, the other with average accuracies z-scored.
%--
%%
end
%%
if ismember(2, locVars.whichPlot)
%% 2. Plot means across participants

types = {data.accuracies_means data.accuracies_means_zscored};
sems_types = {data.accuracies_sems data.accuracies_sems_zscored};
names = {'_Accuracy_All_Subjects' '_Accuracy_zscored_All_Subjects'};
ylimits = { [0.2 1] [-2.5 2.5]};

for type = 1 : length(types)
    
    figure();
    grid on
    set(gcf,'Position',[0 0 600 300],'Color','w')
    set(gcf,'PaperPositionMode','auto')
    set(gcf,'InvertHardcopy','off')
    hold on
    markers = {'-ks'  '-k^' '-ok' '-ks'};
    markerColor = {'k'  'k' 'k' 'k'};
    MarkerFaceColor = {'k'  'b' 'g' 'r'};
    markerSize = 6;
    for cond =1 : size(data.accuracies,1)
        errorbar(data.all_contrasts, types{type}(cond, :), sems_types{type}(cond,:), markers{cond},'MarkerEdgeColor', markerColor{cond}, ...
            'MarkerFaceColor', MarkerFaceColor{cond}, 'MarkerSize', markerSize);
    end


    % Anotate the figure
    title('All Subjects', 'fontsize',14,'fontweight','b');
    ylabel('Accuracy', 'fontsize',12,'fontweight','b');
    xlabel('Contrast levels', 'fontsize',12,'fontweight','b');
    set(gca,'XTick', data.all_contrasts,'XTickLabel',data.cols,'fontsize',8)
    legend(data.rows, 'Location', 'SouthEast')
    set(gca,'YLim', ylimits{type})
    set(gca,'XLim', [data.all_contrasts(1) data.all_contrasts(end)])
    print(gcf, '-djpeg', [locVars.figsDir fileName names{type}])

end
%%
end
%%
if ismember(3, locVars.whichPlot)
%% 3. Plot mean subjective response accuracy vs. actual accuracy 

figure()
set(gcf,'Position',[0 0 600 450],'Color','w')
set(gcf,'PaperPositionMode','auto')
set(gcf,'InvertHardcopy','off')
hold on
line([0 1],[0.25 1]); % linear trend expected    

%shapes for contrast
shapes = {'o' 'v' 's' '^' 'd'};
%color for masking
MarkerFaceColor = {'k'  'b' 'g' 'r'};
markerSize = 10;


for maskCond = 1:size(data.accuracies_means,1)
    for cont = 1:size(data.accuracies_means,2)
        
        % plot the markers with the y errorbars
        plotHandle(maskCond,cont) = errorbar(data.meanProportion(maskCond, cont),data.accuracies_means(maskCond,cont),...
            data.accuracies_sems(maskCond,cont), [MarkerFaceColor{maskCond} shapes{cont}], ...
            'MarkerFaceColor', MarkerFaceColor{maskCond}, 'MarkerSize', markerSize); %#ok
        % x error bars
        herrorbar(data.meanProportion(maskCond,cont), data.accuracies_means(maskCond,cont), ...
            data.meanProportion_sem_half(maskCond,cont), data.meanProportion_sem_half(maskCond,cont), ...
            [MarkerFaceColor{maskCond} shapes{cont}]);
        
    end
end

title('Accuracy as a Function of Visibility','fontsize',14)
xlabel('Visibility', 'fontsize', 12)
ylabel('Accuracy', 'fontsize', 12)
legend(plotHandle(1,:), data.cols, 'Location', 'SouthEast')
set(gca,'Xlim', [0 1])
print(gcf, '-djpeg', [locVars.figsDir fileName '_subjective'])
end
close all