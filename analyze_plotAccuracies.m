function analyze_plotAccuracies (fileName, inDir, outDir)
%This function is also embedded in the script analyze_concatenateData. It
%uses the variables produced by analyze_Accuracy and appened to
%Data_final, to draw graphs.

% Load desired file
load ([inDir fileName])

%% single subject plots

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

        markers = {'-ks'  '-k^' '-ok' '-ks'};
        markerColor = {'k'  'k' 'k' 'k'};
        MarkerFaceColor = {'k'  'b' 'g' 'r'};
        markerSize = 7;
        for cond =1 : size(types{type},1)
            plot(all_contrasts, types{type}(cond, : , subj), markers{cond},'MarkerEdgeColor', markerColor{cond}, ...
                'MarkerFaceColor', MarkerFaceColor{cond}, 'MarkerSize', markerSize); %#ok
        end

        % Anotate the figure
        title(['Subject :  ' num2str(subjects(subj))], 'fontsize',14,'fontweight','b');
        ylabel('Accuracies', 'fontsize',12,'fontweight','b');
        xlabel('Contrast levels', 'fontsize',12,'fontweight','b');
        set(gca,'XTick', all_contrasts,'XTickLabel',cols)
        legend(rows, 'Location', 'Best')

        set(gca,'YLim', ylimits{type})
        print(gcf, '-djpeg', [outDir fileName names{type} num2str(subjects(subj))])

    end

end
%--
%The above loops first plot an accuracy plot for each subject. Then a
%z-scored accuracy plot for each subject. So each subject gets 2 plots and
%the total number of plots is subject number x 2. E.g., 4 subjects->8 plots

%The loops below take the averages of all subjects and creates two plots:
%one with average accuracies, the other with average accuracies z-scored.
%--
%% plot means across participants

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
    markers = {'-ks'  '-k^' '-ok' '-ks'};
    markerColor = {'k'  'k' 'k' 'k'};
    MarkerFaceColor = {'k'  'b' 'g' 'r'};
    % markerSize = 6;
    for cond =1 : size(accuracies,1)
        errorbar(all_contrasts, types{type}(cond, :), sems_types{type}(cond,:), markers{cond},'MarkerEdgeColor', markerColor{cond}, ...
            'MarkerFaceColor', MarkerFaceColor{cond}, 'MarkerSize', markerSize); %#ok
    end

    % Anotate the figure
    title('All Subjects', 'fontsize',14,'fontweight','b');
    ylabel('Accuracy', 'fontsize',12,'fontweight','b');
    xlabel('Contrast levels', 'fontsize',12,'fontweight','b');
    set(gca,'XTick', all_contrasts,'XTickLabel',cols)
    legend(rows, 'Location', 'Best')
    set(gca,'YLim', ylimits{type})
    print(gcf, '-djpeg', [outDir fileName names{type}])

end

close all