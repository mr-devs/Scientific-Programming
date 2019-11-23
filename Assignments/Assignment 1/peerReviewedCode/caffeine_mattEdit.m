% Script to perform analysis on effect of caffeine on response time.
% Specifically to graph the data of 3 subjects as they respond to stimuli
% while on different levels of caffeine. The 3 conditions of the indepedent
% variable are no caffeine, 200mg of caffeine, and 400 mg of caffeine. The
% depedent variable is response time to stimul in ms.

% June 10, 2019

%% 0 Initializing
%Assuming the minimum valid reaction time must be more than 0 (0 being when
%the stimulus occurred)
minTime=0 %Setting minimum reaction time to 0

%% 1 Load data into workspace

clear all
clc

load('Assignment1_data.mat') %Loading the data from where it is stored on the computer

%% 2 Compute reaction times for each trial
%Subtracting stimulation time from total time of the trial to get the
%reaction time.

react_caffeine_400 = data_caffeine_400 - stimTime_caffeine_400; % Calculating reaction time of those on 400mg of caffeine
react_caffeine_200 = data_caffeine_200 - stimTime_caffeine_200; % Calculating reaction time of those on 200mg of caffeine
react_control = data_control - stimTime_control; %Calculating reaction time of control group on no caffeine

%% 3 Indentify the valid trials by dropping negative reaction times

valid_reaction_caffeine_400 = react_caffeine_400(react_caffeine_400>minTime); %Identifying valid trials from the 400mg group and placing them in a new data structure
valid_reaction_caffeine_200 = react_caffeine_200(react_caffeine_200>minTime); %Identifying valid trials from the 200mg group and placing them in a new data structure
valid_reaction_control = react_control(react_control>minTime); %Identifying valid trials from the control group and placing them in a new data structure

%% 4 Plot the data of the three participants in one graph

caffeineReaction = figure %labelling the figure
xlabel('valid trials') %Adding title to the X-axis
ylabel('reaction time (ms)') %Adding title to Y-axis
title('Reaction Time by Level of Caffeine Ingestion') % Adding title to the graph
hold on %Keeping the above items active for the following processes
F=plot(valid_reaction_caffeine_400); %Plotting the valid reactions of the 400mg group and labeling that line "F" for "Four hundred"
hold on %Keeping the above items active for the following processes
T=plot(valid_reaction_caffeine_200); %Plotting the valid reactions of the 200mg group and labeling that line "T" for "Two hundred"
hold on %Keeping the above items active for the following processes 
C=plot(valid_reaction_control);  %Plotting the valid reactions of the control group and labeling that line "C" for "Control"
set(gca, 'TickDir', 'out') %Making sure the tickmarks correspond to data ink
box off; %Making sure the box correspond to data ink
F.Color = 'r'; %Setting the 400mg group line "F" to be displayed in the color Red
T.Color = 'b'; %Setting the 200mg group line "T" to be displayed in the color Blue
C.Color= 'k'; %Setting the control group line "C" to be displayed in the color black
legend ([C F T], {'Control', '400mg', '200mg'}, 'Location', 'SouthEastOutside') %Adding a legend to label the lines
save('ValidTrials')
