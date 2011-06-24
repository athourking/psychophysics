function analyze_plotAccuracies (fileName, inDir, outDir)

% Load desired file
load ([inDir fileName])

%% single subject plots

types = {accuracies accuracies_zscored};
names = {'_Accuracy_Subject' '_Accuracy_zscored_Subject'};
ylimits = { [0 1] [-2.5 2.5]};

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



%% plot means across participants

types = {accuracies_means accuracies_means_zscored};
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
        plot(all_contrasts, types{type}(cond, :), markers{cond},'MarkerEdgeColor', markerColor{cond}, ...
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