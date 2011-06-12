function analyze_firstBlock(fileNameIn)


inDir = '/home/lisandro/Work/Project_CFS/CFS_Checkerboard/Data/';
load ([inDir fileNameIn]);
Data = Exp.Trial;  
timing_conditions = unique(Data(:,5)); 
all_contrasts = unique(Data(:,3)); 

accuracies =  zeros(length(timing_conditions), length(all_contrasts));

for cond =1 : length(timing_conditions)
        for contrast =1 :length(all_contrasts)
 
            aux_data = Data(Data(:,5) ==timing_conditions(cond)...
                & Data(:,3)== all_contrasts(contrast), :) ;
            %just a sanity check
            if size(aux_data, 1) ~= 8
                display ('ERROR IN THE NUMBER OF TRIALS')
                return
            end                     
            
        accuracies(cond, contrast) = size( aux_data( aux_data(:,6) == aux_data(:,7), :), 1) / size(aux_data, 1);            
        end
end

%Plotting
    figure();
    set(gcf,'Position',[0 0 600 300],'Color','w')
    set(gcf,'PaperPositionMode','auto')
    set(gcf,'InvertHardcopy','off')
    hold on

    markers = {'-ks'  '-k^' '-ok' '-o'};  
    markerColor = {'k'  'k' 'k' 'k'};
    MarkerFaceColor = {'k'  'b' 'g' 'm'};
    
    for cond =1 : size(accuracies,1)
        plot(all_contrasts, accuracies(cond,:),markers{cond},'MarkerEdgeColor', markerColor{cond}, ...
            'MarkerFaceColor', MarkerFaceColor{cond}, 'MarkerSize',10); 
    end

       
    % Anotate the figure
    rows = {'backward' 'forward' 'middle' 'control'};
    contrastLevels = num2cell(all_contrasts');
    
    title('Block 1', 'fontsize',14,'fontweight','b');
    ylabel('%', 'fontsize',12,'fontweight','b');
    xlabel('Levels', 'fontsize',12,'fontweight','b');
    set(gca,'XTick', all_contrasts,'XTickLabel',contrastLevels,'fontsize',8)
    legend(rows, 'Location', 'Best')

    set(gca,'YLim',[0 1])
    
    