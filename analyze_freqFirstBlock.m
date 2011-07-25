function analyze_freqFirstBlock (Data)   

% If you want to produce single block plots from raw data en masse, this is
% the best function for it, though needs to be modified by adding a couple 
% of loops for subject and block numbers (among other little things). 
% Currently this function is embedded in runExp and produces and saves 
% each block accuracy plot on the go, while the experiment is going on.

all_contrasts = unique(Data(:,3));
frequencies = unique(Data(:,5));

for con = 1: length(all_contrasts)
        for freq = 1: length(frequencies)
            accuracies(con, freq) = size(Data(Data(:,3)== all_contrasts(con) & Data(:,5)== frequencies(freq)...
                & Data(:,6)== Data(:,7),:),1) / size(Data(Data(:,3)== all_contrasts(con) & Data(:,5)== frequencies(freq)),1); %#ok
        end
end

        figure();
        set(gcf,'Position',[0 0 600 300],'Color','w')
        set(gcf,'PaperPositionMode','auto')
        set(gcf,'InvertHardcopy','off')
        hold on

        markers = {'-kd' '-ks' '-ok'};% '-ks'}; 
        MarkerFaceColor = {'b' 'k' 'r'};% 'g'}; 
        markerSize = {8 7 7};
        %markerColor = {'k' 'k'};% 'k' 'k'};
     
        for cond =1 : size(all_contrasts,1)
            plot(frequencies, accuracies(cond, :), markers{cond},...
                'MarkerFaceColor', MarkerFaceColor{cond}, 'MarkerSize', markerSize{cond}); 
        end
                
        % Anotate the figure
        %Create labels to be used for plotting frequencies (used for x axis)
        for m= 1: length(frequencies)
            data.cols{m} = ([num2str(frequencies(m)) ' Hz']);
        end
        
        %Create labels to be used for plotting contrasts (used for the legend)
        for n= 1: length(all_contrasts)
            rows{n}= (['backward at ' num2str(all_contrasts(n)*100) '%']);
        end

        title('Block accuracies', 'fontsize',14,'fontweight','b');
        ylabel('Accuracies', 'fontsize',12,'fontweight','b');
        xlabel('Frequencies', 'fontsize',12,'fontweight','b');
        set(gca,'XTick', frequencies,'XTickLabel',num2str(frequencies),'fontsize',8)
        legend(rows, 'Location', 'SouthWest')

        set(gca,'YLim', [0 1])
        
        subjNum = Data(1,1);
        blocNum = Data(1,2);
        shallBeCalled = (['singleBlockFreqAccu_subjNum_' num2str(subjNum) '_blockNum_' num2str(blocNum)]);         
        print(gcf, '-djpeg', [pwd '\' shallBeCalled]); 
        