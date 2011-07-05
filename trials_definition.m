function trials_definition (blockName)



%% parameters for mondrians
    Mondrians.stimDur = 100; %total number of frames for the stimuli presentation period
    Mondrians.mondrianStart= 1; % 1: means start from from frame 1; 0: without mondrians
    Mondrians.mondrianEnd= 100; % frame number to stop showing mondrians
    Mondrians.mondrianRate = 10; % numbers of frames to present each mondrian
    Mondrians.mondrianEyeLocation = 1; % 1: mondrians to the left eye; 2: mondrians to the righ eye
    Mondrians.mondrianTiming = Mondrians.mondrianStart:Mondrians.mondrianRate:Mondrians.mondrianEnd;   
    
    
%% parameters for the checkerboard

% 0.04 0.12 0.16 0.24 0.64 0.96
contrast = [0.04 0.12 0.16 0.24 0.64]; % michelson contrast 
checkLocation = [1 2 3 4];
% locations = 1: up; 2: down; 3: Left; 4: right;
timing = {[39 49 59 69] [32 42 52 62] [36 46 56 66] [6 6 6 6]};
% timingConds = { 'backwardMasking' 'forwardMasking' 'middleMasking'
% 'control'}; % 1, 2, 3, 4

repetitions= 2; % repetition of the minimun design -one trial per condition-

% Create the block trials
Trial = zeros(length(contrast) * length(timing) * length (checkLocation), 8);
count = 1;
for m= 1 : length(contrast)
    for j = 1 : length(timing) % timing conditions
        for k = 1 : length (checkLocation)
            
            Trial(count, 1) = 0; % subject number
            Trial(count, 2) = 0; % Block number
            Trial(count, 3) = contrast(m); % contrast value
            randi = ceil(rand(1)*4);
            Trial(count, 4) = timing{j}(randi); % timing value
            Trial(count, 5) = j; % code for the timing conditions
            Trial(count, 6) = k; % location of the checkerboard
            Trial(count, 7) = 0; %  responses for locations
            Trial(count, 8) = 0; %  responses for subjective visibility
            count = count + 1; 
        end
    end
end

Trial = repmat(Trial, repetitions, 1); %#ok

save(blockName, 'Trial', 'Mondrians')
