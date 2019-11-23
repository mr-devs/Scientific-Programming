%Assignment 1
%In this assignment, we analyze and plot data from a learning experiment
%with three participants (one with 200mg of caffeine, one with 400mg of
%caffeine, and one as a control).
%First, we compute the reaction time (dependent variable) per participant
%in each trial (200mg of caffeine, 400mg of caffeine, and control).
%Second, we identify valid trials by removing negative values from
%each participant's data.
%Finally, we plot the valid data via line graph, comparing all groups to
%each other. The black line indicates control group, blue line is 200mg
%caffeine, and red is 400mg caffeine.
%Dependencies/assumptions: NaN
%6/6/19

%% 0 Initialization ("Birth")
%Step 1: "Blank slate"
clear all %Clear memory
close all %Closes open figures
clc %Clear command history

%Step 2: Load data
load('Assignment1_data.mat')

%Step 3: Priors: List all variables used in the code
%Variables to compute reaction times
overallRespTime200 = data_caffeine_200; %Define overall response time for 200mg participant
onsetTimeofStim200 = stimTime_caffeine_200; %Define onset time of stimulus for 200mg participant
overallRespTime400 = data_caffeine_400; %Define overall response time for 400mg participant
onsetTimeofStim400 = stimTime_caffeine_400; %Define onset time of stimulus for 400mg participant
overallRespTimecontrol = data_control; %Define overall response time for control participant
onsetTimeofStimcontrol = stimTime_control; %Define onset time of stimulus for control participant

%Variables to identify valid trials
amountofTrials200 = 300; %The total amount of trials in the 200mg participant
amountofTrials400 = 300; %The total amount of trials in the 400mg participant
amountofTrialsControl = 300; %The total amount of trials in the control participant
validTrials200 = []; %Empty space for the valid trials for the 200mg participant
validTrials400 = []; %Empty space for the valid trials for the 400mg participant
validTrialsControl = []; %Empty space for the valid trials for the control participant

%Graphing variables
lW = 2; %Line width for each line of graph
fS = 16; %General fontsize for graph
startPoint = 0; %Start point for x-axis (valid trials)
endPoint = 272; %End point for x-axis (valid trials)
%% 1 Compute reaction times (per trial and participant)
%Reaction time = overall response time (for given trial) - onset time of stim

reactionTime200 = overallRespTime200 - onsetTimeofStim200 %Reaction time for 200mg participant
reactionTime400 = overallRespTime400 - onsetTimeofStim400 %Reaction time for 400mg participant
reactionTimeControl = overallRespTimecontrol - onsetTimeofStimcontrol %Reaction time for control participant

%% 2 Identifying valid trials by removing negative trials
%Nested loop: Initializing new variable of trialNum(per participant) and
%setting it equal to 1 through the amount of trials in each condition to go
%through all trials.
%Find all reaction times greater than 0 and create new dataset with
%validTrials(per participant) without the negative trials.

%Identifying valid trials for 200mg participant
for trialNum200 = 1:amountofTrials200
    if reactionTime200(trialNum200) > 0
        validTrials200 = [validTrials200 ; reactionTime200(trialNum200)]
    end
end

%Identifying valid trials for 400mg participant
for trialNum400 = 1:amountofTrials400
    if reactionTime400(trialNum400) > 0
        validTrials400 = [validTrials400 ; reactionTime400(trialNum400)]
    end
end

%Identify valid trials for control participant
for trialNumControl = 1:amountofTrialsControl
    if reactionTimeControl(trialNumControl) > 0
        validTrialsControl = [validTrialsControl ; reactionTimeControl(trialNumControl)]
    end
end

%% 3 Plot valid data
%Set a handle for the figure and open a blank, white canvas.

allTrials = figure; %Open a canvas to draw on, explicitly, with handle
set(allTrials, 'Color', 'w') %Open as a white background
hold on %If you don't hold on, the new plotting command will erase what is
%currently on the figure

%Plot all three participant's data together on a graph
%Each participant's line of data is plotted from 1(startPoint) to the
%length of the valid amount of trials and color coded. The line width is
%also specified to be 2 pixels.
allTrials = plot(1:length(validTrials200), validTrials200, 'Color', 'b', 'LineWidth', lW)
allTrials = plot(1:length(validTrials400), validTrials400, 'Color', 'r', 'LineWidth', lW)
allTrials = plot(1:length(validTrialsControl), validTrialsControl, 'Color', 'k', 'LineWidth', lW)

%Graph customizations
xlabel('Valid Trials') %X-axis label
ylabel('Reaction Time per Trial') %Y-axis label
title('Reaction Time vs. Valid Trials') %Title of graph
legend('200mg', '400mg', 'Control', 'Location', 'NorthEastOutside') %Legend description and location
xlim([startPoint endPoint]) %Limit of x-axis
%Setting x-axis tick marks to start at 0, end at 272, and occur in
%increments of 16.
set(gca,'Xtick',startPoint:16:endPoint)
%Setting x-axis tick mark labels to start at 0, end at 272, and occur in
%increments of 16.
set(gca,'XtickLabel',(startPoint:16:endPoint))
set(gca,'FontSize', fS) %Setting font size for all graph labels
set(gca,'TickDir', 'out') %Setting tick marks to be outside of graph
shg %Show graph

%% Fin







