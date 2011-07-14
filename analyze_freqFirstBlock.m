function analyze_freqFirstBlock (Data)   

all_contrasts = unique(Data(:,3));
frequencies = unique(Data(:,5));

for con = 1: length(all_contrasts)
        for freq = 1: length(frequencies)
            accuracies(con, freq) = size(Data(Data(:,3)== all_contrasts(con) & Data(:,5)== frequencies(freq)...
                & Data(:,6)== Data(:,7),:),1) / size(Data(Data(:,3)== all_contrasts(con) & Data(:,5)== frequencies(freq)),1); %#ok
%             
%             accuracies(con, freq, su) = size(Data(Data(:,1) == su & Data(:,3)== all_contrasts(con) & Data(:,5)== frequencies(freq)...
%                 & Data(:,6)== Data(:,7),:),1)  ...
%                 / size(Data(Data(:,1) == su & Data(:,3)== all_contrasts(con) & Data(:,5)== frequencies(freq)),1);
%      
            
        end
end

        figure();
        set(gcf,'Position',[0 0 600 300],'Color','w')
        set(gcf,'PaperPositionMode','auto')
        set(gcf,'InvertHardcopy','off')
        hold on

        markers = {'-kd' '-ks'};% '-ok' '-ks'}; 
        MarkerFaceColor = {'b' 'k'};% 'g' 'r'};
        markerSize = {8 7};
        %markerColor = {'k' 'k'};% 'k' 'k'};
     
        for cond =1 : size(all_contrasts,1)
            plot(frequencies, accuracies(cond, :), markers{cond},...
                'MarkerFaceColor', MarkerFaceColor{cond}, 'MarkerSize', markerSize{cond}); 
        end
        
        % Anotate the figure
        title('Block accuracies', 'fontsize',14,'fontweight','b');
        ylabel('Accuracies', 'fontsize',12,'fontweight','b');
        xlabel('Frequencies', 'fontsize',12,'fontweight','b');
        set(gca,'XTick', frequencies,'XTickLabel',num2str(frequencies),'fontsize',8)
        rows = {'backward at 12%' 'backward at 16%'};
        legend(rows, 'Location', 'SouthWest')

        set(gca,'YLim', [0 1])
