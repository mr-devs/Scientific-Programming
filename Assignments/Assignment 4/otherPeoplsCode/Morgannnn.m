%Assignment 4
%The purpose of this assignment is to 
%Header

%Dependencies/assumptions: Assumes the dataset is in the same path as the
%script.
%6/27/19


%% 0 Initialization ("Birth") to avoid logical errors
%Step 1: "Blank slate"
clear all %Clear memory
close all %Closes open figures
clc %Clear command history


%Step 2: Load data
load('soundSignals.mat');
LSRPData = xlsread('C:\Users\mdeve\OneDrive\Documents\NYU\2019 Summer\Assignments\Assignment 4\otherPeoplsCode\LSRP.xlsx', 1);
%this is the data containing scores and gender ID 
[signal4, fs2] = audioread('LOY.mp4');


%Step 3: Priors: List all variables used in the code
freqRange = 0:5:3000; %You can go up to nyquist, which is half
%sampling, but not more. This will go on the y-axis.
%%%sampFreq = 1e4; %10k
%%%timeBase = 0:1/sampFreq:1; %Create a 1 second time base
windowShape = hamming(144); %Tradeoff in what windowing artifacts you get depending on shape
%Length of window determines tradeoff between knowing when frequency
%happened vs. what kind
windowShape2 = hanning(444);
overl = round(length(windowShape)/2); %Less overlap: Blocky. Little overlap: Slow (need to do ......)
overl2 = round(length(windowShape2)/2); %Less overlap: Blocky. Little overlap: Slow (need to do ......)

pruningMode = 2; %If pruning mode = 1, eliminate elementwise, If 2, do so participantwise



%Aesthetic variables
fS = 10; %Font size
lW = 1; %Line width


%% 1 Playing signals as sounds

%3 different sound signals sampled at CD quality for 2 seconds. Script will
%play each signal as a sound, separated by pauses (user input).

%44100 fs is CD quality

sound(signal1, fs) %Plays the sound of signal 1
pause(5) %Pauses and waits 5 seconds
sound(signal2, fs) %Plays the sound of signal 2
pause(5) %Pauses and waits 5 seconds
sound(signal3, fs) %Plays the sound of signal 3

%clear sound %Kills the sound

sineWaves = figure; %Opens a figure
set(sineWaves,'Color','w');
%set(sineWaves,'WindowState','fullscreen');

%Plot signal 1 sine waves and spectrogram
subplot(2,3,1) %Opens a subplot to plot signal 1 in the first of three rows
plot(signal1) %Plots signal 1 sine wave
title('Signal 1 Amplitude over Time') %Sets a title for the graph
xlabel('Time') %Sets a label for the x-axis
ylabel('Signal Amplitude') %Sets a label for the y-axis
set(gca,'FontSize',fS) %Sets font size for graph as defined in priors
set(gca, 'TickDir', 'out') %Sets tick marks on graph to the outside
set(gca, 'LineWidth', lW); %Sets linewidth as defined in priors
subplot(2,3,4)
plot(signal1)
spectrogram(signal1, windowShape, overl, freqRange, fs, 'yaxis')
colormap(jet)
title('Signal 1 Amplitude over Time') %Sets a title for the graph
xlabel('Time') %Sets a label for the x-axis
ylabel('Signal Amplitude') %Sets a label for the y-axis
set(gca,'FontSize',fS) %Sets font size for graph as defined in priors
set(gca, 'TickDir', 'out') %Sets tick marks on graph to the outside
set(gca, 'LineWidth', lW); %Sets linewidth as defined in priors

%Plot signal 2 sine waves and spectrogram
subplot(2,3,2) %Opens a subplot to plot signal 2 in the second of three rows
plot(signal2) %Plots signal 2 sine wave
title('Signal 2 Amplitude over Time') %Sets a title for the graph
xlabel('Time') %Sets a label for the x-axis
ylabel('Signal Amplitude') %Sets a label for the y-axis
set(gca,'FontSize',fS) %Sets font size for graph as defined in priors
set(gca, 'TickDir', 'out') %Sets tick marks on graph to the outside
set(gca, 'LineWidth', lW); %Sets linewidth as defined in priors
subplot(2,3,5)
plot(signal2)
spectrogram(signal2, windowShape, overl, freqRange, fs, 'yaxis')
colormap(jet)
title('Signal 2 Amplitude over Time') %Sets a title for the graph
xlabel('Time') %Sets a label for the x-axis
ylabel('Signal Amplitude') %Sets a label for the y-axis
set(gca,'FontSize',fS) %Sets font size for graph as defined in priors
set(gca, 'TickDir', 'out') %Sets tick marks on graph to the outside
set(gca, 'LineWidth', lW); %Sets linewidth as defined in priors

%Plot signal 3 sine waves and spectrogram
subplot(2,3,3) %Opens a subplot to plot signal 3 in the third of three rows
plot(signal3) %Plots signal 3 sine wave
title('Signal 3 Amplitude over Time') %Sets a title for the graph
xlabel('Time') %Sets a label for the x-axis
ylabel('Signal Amplitude') %Sets a label for the y-axis
set(gca,'FontSize',fS) %Sets font size for graph
set(gca, 'TickDir', 'out') %Sets tick marks on graph to the outside
set(gca, 'LineWidth', lW); %Sets linewidth as defined in priors
subplot(2,3,6)
plot(signal3)
spectrogram(signal3, windowShape, overl, freqRange, fs, 'yaxis')
colormap(jet)
title('Signal 3 Amplitude over Time') %Sets a title for the graph
xlabel('Time') %Sets a label for the x-axis
ylabel('Signal Amplitude') %Sets a label for the y-axis
set(gca,'FontSize',fS) %Sets font size for graph as defined in priors
set(gca, 'TickDir', 'out') %Sets tick marks on graph to the outside
set(gca, 'LineWidth', lW); %Sets linewidth as defined in priors
shg %Show graph

%Determine the makeup (which components it consists of) of each signal by
%visualizing the signal in the time and/or the frequency domain and write
%in a comment what these signal components are.


%% 2 LOY Data

LOYgraph = figure;
sound(signal4, fs2) %YANNY
plot(signal4)
spectrogram(signal4, windowShape2, overl2, freqRange, fs2, 'yaxis')
colormap(jet)
title('Signal 4 Amplitude over Time') %Sets a title for the graph
set(gca,'FontSize',fS) %Sets font size for graph as defined in priors
set(gca, 'TickDir', 'out') %Sets tick marks on graph to the outside
set(gca, 'LineWidth', lW); %Sets linewidth as defined in priors
shg

pause(5)

sound(signal4, fs2*0.8) %Sound 20% slower
%YANNY

pause(5)

sound(signal4, fs2*1.2) %Sound 20% faster
%YANNY



%% 3

% % lsrpTEMP = LSRP; %copy
LSRPCopy = LSRPData; %copy
revCodeItems = [6, 14, 19, 22, 24, 25, 26]; % these are the questions that need to be changed
%scores = 6-scores
%scores(rCodeItems) = 6-scores(rCodeItems);
LSRPData(:, revCodeItems) = 6-LSRPCopy(:, revCodeItems);
%DATA file remains the CORRECT data, it has been edited by the above
%function, lsrpTemp is the old data 

% now going to try to get scores for each px 
tempDATA = LSRPData %made a copy to test
totalScores = []; %compile total scores, here it will be means 
totScores = []; %compile total scores, here it will literally be a sum of scores
newtempDATA = LSRPData %copy
totalScores = mean(double(tempDATA(:, 1:26)), 2)%calculates MEANS
totScores = sum(double(newtempDATA(:, 1:26)), 2) %calculates SUMS

%now gotta clean the data skrrrrrrrrrrtttttttt

cleanDATA = LSRPData %copy of DATA that is cleared of NaNs
%now eliminate NaNs participant wise so the rows get thrown out and the
%numbers are even and correlations can be performed 
[row, column] = find(isnan(cleanDATA))
cleanDATA(row, :) = []

%now re-calculate the means and sums with cleanDATA %uh YUH
cleantotalScores = [] %creates a matrix to compile the total MEAN scores from cleaned data
cleantotScores = [] %creates a matrix to compile the total SUM of scores from cleaned data 
cleantotalScores = mean(double(cleanDATA(:, 1:26)), 2)%calculates MEANS
cleantotScores = sum(double(cleanDATA(:, 1:26)), 2) %calculates SUMS

%visualize data from before and after % what? TUCCI
%figure showing MEANS distribution without being cleaned
figure
histogram(totalScores) %creates histogram
shg

%figure showing SUMS distribution without being cleaned
figure
histogram(totScores)
shg

%visualizing cleaned data 
%figure showing MEANS dist after being cleaned
figure
histogram(cleantotalScores) %creates histogram
shg
%figure showing SUMS distribution after being cleaned
figure
histogram(cleantotScores)
shg

%% 4 PCA section 
%now Imma run da PCA %boiiiiiiiiiiiiiiiiiiiiii

%visualize yr data betch

figure
imagesc(cleanDATA); colormap(jet); colorbar; shg

%now correlational matrix visualization skrrrt skrrrrrrrrt

figure
imagesc(corrcoef(cleanDATA)); colormap(jet); colorbar;shg

%doing actual PCA % yaaaaaaaaaaaaaaaaaaaaaaaaaaaas

[loadings, origDataInNewDimensions, eigVal] = pca(cleanDATA);
varExp = eigVal./sum(eigVal).*100 %Variance explained by the factor

% f The "Scree plot" % yus

eigenValMag = eig(corrcoef(cleanDATA)); %Redoing just the extraction of the eigenvalues from the correlation matrix
figure
bar(1:length(eigenValMag),sortrows(eigenValMag, -1))
title('Scree plot')
line([min(xlim) max(xlim)], [1 1], 'linestyle', '--')


%% 5 

%Separate males and females into separate datasets
%And then permutation test

maleData = find(cleanDATA(:,27) == 1); %find all rows where male
%204 males
femaleData = find(cleanDATA(:,27) == 0); %find all rows where female
%393 females

%Garrett's g
%In real life, always use your entire sample. In this case, we'll overpower
%everything, so let's truncate the sample for educational purposes
% % % truncatedSample = 20
% % % empiricalG = sum(validRATINGS(1:truncatedSample,1) - validRATINGS(1:truncatedSample,3))
%Whatever you pick (difference, ratio, normalized difference or ratio) has
%implications for the mathematical properties of the outcome
%Now that we know the magnitude of the test statistic, the question always
%is: "How likely is that?", be it t, or F or Chi^2 or whatever.
%COmplication: We know how t, F, etc. distributes, we don't know how
%Garrett's G distributes.

% % % %a) Put the ratings into a bigger bucket
% % % distAreaM = cleanData(1:maleData,1); %Put into a distribution area, male data
% % % distAreaF = cleanData(1:femaleData,1); %Put into a distribution area, female data
% % % distAreaComb = [distAreaM distAreaF]; %Stack the data vertically
% % % sampSizeM = length(cleanData(1:maleData,1)); %1 sample size for male data
% % % sampSizeF = length(cleanData(1:femaleData,1)); %1 sample size for female data
% % % sampSizeComb = length(distAreaComb); %Combined sample size

distAreaComb = cleanDATA;
sampSizeComb = length(distAreaComb);


%b) Shuffling randomly (drawing without replacement, or randomly permute)
shuffleIndices = randperm(sampSizeComb); %Gets us a list of indices from 1 to length of sampSizeComb
%Reach into the male and female data of combined data twice
randData1 = distAreaComb(shuffleIndices(1:sampSizeComb)); %First half
randData2 = distAreaComb(shuffleIndices(sampSizeComb+1:sampSizeComb)); %Second half

% % % resamp = sum(randData1 - randData2)



%Now that we established that this works, we need to do it again, lots of
%times, N times
N = 1e5;
nullDistLSRP = nan(N,1); %Preallocate! To save time
for ii = 1:N
    shuffleIndices = randperm(sampSizeComb); %Gets us a list of indices from 1 to length of biggerBucket
    randData1 = distAreaComb(shuffleIndices(1:sampSizeComb)); %First half
    randData2 = distAreaComb(shuffleIndices(sampSizeComb+1:sampSizeComb)); %Second half
    %nullDistLSRP(ii, 1) = sum(randData1 - randData2); %Capture the iith one
end



% % % %2) How does Garrett's g distribute, given the null hypothesis
% % % %a) Put the ratings into a bigger bucket
% % % biggerBucket = [validRATINGS(1:truncatedSample,1); validRATINGS(1:truncatedSample,3)]; %Stack the ratings vertically
% % % n1 = length(validRATINGS(1:truncatedSample,1)); %1 sample size
% % % n2 = length(biggerBucket); %Combined sample size
% % % 
% % % %b) Shuffling randomly (drawing without replacement, or randomly permute)
% % % shuffleIndices = randperm(n2); %Gets us a list of indices from 1 to length of biggerBucket
% % % %Reach into the bigger bucket of combined ratings twice
% % % randomizedRatings1 = biggerBucket(shuffleIndices(1:n1)); %First half
% % % randomizedRatings2 = biggerBucket(shuffleIndices(n+1:n2)); %Second half
% % % 
% % % resampledG = sum(randomizedRatings1 - randomizedRatings2)












%no variance
%mann-whitney u ttest



















