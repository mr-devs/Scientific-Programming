%% Signal Analysis, PCA and Permutation Tests %%

% Script Summary:
    % This script loads a few different files and performs signal
    % analysis, primary component analysis, and permutation tests
    % throughout, depending on the files being analyzed.
    
% INPUT: 
    % ~ LOY.mp4: a sound file of the Laurel or Yanny audio clip
    % ~ soundSignals.Mat: a Matlab workspace which includes three signal
    % files:
        % signal1, signal2, signal3
    % ~ LSRP: recorded observations from the Levenson Self-Report
    % Psycopathy Scale.
        % Columns 1-26 are responses to questions (each answer is provided
        % on a scale from 1-5) 
        % Column 27 is coded as 1 = male, 0 = female
        % Rows represent participants    
    
% OUTPUT: 
    % ~ played audio from the soundfiles
    % ~ visualizations of signals, numerous spectrograms
    % ~ permutation test on the LSRP data with respect to males vs females
    % ~ numerous histogramograms for different iterations of the LSRP data
    
% Author:           Mystery (Wo)Man        
% Contact Email:    mystery(wo)man@nyu.edu
% Date Created:     06/30/2019 (mm/dd/yyyy)

% Revision histogramory (date format: mm/dd/yyyy)

% Revision #: Original
% Date              % Author        % Description
% 06/30/2019        % M. (Wo)Man    % Script was created

%% 0 Init. and Load

clear all
close all
clc

% !! MAKE SURE TO ADJUST THE PATH'S BELOW TO WHERE YOU HAVE THESE FILES
% SAVED !! %%

rawData = xlsread('LSRP.xlsx') ; % Load LSRP data
load('soundSignals.mat') % load "soundSignals"
soundFile = 'C:\Users\mdeve\OneDrive\Documents\NYU\2019 Summer\Assignments\Assignment 4\LOY.mp4' ;
[LOYsignal,Fs] = audioread('LOY.mp4')   ;   % Read in the signal and sampling rate separately.

% Graphing variables
fS          = 10                                            ;   % General fontsize for final graph
lW          = 1.5                                           ;   %Line width
arbitraryHeightOfCILine = [3500 3700] ; % arbitrary height chosen to represent Confidence internval marker
centerOfArbitraryLine = 3600 ;  % same as above, but this is the line that connects the other two (see last plot)

%% 1. Primary Component Analysis of Three Signals

% Play each signal, separated by a user key press. 
% NOTE: User must click into command window for key press to be recognized.

sound(signal1,fs)   % play signal 1
pause               % pause for user input
sound(signal2,fs)   % play signal 2
pause               % pause for user input
sound(signal3,fs)   % play signal 3

%% 1.1 Determine the makeup (which components it consists of) of each signal by
% visualizing the signal in the time and/or the frequency domain 

subplot(2,3,1)                  ;   % Create subplot, place in first position
signal1Plot = plot(signal1)     ;   % Plot signal 1 over time
colormap(jet)                   ;   % Change colormap to jet
set(gca, 'FontSize', fS)        ;   % Sets font size for graph
set(gca, 'TickDir', 'out')      ;   % Sets tick marks on graph to the outside
xlabel('Time')                  ;   % Set x label
ylabel('Frequency(kHz)')        ;   % Set y label
title('Signal 1')               ;   % Sets a title for the graph

subplot(2,3,2)                  ;   % Create subplot, place in second position
signal2Plot = plot(signal2)     ;   % Plot signal 2 over time
colormap(jet)                   ;   % Change colormap to jet
set(gca, 'FontSize', fS)        ;   % Sets font size for graph
set(gca, 'TickDir', 'out')      ;   % Sets tick marks on graph to the outside
xlabel('Time')                  ;   % Set x label
ylabel('Frequency(kHz)')        ;   % Set y label
title('Signal 2')               ;   % Sets a title for the graph

subplot(2,3,3)                  ;   % Create subplot, place in third position
signal3Plot = plot(signal3)     ;   % Plot signal 3 over time
colormap(jet)                   ;   % Change colormap to jet
set(gca, 'FontSize', fS)        ;   % Sets font size for graph
set(gca, 'TickDir', 'out')      ;   % Sets tick marks on graph to the outside
xlabel('Time')                  ;   % Set x label
ylabel('Frequency(kHz)')        ;   % Set y label
title('Signal 3')               ;   % Sets a title for the graph

% 1.2 Plot spectrograms of each singal below the corresponding signal plot.
windowShape = hamming(456)                                          ;   % Set window size
frequencyRange = 0:5:1000                                           ;   % Set frequency range
overl = round(length(windowShape)/2)                                ;   % Set the overlap to half the window size (rounded)

subplot(2,3,4)                                                      ;   % Create a subplot and place in position 4
spectrogram(signal1,windowShape,overl,frequencyRange,fs,'yaxis')    ;   % Create a spectrogram (signal1) to live in this position
colormap(jet)                                                       ;   % Change colormap to 'jet'
set(gca, 'FontSize', fS)                                            ;   % Sets font size for graph                  
set(gca, 'TickDir', 'out')                                          ;   % Sets tick marks on graph to the outside
title('Signal 1 Spectrogram')                                       ;   % Sets a title for the graph

subplot(2,3,5)                                                      ;   % Create a subplot and place it in the fifth position
spectrogram(signal2,windowShape,overl,frequencyRange,fs,'yaxis')    ;   % Create a spectrogram (signal2) to live in this position
colormap(jet)                                                       ;   % Change colormap to 'jet'
set(gca, 'FontSize', fS)                                            ;   % Sets font size for graph
set(gca, 'TickDir', 'out')                                          ;   % Sets tick marks on graph to the outside
title('Signal 2 Spectrogram')                                       ;   % Sets a title for the graph

subplot(2,3,6)                                                      ;   % Create a subplot and place it in the 6th position
spectrogram(signal3,windowShape,overl,frequencyRange,fs,'yaxis')    ;   % Create a spectrogram (signal3) to live in this position
colormap(jet)                                                       ;   % Change colormap to 'jet'
set(gca, 'FontSize', fS)                                            ;   % Sets font size for graph
set(gca, 'TickDir', 'out')                                          ;   % Sets tick marks on graph to the outside
title('Signa 3 Spectrogram')                                        ;   % Sets a title for the graph

% Based on the spectrogram graphs, it looks like these are all low
% frequency signals. Signal 2 appears to include signals that are slightly
% higher than signal 1, and signal 3 looks to be the these signals
% combined, though this would need to be confirmed in other ways. 

%% 2.0 Laurel or Yanny Sound Bite Manipulations

sound(LOYsignal,Fs)                     ;   % Play the lauren/yanny signal 

% Comment:
% Sounds like some type of growling. My girlfriend says - "alien growling or
% zombies growling or robot alien growling" (?)

%  Visualizing the signal with a spectogram in a way that closely resembles
% the spectogram in this article (http://bit.ly/LOY2019S)
windowShape = hanning(1500)                                         ;   % Set window size
frequencyRange = 0:1:Fs/7.4                                         ;   % Set frequency range
overl = round(length(windowShape)/2)                                ;   % Set overlap size
spectrogram(LOYsignal,windowShape,overl,frequencyRange,Fs,'yaxis')  ;   % Create spectrogram for the laurel or yanny file
colormap(jet)                                                       ;   % Change colormap to 'jet'

% Play the same signal with a sampling rate that is 20% slower as well as
% 20% faster than th original sampling rate. 
sound(LOYsignal, Fs*.8)         ;   % 20% slower... Sounds like Yanny!
sound(LOYsignal, Fs*1.2)        ;   % 20% faster... Sounds like Laurel!
% This is some trippy sh*t.

%% 3.0 Levenson Self-Report Psychopathy Scale

% Descritpion of the data
    % First 26 columns represent the first 26 items on the test
    % Each item is rated from 1 to 5
    % Rows Represent participants
    % Last column represents "Sex assigned at birth": 0 = Female 1 = Male

columnVector = [6, 14, 19, 22, 24, 25, 26] ; % Inversely coded question columns
    
% Remove NaNs participantwise with rmmissing()

noNans = rmmissing(rawData)     ;   % Remove missing data participantwise
cleanData = noNans              ;   % Make a copy of this data to flip the inversely coded questions

% Flip the inversely coded scores by subtracting from 6

for col = columnVector                                                  %   For all inversely coded columns
    for participant = 1:length(cleanData)                               %   For all rows/participants
        cleanData(participant,col) = 6 - cleanData(participant,col) ;   %   Subtract score from 6 to get the correct coding    
    end
end

totalsMatrix = zeros(length(rawData), 2)            ;   % Preallocate two column zeros matrix length of rawData - where the totals will go
totalsMatrixClean = zeros(length(cleanData), 2)     ;   % Preallocate two column zeros matrix length of cleanData - where the totals will go


for rows = 1:length(totalsMatrix)                       % for 1 through length of totalsMatrix
   totalsMatrix(rows,1) = sum(rawData(rows,1:26))   ;   % take the sum of the rows and place into the first column of the totals matrix
   totalsMatrix(rows,2) = rawData(rows,27)          ;   % take the gender of the rows and place into the first column of the totals matrix

end

for rows = 1:length(totalsMatrixClean)                       % for 1 through length of totalsMatrix
   totalsMatrixClean(rows,1) = sum(cleanData(rows,1:26))    ;% take the sum of the rows and place into the first column of the totals matrix
   totalsMatrixClean(rows,2) = cleanData(rows,27)           ;% take the gender of the rows and place into the first column of the totals matrix
end

mean(totalsMatrixClean(:,1))                                 % Output mean of clean data to annotate in graph

subplot(2,1,1)
uncleanedTotal = totalsMatrix(:,1)      ;   % place raw totals into a new variable
histogram(uncleanedTotal,20)                 ;   % create a histogramogram with 20 bins plotting these totals
set(gca, 'FontSize', fS)                ;   % Sets font size for graph
set(gca, 'TickDir', 'out')              ;   % Sets tick marks on graph to the outside
title('Uncleaned LSRP Data Totals')     ;   % Sets a title for the graph
xlabel('Total Score')                   ;   % Sets a label for the x-axis
ylabel('Instances of Total Score')      ;   % Sets a label for the y-axis
box off                                     % get rid of the box

subplot(2,1,2)
cleanedTotal = totalsMatrixClean(:,1)   ;   % place cleans totals into a new variable
histogram(cleanedTotal,20)                   ;   % create a histogramogram with 20 bins plotting these totals
set(gca, 'FontSize', fS)                ;   % Sets font size for graph
set(gca, 'TickDir', 'out')              ;   % Sets tick marks on graph to the outside
title('Cleaned LSRP Data Totals')       ;   % Sets a title for the graph
xlabel('Total Score')                   ;   % Sets a label for the x-axis
ylabel('Instances of Total Score')      ;   % Sets a label for the y-axis
box off                                     % get rid of the box
 X = [0.5 0.44]                         ;   % Create coordinates for x value to use in annotation arrow
 Y = [.4   0.38]                        ;   % Create coordinates for x value to use in annotation arrow
meanArrow = annotation('textarrow', X, Y, 'string', 'Mean Valid Data = 61.4824') ;  % create an annotated arrow
meanArrow.Color = 'r'                   ;   % change color to red 

%% Calculate a PCA on the LSRP data

[loadings, origDataInNewDimensions, eigVal] = pca(cleanData(:,1:26)); % Run the PCA

% Make a scree plot to assess how many factors should be retained

figure
bar(1:length(eigVal),sortrows(eigVal,-1))           ; % Create a bar graph with sorted eigen Values
title('Scree plot')                                 ; % add a title for the plot
line([min(xlim) max(xlim)],[1 1],'linestyle','--', 'color','r') ; % add a criterion line based on the Kaiser cutoff of 1 

% Comment how many factors should be interpreted meaningfully (based on elbow or Kaiser Criterion)
% Based on the elbow criterion,  the first 14 factors should be
% interpreted meaningfully. If we use the elbow criterion, we would likely
% only accept the first two factors. Following this proceedure would lose
% approximately 18% of the variance accounted for by each factor. Thus,
% utilizing the Kaiser criterion gives us a good cut off, while not
% discarding a large amount of the explained variance.

% Calculate and note - how much of the total variance is explained by these
% factors
varExplained = eigVal./sum(eigVal).*100 ; %Variance explained by the factor

importantExplainedVariance = sum(varExplained(1:14)) ; 

% These factors account for approximately 77% of the variance seen in these
% questions. 

%% Are males more likely to be psychopathic?

% Use resampling methods to perform a permutation test

% Conceive of a reasonable test statistic 

% get indies for males and females
maleIndex = find(totalsMatrixClean(:,2) == 1)   ; 
femaleIndex = find(totalsMatrixClean(:,2) == 0) ;

% get a total number of both males and females
numMales = length(maleIndex)        ; 
numFemales = length(femaleIndex)    ;

% use the index vectors to pull out all male and female scores
males = totalsMatrixClean(maleIndex, 1)     ;
females = totalsMatrixClean(femaleIndex, 1) ; 

% find the average of both
meanMales = sum(males)/numMales         ;
meanFemales = sum(females)/numFemales   ;

% Create a vector that is the mean male score repeated as many times as

% find the mean difference of between each group
empiricialSexDifferences = mean(males) - mean(females) ; 

% take the average of all these differences
% meanSexDifference = mean(sexDifferences)  % This will serve as the test statistic
numSamples = 1e5                        ;   % 100k times
pooledScores = [males ; females]        ;   % Put the male and female groups together
meanDistribution = zeros(numSamples,1)  ;   % preallocate mean distribution with zeros


% work on the permutation test...

for i = 1:numSamples                                                                % For 1:100K
    shuffledIndices = randperm(length(pooledScores))                            ;   % create a vector 1:597, in random order
    newTempPooledScores = pooledScores(shuffledIndices)                         ;   % use this vector as indices, to create a shuffled pooled group of total scores
    simulatedFemaleGroup = newTempPooledScores(1:length(females))               ;   % Pull out scores - size of female group
    simulatedMaleGroup = newTempPooledScores(length(females)+1 : end)           ;   % pull out scores - size of male group
    simulatedMeanDiff = mean(simulatedMaleGroup) - mean(simulatedFemaleGroup)   ;   % find the means of these groups and take the difference
    meanDistribution(i) = simulatedMeanDiff                                     ;   % place this difference in the distribution of mean differences
end

exactP = sum(meanDistribution>empiricialSexDifferences)/length(meanDistribution) ;

% Visualize how the test statistic distributes if there was no difference
% b/w groups and calculate the exact p-value


meanDistributionCI = prctile(meanDistribution, [2.5, 97.5]); % find the percentiles
histogram(meanDistribution, 100) ; % create a histogram
hold on     ; % hold on
lowerCI = line([meanDistributionCI(1) meanDistributionCI(1)], arbitraryHeightOfCILine, 'color', 'k', 'linewidth', lW) ; % create line for upper CI
upperCI = line([meanDistributionCI(2) meanDistributionCI(2)], arbitraryHeightOfCILine, 'color', 'k', 'linewidth', lW) ; % Create line for lower CI
connectingCI = line([meanDistributionCI(1) meanDistributionCI(2)], [centerOfArbitraryLine centerOfArbitraryLine],'color', 'k', 'linewidth', lW) ; % Line to connect these two lines
connectingCI.LineStyle = '--' ; % change line style
X = [0.672 0.672];  % Create coordinates for annotation arrow
Y = [.3   0.2];     % coordinates for annotation arrow
meanArrow = annotation('textarrow', X, Y, 'string', 'Mean Difference from Data = 5.0159.') ; % create arrow
meanArrow.Color = 'r' ; % change color of arrow
set(gca, 'FontSize', fS) %Sets font size for graph
set(gca, 'TickDir', 'out') %Sets tick marks on graph to the outside
title('Distribution of Mean Differences Based on Sex (100K)') %Sets a title for the graph
xlabel('Difference between Males and Females') %Sets a label for the x-axis
ylabel('Number of Resamples') %Sets a label for the y-axis
legend('Resampled Mean Differences', '95% Confidence Interval', 'location', 'southeastoutside')
box off

% Comment on what you determine in terms of potential gender differences

% Based on the Permutations test, we can see that the difference in sex
% related psychosis is significantly outside the 95% confidence interval,
% the p value is well below 95% threshold @ 1.0000e-05, there appears to be
% a significant difference.
