function analyze_maskBlocks %(Data)
locVars = localVariables;
fileNam = 'maskExpFinal_Subjects_1   2   3   4   5   6   7   8   9  10  11  12';
load ([locVars.resultsDir fileNam])

Data = Data(Data(:,4) < 10 | Data(:,4) > 40, :); %Some data was like that.

timing_conditions = unique(Data(:,5)); 
all_contrasts = unique(Data(:,3)); 
which_subjects = locVars.subjFilter;
all_blocks = unique(Data(:,2));

blocuracies =  zeros(length(timing_conditions), length(all_contrasts), length(all_blocks), length(which_subjects));
for subj = 1: length(which_subjects)
    for bloc = 1: length(all_blocks)
        for cond =1 : length(timing_conditions)
            for contr =1 :length(all_contrasts)
                aux_data = Data(Data(:,1)== locVars.subjFilter(subj) & Data(:,2)== all_blocks(bloc) ...
                    & Data(:,3) ==all_contrasts(contr) & Data(:,5)== timing_conditions(cond), :) ;
                blocuracies(cond, contr, bloc, subj) = size( aux_data( aux_data(:,6) == aux_data(:,7), :), 1) / size(aux_data, 1);
            end
        end
    end
end

accu_means = mean(blocuracies, 3); %#ok
accu_std = std(blocuracies, 0, 3); %#ok
accu_sems = std(blocuracies,0, 3) ./ sqrt(size(blocuracies, 3)); %#ok

save([locVars.resultsDir 'blockAccuracies_subjects_' num2str(which_subjects)], ...
    'blocuracies', 'accu_means', 'accu_std', 'accu_sems')

%% Plotting
for subj = 1: length(which_subjects)
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
   
    for cond =1 : size(blocuracies,1)
        errorbar(all_contrasts, accu_means(cond,:,1,subj), accu_sems(cond,:,1,subj), markers{cond},'MarkerEdgeColor', markerColor{cond}, ...
            'MarkerFaceColor', MarkerFaceColor{cond}, 'MarkerSize', markerSize);
    end


    % Anotate the figure
    title((['Subject: ' num2str(which_subjects(subj))]), 'fontsize',14,'fontweight','b');
    ylabel('Accuracy', 'fontsize',12,'fontweight','b');
    xlabel('Contrast levels', 'fontsize',12,'fontweight','b');
    set(gca,'XTick', data.all_contrasts,'XTickLabel',data.cols,'fontsize',8)
    legend(data.rows, 'Location', 'SouthEast')
    set(gca,'YLim', [0 1])
    set(gca,'XLim', [all_contrasts(1) all_contrasts(end)])
    %print(gcf, '-djpeg', [locVars.figsDir fileName names{type}])
end
    