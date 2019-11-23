%% Caffeine Reaction Times Plot
% This project analyzed the relationship between caffeine and reaction
% times utilizing an experimental manipulation. 

% The purpose of this script is to import that data gathered, restructure
% it to be of more value and then 

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

%% 0 ~ Loading the Data & Intializing Variables

% 0.a ~ Tabula Rasa
clear all   %Clear memory
close all   %Closes open figures
clc         %Clear command history

% 0.b ~ Load Data into the Workspace
load('Assignment1_data.mat')

% The Variables Being Loaded:
    % Participant repsonse times (in ms) when exposed to different
    % conditions are captured in the below variables (loaded via the above
    % line of code - line 23):
        % data_caffeine_200     = response times when exposed to 200mgs of caffeine 
        % data_caffeine_400     = response times when exposed to 400mgs of caffeine
        % data_caffeine_control = response times from the control group
    % Trigger times (a.k.a. time delay (in ms) from trial start to stimulus onset)
    % In order to control for participant anticipation effects the
    % experiment randomized the onset of stimulus control. This measure (in
    % ms) was captured in the below variables - also loaded by the above
    % line of code (line 23):
        % stimTime_caffeine_200     = stimulus presentation delay for 200mg condition
        % stimTime_caffeine_400     = stimulus presentation delay for 400mg condition
        % stimTime_caffeine_control = stimulus presentation delay for the control condition

% 0.c ~ Variables to identify valid trials (all conditions were exposed to the
% same # of trials.
numTrials = 300; %The total amount of trials

% 0.d ~ Graphing Variables - Properties for out plot
lW = 1          ;   % Line width for each line of graph
fS = 14         ;   % General fontsize for graph
startPoint = 0  ;   % Start point for x-axis (valid trials)
xhair = 5       ;   % x axis limit property to add space between plotted lines and graph edge
yhair = 250     ;   % y axis limit property to add space between plotted lines and graph edge

%% 1 Compute reaction times (per trial and participant)

% 1.a ~ General Reaction Time (RT) Variable Form
% reactionTimeXXX = overall response time (for given trial) - time delay of stimulus trigger  

reactionTime200     = data_caffeine_200 - stimTime_caffeine_200 ;   % For 200mg participant/condition
reactionTime400     = data_caffeine_400 - stimTime_caffeine_400 ;   % For 400mg participant/condition
reactionTimeControl = data_control - stimTime_control           ;   % For control participant/condition

%% 2 Identifying valid trials by removing negative trials

% 2.a Create a loop to place the valid trials into a new data structure.

% Explaining the below loop step-by-step: 
% 0. Before the loop, create a matrix ('conditionMatrix') which holds all
% observed trials. Rows = Trials. Columns = different conditions/participants.
% 1. Start a 'for' loop which iterates over this matrix - i.e. each step is
% one of the columns in the matrix.
% 2. Create an 'if' statement within this loop. This statement selects the
% condition (column) of of the matrix.
% 3. Once the 'if' condition is met, the following line creates a logical
% array of 1's and 0's and uses it as an indexing array on the column of
% trials. I.e. - it places only the positive reaction times into the new
% data structure.

conditionMatrix = [reactionTime200, reactionTime400, reactionTimeControl];

for cc = conditionMatrix
   if cc == reactionTime200             % If reactionTime200
       validTrials200 = cc (cc > 0);    % then pull out only the positive (valid) reaction times (trials)
    
   elseif cc == reactionTime400         % If reactionTime400
       validTrials400 = cc (cc > 0);    % then pull out only the positive (valid) reaction times (trials)
  
   else                                 % If reactionTimeControl
       validTrialsControl = cc (cc > 0);% then pull out only the positive (valid) reaction times (trials)
   end
end


%% 3 Plot valid data
% Now that legitimate reaction time (rt) data has been separated from invalid
% data, it must be plotted.

rtFigure = figure;  % Open a figure
hold on             % Keep this figure open

% Create a trials variable that is the correct number of trials (not 300)
% as we have removed some invalid observations. NOTE: All participants had
% an equal number of invalid trials, so only one trial variable is
% necessary.

validNumTrials = 1:length(validTrials200)               ; % Trials variable that will serve as the 'x' axis for all trace lines

% Plot Valid Trials
plot200mg = plot(validNumTrials, validTrials200)        ; % Plot valid trials for 200mg condition
plot200mg.Color = 'b'                                   ; % Make the line blue
plot200mg.LineWidth = lW                                ; % Set line width to 1
plot400mg = plot(validNumTrials, validTrials400)        ; % Plot valid trials for 400mg condition
plot400mg.Color = 'r'                                   ; % Make the line red
plot400.LineWidth = lW                                  ; % Set line width to 1
plotControl = plot(validNumTrials, validTrialsControl)  ; % Plot valid trials for control condition
plotControl.Color = 'k'                                 ; % Make the line black
plotControl.LineWidth = lW                              ; % Set line width to 1

% Graph customizations
xlabel('Valid Trials') ;                                            % X-axis label
ylabel('Reaction Time per Trial') ;                                 % Y-axis label
title('Reaction Time as a Function of Caffeine Consumption') ;      % Title of graph
legend( '200mg', '400mg', 'Control', 'Location', 'EastOutside') ;   % Legend description and location
xlim([startPoint length(validTrials200) + xhair])                   % Limit of x-axis
ylim([startPoint max(validTrialsControl) + yhair])                  % Limit of x-axis

%Setting x-axis tick marks to start at 0, end at 272, and occur in
%increments of 25.
set(gca,'Xtick',startPoint:25:(length(validTrials200) + xhair))
%Setting x-axis tick mark labels to start at 0, end at 272, and occur in
%increments of 25.
set(gca,'FontSize', fS)     % Setting font size for all graph labels
set(gca,'TickDir', 'out')   % Setting tick marks to be outside of graph


%% Save the Program

save('validTrialsWorkspace.mat')





