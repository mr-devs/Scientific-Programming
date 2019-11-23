%% This script shows how to create a program to record psychophysical data.
%Hypothesis: Perceived color of the stimulus varies as a function of some 
%physical image characteristic such as brightness.
%The programmer creates 11 different versions of the same stimuli varying
%in brightness. These different versions are then placed arbitrarily side 
%by side with the original stimuli with a focal point in the center. 
%Each of these 11 versions will be run 10 times in random order for a total 
%of 110 trials.
%The participant will indicate which version of the dress appears more
%"blue" by pressing a key. 
%Responses of the particiapnts along with their reaction times are recorded
%and saved. 
%Finally the mean proportion of the "blue" choices as  function of
%condition are calculated and plotted as a psychometric curve. 

%This script was created on 06/20/2019 for the Coding Class as Assignment 2
%Created by Amateur Coder, amateurcoder01@nyu.edu

%% 0 Initialization

clear all %Clears memory
close all %Closes all figures
clc %Clears command window

%% Loading the stimuli:
%Assumption is that the grader will have the stimuli in the matlab
%workspace already loaded
dress = imread ('thedress.jpg'); %Loading the dress and assigning it to the matrix "dress"

%% Priors:

numConditions = 11; %We want 11 versions of the dress
brightFactor = -0.24; %Initializing the brightness we want to start with
brightValue = 0.34; %This is the value by which we want our brightness to increase by 
numPresented = 10; %This is the number of times the conditions will be presented

%% Changing brightness of the stimuli:

for ii = 1:numConditions %This will run the loop from 1 to 11 versions of the dress
    modifiedDress(:,:,:,ii) = dress .* (brightFactor + brightValue * ii); %Creating a matrix which will store all 11 versions of the dress with increasing brightness as the loop runs along
end %For loop ends

%% Modifying the stimuli

for ii = 1:numConditions %Running the loop from 1 to 11
crossSize = 10; %Defining size of the cross
crossThickness = 2; %Defining thickness of the cross
chanceDress = rand; %Defining chance of dress to be either on left or right as a random function

if chanceDress <= 0.5 %Check when chance of the dress is less than or equal to 50% or 0.5
    
    biggerMatrix(:,:,:,ii) = [dress modifiedDress(:,:,:,ii) ]; %bigger matrix will have original dress on left and modified dress on right
else  %If chance of dress is more than 50% or more than 0.5
   
    biggerMatrix(:,:,:,ii) = [modifiedDress(:,:,:,ii) dress ]; %Bigger matrix will have modified dress on left and original dress on right
end  %If loop ends
    
%Creating a red cross in the center of the image:

sizeMatrix = size(biggerMatrix(:,:,:,ii)); %This is the size
temp1 = 1:sizeMatrix(1); %Vector made out of dimension 1
centerRow = round(median(temp1)); %Median column
temp2 = 1:sizeMatrix(2); %Vector made out of dimension 2
centerColumn = round(median(temp2)); %Median row
%Rows
biggerMatrix(centerRow-crossSize:centerRow+crossSize, ... 
    centerColumn-crossThickness:centerColumn+crossThickness,1,ii) = 255; %Make crossrows red
biggerMatrix(centerRow-crossSize:centerRow+crossSize, ... 
    centerColumn-crossThickness:centerColumn+crossThickness,2:3,ii) = 0; %Make crossrows red

%Columns
biggerMatrix(centerRow-crossThickness:centerRow+crossThickness, ... 
    centerColumn-crossSize:centerColumn+crossSize,1,ii) = 255; %Make crosscolumns red
biggerMatrix(centerRow-crossThickness:centerRow+crossThickness, ...
    centerColumn-crossSize:centerColumn+crossSize,2:3,ii) = 0; %Make crosscolumns red

end %Ending the for loop

%% The Experiment- Section 1

%This section deals with setting the priors specifically for the
%experiment.

order = repmat(1:numConditions,1,numPresented); %This is the "orginial" order, with our number of conditions and number of times it is presented
randOrder = order(randperm(length(order))); %This will create a random order of the experiment
numTrials = 110; %Length of our experiment
results = nan(numTrials,2); %This is where our results will go



%% The Experiment - Section 2
%An introduction display screen for the experiment

%The programmer wants to have an introduction display screen to instruct
%the particpants/users what the experiment wants them to do.

counter = 0; %Initializing counter as 0
 
instructions = {'You will be presented with a series of pair of images' ...
    'that will be presented side by side.'... 
    'Please indicate which image you believe to be more BLUE' ...
    'the Q key represents the dress on the left side '... 
    'and the P key represents the dress on the right side' ...
    'Press "b" to begin!'}; %What we want to display on the screen

while counter == 0; %Condition stands true while counter is 0
    if counter == 0; %When counter is 0
        introFigure = figure; %Naming our figure
        beginingText = text (0.5, 0.5, instructions); %Defining the text details
        beginingText.FontSize = 15; %Defining font size
        beginingText.HorizontalAlignment = 'center'; %Defining position of the text
        introFigure.Color = [1 1 1]; %Defining color of the figure
        beginingText.Color = 'r'; %Defining color of the text
        axis off; %takes axis off
        hold on; 
        pause; %pause till the user gives an input
        if strcmp (introFigure.CurrentCharacter, 'b') == 1; %If user pressed the "valid" key
            counter = counter + 1; %updating the loop
        end 
        close all ; %Close the figure after receiving input
    end 
end
%% The Experiment - Section 3

%In this section, we create the script for how the experiment runs and how
%it saves and records the responses.

experiment = figure('MenuBar', 'none','ToolBar', 'none'); %naming the igure and commanding it to be full screen
for ii = 1:numTrials %for our total 110 dress trials
tic %starts the timer
image(biggerMatrix(:,:,:,randOrder(ii))) %Randomised order of the arbitrarily paired images are called
axis equal %makes axis equal
axis off %takes axis off
%pause %waits for user input
   % lastPressed = get(gcf,'CurrentCharacter'); %Get the last key the user pressed
    
    results(ii,2) = toc; %Save reaction time in column 2
    
    if chanceDress <= .5
        
        results(ii,1) = 0 ;
    else 
        results(ii,1) = 1 ; %Count as 1

        
    %Determining whether the user decided which dress seemed
    %more "blue" by pressing 'p' or 'q' 
    
%     if (strcmp(lastPressed,'q') && (chanceDress<=0.5)) || (strcmp(lastPressed,'p') && (chanceDress>0.5)) %== 1 %Check if q was pressed
%         results(ii,1) = 0 %Count as 0 
%        
%         
%     elseif (strcmp(lastPressed,'p') && (chanceDress<=0.5)) || (strcmp(lastPressed,'q') && (chanceDress>0.5))% == 1 %If q was not pressed, check if p was pressed
%         results(ii,1) = 1 %Count as 1
%        
%     else
%         results(ii,1) = nan %If neither was pressed, result will show nan
        
    end
end

% rt = toc; %Reaction time equals toc

%% Organising the results and plotting data

sortedResults = nan(numPresented,numConditions); %This is a pre-allocated results matrix. Columns are conditions, rows are observations for that condition

for ii = 1:numConditions %For all our version of dress from 1 to 11
    sortedResults(randOrder(ii)) = results(randOrder(ii)); %Sorted results would include results of our randomly assigned order responses
end

meanResults = mean(sortedResults,'omitnan'); %Calculate mean proportion and omit nans

%% Plotting the curve

psychometricCurve = figure %naming the figure
plot(1:numConditions,meanResults) %defining our plot
title('Perceived color of the stimuli varying as a function of brightness') %giving a title
ylim([0,1]) %setting the limit of y axis
xlabel('Brightness level of Modified Dresses') %defining the x label
ylabel('Proportion Responding Blue') %defining the y label
set(gca,'Tickdir','out') %tickmarks outside
box off %box off to make a neat graph

%% Saving the workspace variables

save('Assignment2.mat') %Saves the workspace
