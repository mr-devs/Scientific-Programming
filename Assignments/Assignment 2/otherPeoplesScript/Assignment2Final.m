%% Intoduction to my script:
%This is Assignment 2 for Scientific Programming Summer 2019. The purpose
%of this code is to load an image of a dress, create several versions of it
%that vary in brightness, and present these to the participant,
%side-by-side. The participant will indicate which dress looks more blue
%and this data will be recorded and presented in a graph, plotting Proportion 
%of Participants Indicating the Dress is "Blue-er" by Dress Brightness.
%Dependencies/Assumptions: This script assumes that the reader has access
%to 'thedress.jpg' and it is loaded to MATLAB before running the code. **If
%you have not done this please do it now, prior to beginning.**
%Name: ****
%Contact info: ******
%June 15, 2019

%% Initialization 
%Step 1: "Blank Slate"
clear all %Clear memory
close all %close all figures
clc %clear command history

%% Step 2: Priors
%PLEASE NOTE: TO MAKE THINGS CLEARER I HAVE CHOSEN TO KEEP SOME PRIORS CLOSER TO THE LOOPS THEY APPLY TO
rng('shuffle'); %Setting the seed to 'shuffle' to ensure numbers are actually random
dress = imread('thedress.jpg'); %Load in the dress, assign it to matrix "dress"
brightValue = 25;%The value by which I adjust the brightness of the dress
fS = 20; %font size for my welcome image

%% Welcome message and instructions
 
welcomescreen = figure; %Creating a figure, calling it welcome screen
welcome = text(0.5,0.6,'Howdy!'); %The text that will be displayed
welcome1 = text(0.5,0.5,'Thank you for participating in this study. On the following screens you will see several images of two side-by-side dresses.');
welcome2 = text(0.5,0.4,'Please indicate which is more blue by pressing "Q" if the left dress looks more blue and pressing "P" if the right looks more blue.');
welcome3 = text(0.5,0.3,'Press any key to continue!');
axis off
welcome.FontSize = fS; %Setting the size of font for each line of text
welcome1.FontSize = fS; 
welcome2.FontSize = fS; 
welcome3.FontSize = fS; 
welcome.HorizontalAlignment = 'center'; %Centering the message
welcome1.HorizontalAlignment = 'center'; 
welcome2.HorizontalAlignment = 'center'; 
welcome3.HorizontalAlignment = 'center';
welcomescreen.Color = 'w'; %Setting the background to be white
welcome.Color = 'b';
welcome1.Color = 'b'; %Setting text color to be blue
welcome2.Color = 'b';
welcome3.Color = 'b';
screensize = get(0,'ScreenSize');%Makes the message full-screen
set(gcf,'Position',screensize);
pause %pauses until a key is pressed
close(welcomescreen)%closes image when any key is pressed

%% Creating 11 versions of the dress that differ in overall brightness level
brightDress1 = dress + brightValue;%Creating 11 dresses with brightness adjusted
brightDress2 = dress + (2*brightValue);
brightDress3 = dress + (3*brightValue);
brightDress4 = dress + (4*brightValue);
brightDress5 = dress + (5*brightValue);
brightDress6 = dress + (6*brightValue);
darkDress1 = dress - brightValue;
darkDress2 = dress - (2*brightValue);
darkDress3 = dress - (3*brightValue);
darkDress4 = dress - (4*brightValue);
darkDress5 = dress - (5*brightValue);
%Creating a cell filled with my experimental dress images, in order from darkest to brightest  
dressCell={darkDress5,darkDress4,darkDress3,darkDress2,darkDress1,brightDress1,brightDress2,brightDress3,brightDress4,brightDress5,brightDress6}; 
%% Creating the experiment and implementing the method of constant stimuli
%This section pulls random images from my cell of altered dresses and
%presents them to the participant next to the original dress. The side of
%each dress is also rendomized. The loop also presents a fixation cross at 
%the center of each image and records results for reaction time and dress
%selected as "blue-er".
numPresented = 10;%The number of times each dress will be presented
numCond = 11; %The number of unique dresses
numTrials = 110;%The number of total trials
imageNum = repmat(1:numCond,1,numPresented);%Creates a vector of numbers 1-11, repeating 10 times
imageNumRand = imageNum(randperm(length(imageNum))); %Randomizes that vector

results = nan(numTrials,2);%results will go in here

figure %Creating a new figure
figure('WindowState', 'fullscreen', ... %making the figure fullcreen
    'MenuBar', 'none', ... %taking out the menu bar
    'ToolBar', 'none') %Taking out the tool bar
crossSize = 10;%Priors for the fixation point size
crossThickness = 2;%Priors for the fixation point line thickness

for ii = 1:numTrials %For each trial, 1-110
    currentCondition = imageNumRand(ii);
    r = randi([0 1],1);%Will generate 1 random number, either 0 or 1, and call it r
    if r == 0
        dressesMatrix = [dress dressCell{currentCondition}]; %If r=0 show original dress on the left
    elseif r == 1
        dressesMatrix = [dressCell{currentCondition} dress];%If r=1 show original dress on the right
    end
    sizeMatrix = size(dressesMatrix); %This is the size
    temp1 = 1:sizeMatrix(1); %Vector made out of dimension 1
    centerRow = round(median(temp1)); %Median column
    temp2 = 1:sizeMatrix(2); %Vector made out of dimension 2
    centerColumn = round(median(temp2)); %Median row
    %Rows
    dressesMatrix(centerRow-crossSize:centerRow+crossSize, ...
        centerColumn-crossThickness:centerColumn+crossThickness,1) = 255; %Make crossrows red
    dressesMatrix(centerRow-crossSize:centerRow+crossSize, ...
        centerColumn-crossThickness:centerColumn+crossThickness,2:3) = 0;
    
    %Columns
    dressesMatrix(centerRow-crossThickness:centerRow+crossThickness, ...
        centerColumn-crossSize:centerColumn+crossSize,1) = 255; %Make crosscolumns red
    dressesMatrix(centerRow-crossThickness:centerRow+crossThickness, ...
        centerColumn-crossSize:centerColumn+crossSize,2:3) = 0; %Make crosscolumns red
    tic %start timer
    image(dressesMatrix) %present image
    axis equal 
    axis off
    pause
    lastPressed = get(gcf,'CurrentCharacter');%storing the last key the participant pressed
    results(ii,2) = toc; %End timer and record reaction time in the results
    if ((strcmp(lastPressed,'p'))&& (r == 0)) || ((strcmp(lastPressed,'q')) && (r == 1))
        results(ii,1) = 1; %If the altered dress is on the side that the participant chooses, record their result as 1
    elseif ((strcmp(lastPressed,'q')) && (r == 0)) || ((strcmp(lastPressed,'p')) && (r == 1))
        results(ii,1) = 0; %If the altered dress is not on the side that the participant chooses, record their result as 0
    else
        results(ii,1) = nan; %If the respondent presses an invalid key they will be coded as nan
    end
    
end
close all %Close the stimulus window

%% Sorting Mean Results 
%This section matches each result to the dress it comes from to we can sort
%the results by brightness level. Also takes the mean of the 10 responses
%for each dress to calculate the proportion of responses that this dress is
%blue-er.

sortedResults = nan(numPresented,1); %pre-allocating a results matrix. Columns are conditions, rows are observations for that condition

for ii = 1:numCond %For each of the 11 conditions
    
    sortedResults(:,ii) = results( imageNumRand==ii,1 ); %find where the order is equal to the condition we're currently organizing
                                                    %then, pull the results data associated with that condition, and put those data
                                                    %into the correct column
                                              
    
    
end

meanResults = mean(sortedResults,'omitnan'); %take the mean, and plot this in the next section


%% Plot:
%Creating a figure that plots our results
figure
startLevel = 1;
endLevel = 11;
plot(1:1:11,meanResults) %Plot the means for each dress by the level of brightness (1-11)
title('Proportion of Indications that the Dress is "Blue-er" by Dress Brightness Level')
ylim([0,1])
xlabel('Brightness Level of Dress')
ylabel('Proportion Responding "Blue-er"')
set(gca,'Tickdir','out')
box off

%% Saving my Workspace
save('assignment2Workspace') %Saving my workspace including new variables