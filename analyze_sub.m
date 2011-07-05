function analyze_sub (Data, subjects, timing_conditions, all_contrasts)

%Data is the matrix containing all subjects' data
 
accuracy = zeros(length(timing_conditions),length(all_contrasts),length(subjects));
yesProportion = zeros(length(timing_conditions),length(all_contrasts),length(subjects));

for i = 1:length(subjects)
    for j = 1:length(timing_conditions)
        for k = 1:length(all_contrasts)
            dataFilter = Data(Data(:,1) == i & Data(:,5) == j & Data(:,3 )== all_contrasts(k),:);
            accuracy(j,k,i) = size(dataFilter(dataFilter(:,6 ) == dataFilter(:,7),:),1) / size(dataFilter,1);
            yesProportion(j,k,i) = size(dataFilter(dataFilter(:,8) == 3 ,:),1) / size(dataFilter,1);
        end
    end
end

meanAccuracy = mean(accuracy,3);
meanProportion = mean(yesProportion,3);
accuracy_sem = std(accuracy,0, 3) ./ sqrt(size(accuracy, 3));
proportion_sem = std(accuracy,0, 3) ./ sqrt(size(accuracy, 3));
meanProportion_sem_half = proportion_sem / 2;

titles = {'Backward masking', 'Forward masking', 'Middle masking', 'Control condition'};

figure()
hold on
line([0 1],[0.25 1]); % linear trend expected    

%shapes for contrast
shapes = {'o' 'v' 's' '^' 'd'};
%color for masking
MarkerFaceColor = {'k'  'b' 'g' 'r'};
markerSize = 10;

for maskCond = 1:size(meanAccuracy,1)
    for cont = 1:size(meanAccuracy,2)
        
        % plot the markers with the y errorbars
        errorbar(meanProportion(maskCond, cont),meanAccuracy(maskCond,cont),...
            accuracy_sem(maskCond,cont), [MarkerFaceColor{maskCond} shapes{cont}], ...
            'MarkerFaceColor', MarkerFaceColor{maskCond}, 'MarkerSize', markerSize);
        % x error bars
        herrorbar(meanProportion(maskCond,cont), meanAccuracy(maskCond,cont), ...
            meanProportion_sem_half(maskCond,cont), meanProportion_sem_half(maskCond,cont), ...
            [MarkerFaceColor{maskCond} shapes{cont}]);
    
    end
end

title('');
xlabel('Proportion of "yes" responses');
ylabel('Accuracy');
set(gca,'Xlim', [0 1])


    
    

