% Header
% Who-Secret
% When-6/7/2019
% Dependencies/assumptions-None
% What's the script trying to do-plotting data of 3 participants under different amount of caffeine influence in a
% reaction time experiment

%% 0 Initialization
clear all %Clear memory
close all %Close all open figures
clc %Clear command history

load('Assignment1_data') %Load dataset

%% 1 Compute reaction time for each trial and participant

reactionTimes_caffeine_200 = data_caffeine_200 - stimTime_caffeine_200 %Calculate reaction time for participant1
reactionTimes_caffeine_400 = data_caffeine_400 - stimTime_caffeine_400 %Calculate reaction time for participant2
reactionTimes_control = data_control - stimTime_control %Calculate reaction time for participant3

%% 2 Indentify valid trials for each participant

%2a Priors
startPoint = 1 %Start of trials
pp = 1 %Participant
numTrials = 300 %# of trials for each participant
cutoff = 0 %Cutoff for when a trial is considered valid

%2b Valid trials for participant1
for tt = startPoint:numTrials %Go through all trials
    if reactionTimes_caffeine_200(tt,pp) > cutoff %When the trial is considered valid
        validTrials_caffeine_200(tt,pp) = reactionTimes_caffeine_200(tt,pp) %Distinguish valid/invalid trials in a new matrix
    end %Until end
end %Until end

validTrials_caffeine_200(validTrials_caffeine_200 == 0) = [] %Delete 0(invalid trials) in the new matrix

%2c Valid trials for participant2
for tt = startPoint:numTrials %Go through all trials
    if reactionTimes_caffeine_400(tt,pp) > cutoff %When the trial is considered valid
        validTrials_caffeine_400(tt,pp) = reactionTimes_caffeine_400(tt,pp) %Distinguish valid/invalid trials in a new matrix
    end %Until end
end %Until end

validTrials_caffeine_400(validTrials_caffeine_400 == 0) = [] %Delete 0(invalid trials) in the new matrix

%2d Valid trials for participant3
for tt = startPoint:numTrials
    if reactionTimes_control(tt,pp) > cutoff %When the trial is considered valid
        validTrials_control(tt,pp) = reactionTimes_control(tt,pp) %Distinguish valid/invalid trials in a new matrix
    end %Until end
end %Until end

validTrials_control(validTrials_control == 0) = [] %Delete 0(invalid trials) in the new matrix


%% 3 Plot

DC = figure %Name figure

%3a Plotting participant1
Superman = plot(validTrials_caffeine_200) %Plot participant1

Superman.Color = [0 0.4470 0.7410] %Change the line color to blue

hold on %Keep the line for participant1


%3b Plotting participant2
Wonderwoman = plot(validTrials_caffeine_400) %Plot participant2

Wonderwoman.Color = 'r' %Change the line color to red

hold on %Keep the line for participant1


%3c Plotting participant3
Batman = plot(validTrials_control) %Plot participant3

Batman.Color = 'k' %Change the line color to black


%3d General modifications
xlabel('Valid Trial') %Label x-axis
ylabel('Reaction Time') %Label y-axis
title('Reaction Time by Trial') %Add title to the figure
set(gca,'TickDir','out') %Change the direction of tickmarks outwards
box off 
legend([Superman,Wonderwoman,Batman],{'Caffeine200', 'Caffeine400','Control'},'Location','SouthEastOutside') %Add traces for each line

shg %Show figure




