function trials_definition_Control 


% Function to define the trials in which no CFS is used but just backward,
% forward and middle masking with the same timing as in the frequency
% experiment

%% parameters for mondrians
Mondrians.stimDur = 130; %total number of frames for the stimuli presentation period
Mondrians.mondrianEyeLocation = 1; % 1: mondrians to the left eye; 2: mondrians to the righ eye

%% Parameters for the checkerboard

% 0.04 0.12 0.16 0.24 0.64 0.96
contrast = [0.12 0.16 0.64]; % michelson contrast
checkLocation = [1 2 3 4]; % locations = 1: up; 2: down; 3: Left; 4: right;

% With 85 Hz refresh rate. Frames rate:
% 16 frames = 5.3 hz
% 10 frames = 8.47hz
% 8 frames = 10.6 hz
% 5 frames = 16.6 hz
% 4 frames = 20.3 hz
% 3 frames = 28.5 hz

% 8.5 hz
% 1    11    21    31    41    51    61    71    81    91   101   111   121
% 0.0118    0.1294    0.2471    0.3647    0.4824    0.6000    0.7176    0.8353    0.9529    1.0706    1.1882    1.3059
%     1.4235
% 10 hz
%      1     9    17    25    33    41    49    57    65    73    81    89    97   105   113   121   129
%     0.0118    0.1059    0.2000    0.2941    0.3882    0.4824    0.5765    0.6706    0.7647    0.8588    0.9529    1.0471
%    1.1412    1.2353    1.3294    1.4235    1.5176

blockName = 'Block_Control_28Hz';
frequencyCodes = {28.5};%{5  8.5  10.6  16.6  20.3  28.5};
frequency = {3};%{16  10  8  5  4  3};  % number of frames to present each mondrian (MondrianRate in previous versions)
% each position in the cell array corresponds to each frequency
timing = { [50 62 74] };  % { [79 95] [49 59 69] [55 63 71] [49 59 69] [51 63 75] [50 62 74] }; 
% timingConds = { 'backwardMasking'};  % 1

repetitions= 10; % repetition of the minimun design -one trial per condition-

% Create the block trials: set one trial in each condition / location
Trial = zeros(length(contrast) * length(frequency) * length (checkLocation), 8);
count = 1;
for m= 1 : length(contrast)
    for freq = 1: length(frequency)

        for loc = 1 : length (checkLocation)

            Trial(count, 1) = 0; % subject number
            Trial(count, 2) = 0; % Block number
            Trial(count, 3) = contrast(m); % contrast value
            randi = ceil(rand(1) * length( timing{freq}) ) ;
            Trial(count, 4) = timing{freq}(randi); % timing value
            Trial(count, 5) = frequencyCodes{freq}; % code for the frequency conditions
            Trial(count, 6) = loc; % location of the checkerboard
            Trial(count, 7) = 0; %  responses for locations
            Trial(count, 8) = 0; %  responses for subjective visibility
            
            Mondrians.mondrianStart= Trial(count, 4) + 2 - frequency{freq}; % 1: means start from from frame 1; 0: without mondrians
            Mondrians.mondrianEnd=  Trial(count, 4) + 2  + frequency{freq}; % frame number to stop showing mondrians
            
            Mondrians.mondrianRate{count, 1} = frequency{freq};
            Mondrians.mondrianTiming{count, 1} = Mondrians.mondrianStart: frequency{freq} :Mondrians.mondrianEnd; %#ok

            count = count + 1;
        end
    end
end

Trial = repmat(Trial, repetitions, 1); %#ok
Mondrians.mondrianTiming = repmat(Mondrians.mondrianTiming, repetitions, 1); %#ok
Mondrians.mondrianRate = repmat(Mondrians.mondrianRate, repetitions, 1); %#ok
save(blockName, 'Trial', 'Mondrians')



