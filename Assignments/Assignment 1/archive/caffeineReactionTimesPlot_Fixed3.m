%% Caffeine Reaction Times Plot %%

% Project Summary:
    % This project analyzed the relationship between caffeine and reaction
    % times. Three participants were exposed to three different levels of
    % caffeine (in milligrams): 400 mg, 200 mg, and a control participant
    % that was not exposed to any caffeine. 
    
% Script Summary:
    % The purpose of this script is to import the data gathered from the
    % experiment described above, remove invalid trials, and then plot 
    % the valid data into a trace plot. This trace plot will serve as the
    % only output.

% Author:           Mystery (Wo)Man        
% Contact Email:    mystery(wo)man@nyu.edu
% Date Created:     06/08/2019 (mm/dd/yyyy)

% Revision History (date format: mm/dd/yyyy)

% Revision #: Original
% Date              % Author        % Description
% 06/08/2019        % M. (Wo)Man    % Script was created

%% 0 ~ Loading the Data & Intializing Variables

% 0.a ~ Tabula Rasa
clear all   % Clear memory
close all   % Close open figures
clc         % Clear command window

% 0.b ~ Load Data into Workspace
load('Assignment1_data.mat')

% The Variables Being Loaded:
    % Participant response times (in ms) when exposed to different
    % conditions are captured in the below variables:
        % data_caffeine_200     = response times when exposed to 200mgs of caffeine 
        % data_caffeine_400     = response times when exposed to 400mgs of caffeine
        % data_caffeine_control = response times from the control group
    % In order to control for participant anticipation effects, the
    % experimenter randomized the onset of stimulus (aka 'trigger times'). This 
    % measure (in ms) was captured in the below variables:
        % stimTime_caffeine_200     = stimulus presentation delay for 200mg condition
        % stimTime_caffeine_400     = stimulus presentation delay for 400mg condition
        % stimTime_caffeine_control = stimulus presentation delay for the control condition

% 0.c ~ Set up prior variables
numTrials   = 300       ;   % The total amount of trials

% 0.d ~ Graphing Variables - Properties for the final plot
lW          = 1         ;   % Line width for each trace line in final graph
fS          = 14        ;   % General fontsize for final graph
startPoint  = 0         ;   % Start point for x-axis in final graph
xhair       = 5         ;   % x-axis graphing property to add space between plotted lines and graph edge
yhair       = 250       ;   % y-axis graphing property to add space between plotted lines and graph edge

%% 1 Compute Reaction Times (per trial and participant)

% As the experimenter randomized the onset of stimulus
% presentation, sometimes the participant "jumped the gun" reacting
% before the stimulus had even been presented. By removing the the
% stimulus onset time, we can see the participants real reaction times.

% 1.a ~ General Reaction Time (RT) Variable Form
    % reactionTimeXXX = overall response time (for given trial) - time delay of stimulus trigger  

reactionTime200     = data_caffeine_200 - stimTime_caffeine_200 ;   % For 200mg participant/condition
reactionTime400     = data_caffeine_400 - stimTime_caffeine_400 ;   % For 400mg participant/condition
reactionTimeControl = data_control - stimTime_control           ;   % For control participant/condition

%% 2 Identifying Valid Trials

% Because participants may have responded before the presentation of the
% stimulus, we define invalid responses as those that are negative in
% value (after removing the onset delay). Thus, this section of the script 
% pulls out the reaction times that are positive in value and places them 
% into a new data structure.

% 2.a ~ Create a loop to place the valid trials into a new data structure.

% Explaining the below loop step-by-step: 
    % 0. Before the loop, create a matrix ('conditionMatrix') which holds all
    % observed trials. Rows = Trials. Columns = different conditions/participants.
    % 1. Start a 'for' loop which iterates over this matrix - i.e. each step is
    % one of the columns (participants/conditions) in the matrix.
    % 2. Create an 'if' statement within this loop. This statement selects the
    % condition (column) of the matrix.
    % 3. Once the 'if' condition is met, the following line creates a logical
    % array of 1's and 0's and uses it as an indexing array on the column of
    % trials. I.e. - it places only the positive reaction times into the new
    % data structure.

conditionMatrix = [reactionTime200, reactionTime400, reactionTimeControl];  % Create a matrix to iterate over which holds all observed trials. Rows = Trials. Columns = different conditions/participants.

for cc = conditionMatrix                    % Iterate over each condition
   if cc == reactionTime200                 % If reactionTime200
       validTrials200 = cc (cc > 0);        % Then pull out only the positive (valid) reaction times
    
   elseif cc == reactionTime400             % If reactionTime400
       validTrials400 = cc (cc > 0);        % Then pull out only the positive (valid) reaction times
  
   else                                     % If reactionTimeControl
       validTrialsControl = cc (cc > 0);    % Then pull out only the positive (valid) reaction times
   end
end

%% 3 Check The Data

% In order to verify that our newly created "validTrials" variables are
% correct, we implement a check. In order to do this we utilize a simple
% ground truth.

% 3.a ~ Ground Truth = There should be no negative values held in the
% "validTrials" variables. 
    % To check this, we simply pass a logical test on each variable (are
    % there any negative values in the variable) and then sum take the sum
    % of the entire logical array. The result should deliver a value of
    % zero if there are no negative values (i.e. the invalid trials have
    % been removed).
    
check1 = sum(validTrials200 < 0)        ;
check2 = sum(validTrials400 < 0)        ;
check3 = sum(validTrialsControl < 0)    ;

% 3.b ~ Create 'If' statements which display user friendly output confirming 
% whether or not the above check was successful:

if check1 == 0 && check2 == 0 && check3 == 0    % If all checks  = 0 (as they should, then display the below message.)
    disp('You''re check has confirmed that the "validTrials" variables include only valid trials.')
else                                            % If not, display the message below.
    disp('Please recheck the creation of the "validTrials" variables, there seems to be a problem.')
end
    
%% 4 Plot Valid Data
% Now that valid reaction time (rt) data has been separated from invalid
% data, and we have double checked it has been done properly, this data
% will be plotted.

% 4.a ~ Open a canvas

rtFigure = figure ;  % Open a figure named "rtFigure"
hold on              % Keep this figure open

% 4.b ~ Create a "Trials Variable" (serves as the x-axis values for all plots)

% Create a "trials variable" that is the correct number of trials - not
% 300 - as we have removed some invalid observations. NOTE: All participants
% had an equal number of invalid trials, so only one trial variable is
% necessary.

validNumTrials = 1:length(validTrials200)               ; % Trials variable 

% 4.c ~ Create Trace Lines and set their properties

plot200mg               = plot(validNumTrials, validTrials200)      ; % Plot valid trials for the 200 mg condition
plot200mg.Color         = 'b'                                       ; % Make the line blue
plot200mg.LineWidth     = lW                                        ; % Set line width to 1
plot400mg               = plot(validNumTrials, validTrials400)      ; % Plot valid trials for the 400 mg condition
plot400mg.Color         = 'r'                                       ; % Make the line red
plot400.LineWidth       = lW                                        ; % Set line width to 1
plotControl             = plot(validNumTrials, validTrialsControl)  ; % Plot valid trials for control condition
plotControl.Color       = 'k'                                       ; % Make the line black
plotControl.LineWidth   = lW                                        ; % Set line width to 1

% 4.d ~ Graph customizations

xlabel('Valid Trials')                                          ;   % X-axis label
ylabel('Reaction Time (ms)')                                         ;   % Y-axis label
title('Reaction Time as a Function of Caffeine Consumption')    ;   % Title of graph
legend( '200mg', '400mg', 'Control', 'Location', 'EastOutside') ;   % Legend description and location
xlim([startPoint length(validTrials200) + xhair])               ;   % Limit of x-axis = 0 to 277
ylim([startPoint max(validTrialsControl) + yhair])              ;   % Limit of x-axis = 0 to 4297 (4297 = 250 ms greater than the largest recorded observation)
set(gca,'Xtick',startPoint:25:(length(validTrials200) + xhair)) ;   % Set x-axis tic marks. 0 to 275 (increasing by 25) 
set(gca,'FontSize', fS)                                         ;   % Setting font size for all graph labels to 14
set(gca,'TickDir', 'out')                                       ;   % Setting tick marks to be outside of graph

%% 5 Save All Variables

savefig(rtFigure, 'validTrialsFigure.fig')  ; % Save a figure file
save('validTrialsWorkspace.mat')            ; % Save the workspace






