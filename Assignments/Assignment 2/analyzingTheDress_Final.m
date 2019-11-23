%% Analyzing The Effect of Brightness on How Blue "The Dress" is Peceived to Be %%

% Project Summary:
    % This project analyzes the relationship between how bright "the
    % dress" is and how blue it is perceive to be. "The Dress" is an infamous
    % image which spread virally as a result of individuals differently
    % perceiving it to be either blue and black or white and gold with
    % great conviction. 
    
% Script Summary:
    % The purpose of this script is to create an experimental structure
    % which alters "the dress" in it's level of brightness, and presents these
    % different versions beside the original in order to record their
    % individual psychophysical data. Once observations have been made, a
    % psychometric function will be plotted. 
        % ~ There will be 11 different images, each with 11 different levels
        % of brightness. These will be in addition to the original image. (12 total images)
        % ~ Altered images will be presented side by side with the original.
            % 11 versions of the image each presented 10 times = 110
            % trials.
        % ~ Participants will be asked to fixated on a red cross in the
        % center of the screen.
        % ~ Left/Right presentation of the original image will be randomized
        % to ensure an equal chance of presentation of the image on either
        % side.
        % ~ Reaction times will also be gathered.
% INPUT: 
    % ~ thedress.jpg: the image file which is the focus of the experiment.
    % ~ participant responses based on the stimulus presented.
    % ~ participant number, should the experimenter wish to keep track
    
% OUTPUT: 
    % ~ participant responses and response times
    % ~ a plotted psychometric curve based on participant responses

% Author:           Mystery (Wo)Man        
% Contact Email:    mystery(wo)man@nyu.edu
% Date Created:     06/16/2019 (mm/dd/yyyy)

% Revision History (date format: mm/dd/yyyy)

% Revision #: Original
% Date              % Author        % Description
% 06/16/2019        % M. (Wo)Man    % Script was created

%% 0 ~ Loading the Data & Intializing Variables

% 0.a ~ Tabula Rasa
clear all   % Clear memory
close all   % Close open figures
clc

% 0.b ~ Load Data into Workspace
% Set 'dressPath' equal to the path where thedress.jpeg file is saved.
dressPath = 'C:\Users\mdeve\OneDrive\Documents\NYU\2019 Summer\Assignments\Assignment 2' ; 
cd(dressPath)                  ;   % change the current directory to the this path
dress = imread('thedress.jpg') ; 

% 0.c ~ Set up prior variables
imageSize       = size(dress)                                   ;   % Set imageSize equal to the size of the image (750 x 495 x 3) - used to initilize loop variables
biggerImageSize = [imageSize(1),imageSize(2)*2,imageSize(3)]    ;   % Set the biggerImageSize equal to a ((750 x 445 x 3) matrix - used to initilize loop variables
columnVector    = 1:biggerImageSize(1)                          ;   % Vector made out of dimension 1
centerRow       = round(median(columnVector))                   ;   % Median column
rowVector       = 1:biggerImageSize(2)                          ;   % Vector made out of dimension 2
centerColumn    = round(median(rowVector))                      ;   % Median row
crossSize       = 10                                            ;   % Size of cross
crossThickness  = 2                                             ;   % Cross thickness
numTrials       = 110                                           ;   % The total amount of trials 
numConditions   = 11                                            ;   % number of altered image conditions
leftRightRand   = 2                                             ;   % Used to randomly sample 1 or 2 to determine whether the orignal image will be presented on the left or right of the altered image
numOfSample     = 1                                             ;   % Used to select one random number from the 1 or 2 in the above line
participantNum  = 1                                             ;   % Input the participant number (used for the file saved at the end.)
combinedImage   = zeros(biggerImageSize)                        ;   % Initialize a matrix that is the size of two images combined.
responseMatrix  = zeros(110,5)                                  ;   % Initialize a matrix that will eventually be filled with all of the experimental data/responses
counter         = 0                                             ;   % This will serve as a counter in the experimental loop which serves many purposes detail later in the script
instructionFont = 20                                            ;   % Set instruction font size.
repetitions     = 10                                            ;   % This represents the number of times that each condition will be presented

% 0.d ~ Graphing Variables - Properties for the final plot
fS          = 14                                            ;   % General fontsize for final graph
startPoint  = -.01                                          ;   % Start point for x-axis in final graph
yhair       = .01                                           ;  % y-axis graphing property to add space between plotted lines and graph edge
xTicMarks   = [-90 -75 -60 -45 -30 -15 0 15 30 45 60 75 90] ; % Set x-axis tic mark values
xLimits     = [-100 100]                                    ;   % X-limit values

%% 0.e ~ READ ME: Procedure for Creating Altered Images of 'The Dress'%%

    % In order to create 11 different versions of the image that are both
    % more and less bright in comparison to the original, we will be both
    % adding and subtract values from the original image matrix 
    % One loop will go through the image 11 times creating the different
    % versions.
        % The final result will be 12 images in total. 6 images will be
        % more bright than the original image, and 5 will be less bright.
        % This will give us a nice range of image alteration which falls 
        % on "both sides" of the "brightness spectrum".

%% 1 ~ Create the brightnessred Images %%
        
% 1.a ~ Create the brightness factor vector which represents the different
% amounts of brightness that will be added or taken away from the original
% image matrix.
brightFactorVec = [-75 -60 -45 -30 -15 15 30 45 60 75 90 ] ;   % Here is our brightness factor vector

% 1.b ~ Initialize the altered dress variables to be created in the loop

brightDress15   = zeros(imageSize)   ; % Create a variable of zeros the same size as the dress image for brightness factor 15
brightDress30   = zeros(imageSize)   ; % Do the same for brightness factor 30
brightDress45   = zeros(imageSize)   ; % Do the same for brightness factor 45
brightDress60   = zeros(imageSize)   ; % Do the same for brightness factor 60
brightDress75   = zeros(imageSize)   ; % Do the same for brightness factor 75
brightDress90   = zeros(imageSize)   ; % Do the same for brightness factor 90
brightDressNeg15  = zeros(imageSize)   ; % Create a variable of zeros the same size as the dress image for negative brightfactor -15
brightDressNeg30  = zeros(imageSize)   ; % Do the same for brightness factor -30
brightDressNeg45  = zeros(imageSize)   ; % Do the same for brightness factor -45
brightDressNeg60  = zeros(imageSize)   ; % Do the same for brightness factor -60
brightDressNeg75  = zeros(imageSize)   ; % Do the same for brightness factor -75


% 1.c ~ A loop which creates 6 brightnessred versions of the dress image

rng('shuffle') % Make sure to 'shuffle' the random number generator seed each time the program is ran

for numCond = 1:numConditions                                                              % For all scalars in brightnessFactorVec
                                                                    % Create a square of 1's the size of the brightness factor
    if      brightFactorVec(numCond) == -15                         % If the bright factor is equal to -15...
        brightDressNeg15   = dress + brightFactorVec(numCond)   ;   % ... set the brightness variable 
        
    elseif  brightFactorVec(numCond) == -30                         % If the brightness factor is equal to -30...
        brightDressNeg30  = dress + brightFactorVec(numCond)  ;     % ... set the brightness variable 
        
    elseif  brightFactorVec(numCond) == -45                         % If the brightness factor is equal to -45...
        brightDressNeg45  = dress + brightFactorVec(numCond)   ;    % ... set the brightness variable 
        
    elseif  brightFactorVec(numCond) == -60                         % If the brightness factor is equal to -60...
        brightDressNeg60  = dress + brightFactorVec(numCond)   ;    % ... set the brightness variable 
        
    elseif  brightFactorVec(numCond) == -75                         % If the brightness factor is equal to -75...
        brightDressNeg75  = dress + brightFactorVec(numCond)   ;    % ... set the brightness variable 
        
    elseif  brightFactorVec(numCond) == 15                      % If the brightness factor is equal to -15...
        brightDress15   = dress + brightFactorVec(numCond)   ;      % ... set the brightness variable 
        
    elseif  brightFactorVec(numCond) == 30                          % If the brightness factor is equal to 30...
        brightDress30  = dress + brightFactorVec(numCond)  ;        % ... set the brightness variable 
        
    elseif  brightFactorVec(numCond) == 45                          % If the brightness factor is equal to 45...
        brightDress45  = dress + brightFactorVec(numCond)   ;       % ... set the brightness variable 
        
    elseif  brightFactorVec(numCond) == 60                          % If the brightness factor is equal to 60...
        brightDress60  = dress + brightFactorVec(numCond)   ;       % ... set the brightness variable 
        
    elseif  brightFactorVec(numCond) == 75                          % If the brightness factor is equal to 75...
        brightDress75  = dress + brightFactorVec(numCond)  ;        % ... set the brightness variable 
        
    else                                                            % If the brightness factor is equal to 90...
        brightDress90  = dress + brightFactorVec(numCond)   ;       % ... set the brightness variable 
    end
end

    
%% 3 ~ The Experiment 

% Randomization of whether or not the original dress will be presented on
% the left or the right, as well as the order of condition presentation,
% will be handled in the experimental loop itself. 

% ~ 3.a First, a vector of cells, containing all altered images, will be
    % built. 
dressVector = [{brightDressNeg75}, {brightDressNeg60}, {brightDressNeg45}, ...
    {brightDressNeg30}, {brightDressNeg15}, {brightDress15} , {brightDress30 } , ...
    {brightDress45} , {brightDress60} , {brightDress75} , {brightDress90}]  ;

% Create the experimental instructions to explain to the participant how
% the experiment works, which keys to press to respond, etc.
instructions = {'Welcome Participant!',' ', ...
    'This experiment will present two images side by side that vary in degrees of brightnessriness.', ...
    'Please select which image you believe is *more blue* by using the keyboard.',...
    'You can do so by using the V and N keys. V is used for the image on the left,', ...
    'and N is used for the image on the right. You will be presented the image', ...
    'for as long as needed and can make a selection whenever you are ready.', ...
    ' ', ' ', '**BEGIN THE EXPERIMENT BY PRESSING THE S KEY.**', ...
    'Please remember to turn off Caps Lock.', ...
    ' ', 'Exit at anytime by x-ing out.'} ;

% The instruction presentation loop explained:
    % This loop handles the presentation of the experimental instructions. 
    % A figure is opened, which presents the experimental instructions.
    % Once the participant presses the right key, counter is increased by
    % one - triggering the next loop (experimental presentation) to run. 

if counter == 0                                             % This if statement is a backup, to make sure that the counter is at zero before the experiment stops (see below)
    welcomeFigure = figure                              ;   % Open the welcomeFigure to draw text on
    instructionHandle = text(0.5,0.5,instructions)      ;   % Present instructions
    instructionHandle.FontSize = instructionFont        ;   % Create a larger font size
    instructionHandle.HorizontalAlignment = 'center'    ;   % Centered text
    welcomeFigure.Color = [.9 .9 .9]                    ;   % Grey background
    instructionHandle.Color = 'k'                       ;   % Black text
    axis off                                                % Axis off
    hold on                                                 % Hold graph on
    pause                                                   % Pause and wait for a keyboard press
    if strcmp(welcomeFigure.CurrentCharacter,'s') == 1      % If 's' is pressed, counter increases by one and we move to the next loop
        counter = counter+1                             ;   % Increase counter  
    end
    close all                                           ;   % Close figure
else                                                        
    counter = 0                                         ;   % If the counter is not set to zero, this will change it to zero, and reset it to run properly.vn
end

% The experimental loop explained:
    % This loop handles the presentation of the experimental stimuli. 
    % In order to randomize the presentation of the placement of the
    % original dress (right or left of altered), as well as the order of
    % condition presentation, a nested for loop is utilized. 
    % The central loop contains an if statement which recognizes whether or
    % not a random 1 or 2 has been created. Based on this, the original 
    % dress image will be placed on the left or the right of an altered
    % image. Prior to this, an eleven element vector from 1 to 11 is
    % created, and then scrambled into a random order. This order
    % represents the randomized order in which conditions are presented. As
    % the participant responds, reaction time, specific responses, and
    % trial number are recorded. 
    % NOTE: If you would like to run a simulation, so that you don't have 
    % to click through the presenation 110 times to see if it works, you 
    % can comment out the lines mentioned below, and comment in the copies 
    % of those same lines ( it is the portion of the loop that is within
    % the if statement that records the majority of the data. Be careful!
    % If you do this incorrectly, it can screw things up!

for rr = 1:repetitions                                                  % Iterate through a vector, 1 through 10 (these are the condition presentation repetitions)
    randomizedImageOrder = randperm(11)                             ;   % Create a row vector containing a random permutation of the integers from 1 to 11 inclusive (1 through 11 numbers in scrambled order)
    responseMatrix(counter:counter+10, 5) = randomizedImageOrder'   ;   % Take this order and place it into the condition column's (5th column) row values (for the responseMatrix) for 1 through 11 when rr = 1, and then 12 through 22 when rr = 2, etc. - other values will fill in next to these as the experiment goes on
    
    for ai = 1:length(dressVector)                                      % For a vector the length of 'dressVector' (1 through 11) where ai will serve as the indexing value to draw from the randomizedImageOrder vector
        presentationFigure = figure ;                                   % Open a figure to place the image on
        set(presentationFigure, 'Position', get(0, 'Screensize'));      % Set figure size to full screen
        leftOrRight = randsample(leftRightRand,numOfSample)                         ;   % Randomly select a one or a two
        if leftOrRight == 1                                                             % If a 1 is selected
            combinedImage = [dress dressVector{randomizedImageOrder(ai)} ]          ;   % Create a larger image of the original and the altered dress. Place the original image on the left. Take the ai'th element of the randomizedImageOrder vector so the first element can be any number between 1 and 11 (depends on how the randomizeImageOrder vector is created on each loop)
            % Create the horizontal line of the red fixation cross 
            combinedImage(centerRow-crossSize:centerRow+crossSize, ...
                centerColumn-crossThickness:centerColumn+crossThickness,1) = 255    ; 
            combinedImage(centerRow-crossSize:centerRow+crossSize, ...
                centerColumn-crossThickness:centerColumn+crossThickness,2:3) = 0    ;
            
            % Create the vertical line of the red fixation cross 
            combinedImage(centerRow-crossThickness:centerRow+crossThickness, ...
                centerColumn-crossSize:centerColumn+crossSize,1) = 255              ; 
            combinedImage(centerRow-crossThickness:centerRow+crossThickness, ...
                centerColumn-crossSize:centerColumn+crossSize,2:3) = 0              ; 

            responseMatrix(counter,4) = leftOrRight                                 ;   % In the 4th column of the responseMatrix record whether or not the left/right randomizer was a one or a two
            tic                                                                     ;   % Start the timer to record response times
            image(combinedImage)                                                    ;   % Present the image
            axis equal                                                                  % Make the aspect ration equal
            axis off                                                                    % Turn off the axis for a cleaner presentation
            pause % COMMENT OUT FOR SIMULATION
            responseTime = toc                                                      ;   % Set responseTime equal to the value of toc
            %%%%%%%%%%%%%%%%%%%%%%%%% BELOW FOR SIMULATION
%             response = 0 ;
%             responseMatrix(counter,1) = counter  ;
%             responseMatrix(counter,2) = response ;
%             responseMatrix(counter,3) = responseTime;
%             counter = counter+1  ;
            %%%%%%%%%%%%%%%%%%%%%%%%% ABOVE FOR SIMULATION
            
            if strcmp(presentationFigure.CurrentCharacter,'v') == 1                 % If they press 'v' then do the below
                response = 0                                                        ;   % Set response equal to 0 (they chose the original dress, because 'v' represents left)
                responseMatrix(counter,1) = counter                                 ;   % Record the Trial number by using the counter value (column 1 of responseMatrix)
                responseMatrix(counter,2) = response                                ;   % Record the response (column 2 of responseMatrix)
                responseMatrix(counter,3) = responseTime                            ;   % Record responseTime (column 3 of the responseMatrix)
                counter = counter+1                                                 ;   % Increase the counter by 1
            elseif strcmp(presentationFigure.CurrentCharacter,'n') == 1             % If they press 'n' then do the below
                response = 1                                                        ;   % Set the response equal to 1 (they chose the altered image because 'n' represents right) 
                responseMatrix(counter,1) = counter                                 ;   % Record the Trial number by using the counter value (column 1 of responseMatrix)
                responseMatrix(counter,2) = response                                ;   % Record the response (column 2 of responseMatrix)
                responseMatrix(counter,3) = responseTime                            ;   % Record responseTime (column 3 of the responseMatrix)
                counter = counter+1                                                 ;   % Increase the counter by 1
            else
                counter                                                             ;   % If they press an incorrect key (not 'n' or 'v') then the counter doesn't get increased, and the trial will be skipped
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Below 4 simulation only
%                         if strcmp(presentationFigure.CurrentCharacter,'v') == 1
%                             response = 0 ;
%                             responseMatrix(counter,1) = counter  ;
%                             responseMatrix(counter,2) = response ;
%                             responseMatrix(counter,3) = responseTime;
%                             counter = counter+1  ;
%                         elseif strcmp(presentationFigure.CurrentCharacter,'n') == 1
%                             response = 1 ;
%                             responseMatrix(counter,1) = counter  ;
%                             responseMatrix(counter,2) = response ;
%                             responseMatrix(counter,3) = responseTime;
%                             counter = counter+1  ;
%                         else
%                             counter  ;
%                         end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Above 4 simulation only
        else                                                                            % If a 2 is created from the leftOrRight randomizer, then do the below
            combinedImage = [dressVector{randomizedImageOrder(ai)} dress]           ;   % Create a larger image of the original and the altered dress. Place the original image on the left. Take the ai'th element of the randomizedImageOrder vector so the first element can be any number between 1 and 11 (depends on how the randomizeImageOrder vector is created on each loop)
            % Create the horizontal line of the red fixation cross
            combinedImage(centerRow-crossSize:centerRow+crossSize, ...
                centerColumn-crossThickness:centerColumn+crossThickness,1) = 255    ; 
            combinedImage(centerRow-crossSize:centerRow+crossSize, ...
                centerColumn-crossThickness:centerColumn+crossThickness,2:3) = 0    ;
            
            % Create the vertical line of the red fixation cross
            combinedImage(centerRow-crossThickness:centerRow+crossThickness, ...
                centerColumn-crossSize:centerColumn+crossSize,1) = 255              ; 
            combinedImage(centerRow-crossThickness:centerRow+crossThickness, ...
                centerColumn-crossSize:centerColumn+crossSize,2:3) = 0              ; 

            responseMatrix(counter,4) = leftOrRight                                 ;   % In the 4th column of the responseMatrix record whether or not the left/right randomizer was a one or a two
            tic                                                                     ;   % Start the timer to record response times
            image(combinedImage)                                                    ;   % Present the image
            axis equal                                                                  % Make the aspect ration equal
            axis off                                                                    % Turn off the axis for a cleaner presentation
            pause % COMMENT OUT FOR SIMULATION
            responseTime = toc                                                      ;   % Set responseTime equal to the value of toc
            %%%%%%%%%%%%%%%%%%%%%%  BELOW FOR SIMULATION
%             response = 1 ;
%             responseMatrix(counter,1) = counter  ;
%             responseMatrix(counter,2) = response ;
%             responseMatrix(counter,3) = responseTime;
%             counter = counter+1  ;
            %%%%%%%%%%%%%%%%%%%%%%  ABOVE FOR SIMULATION
            
            if strcmp(presentationFigure.CurrentCharacter,'v') == 1                 % If they press 'v' then do the below
                response = 1                                                        ;   % Set response equal to 1 (they chose the altered dress, because 'v' represents left)
                responseMatrix(counter,1) = counter                                 ;   % Record the Trial number by using the counter value (column 1 of responseMatrix)
                responseMatrix(counter,2) = response                                ;   % Record the response (column 2 of responseMatrix)
                responseMatrix(counter,3) = responseTime                            ;   % Record responseTime (column 3 of the responseMatrix)
                counter = counter+1                                                 ;   % Increase the counter by 1
            elseif strcmp(presentationFigure.CurrentCharacter,'n') == 1             % If they press 'n' then do the below
                response = 0                                                        ;   % Set the response equal to 1 (they chose the altered image because 'n' represents right) 
                responseMatrix(counter,1) = counter                                 ;   % Record the Trial number by using the counter value (column 1 of responseMatrix)
                responseMatrix(counter,2) = response                                ;   % Record the response (column 2 of responseMatrix)
                responseMatrix(counter,3) = responseTime                            ;   % Record responseTime (column 3 of the responseMatrix)
                counter = counter+1                                                 ;   % Increase the counter by 1
            else
                counter                                                             ;   % If they press an incorrect key (not 'n' or 'v') then the counter doesn't get increased, and the trial will be skipped
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4 simulation only
%                             if strcmp(presentationFigure.CurrentCharacter,'v') == 1
%                                 response = 1 ;
%                                 responseMatrix(counter,1) = counter  ;
%                                 responseMatrix(counter,2) = response ;
%                                 responseMatrix(counter,3) = responseTime;
%                                 counter = counter+1  ;
%                             elseif strcmp(presentationFigure.CurrentCharacter,'n') == 1
%                                 response = 0 ;
%                                 responseMatrix(counter,1) = counter  ;
%                                 responseMatrix(counter,2) = response ;
%                                 responseMatrix(counter,3) = responseTime;
%                                 counter = counter+1  ;
%                             else
%                                 counter  ;
%                             end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4 simulation only
            
        end
        
    end
    close all                                               % After every 11 presentations, all figures are close as to not overload the computer
end
close all                                                   % Close all figures

% Create a data table that houses all of the responseMatrix values for
% easier viewing...

responseDataTable =  table                              ;   % Create a table called 'responseDataTable' to allow for easier viewing of the data into the responseDataTable
responseDataTable.Trials = responseMatrix(:,1)          ;   % Place the trial values into a column called 'Trials' into the responseDataTable
responseDataTable.Response = responseMatrix(:,2)        ;   % Place the response values into a column called 'Response' into the responseDataTable
responseDataTable.ResponseTime = responseMatrix(:,3)    ;   % Place the response time values into a column called 'ResponseTime' into the responseDataTable
responseDataTable.LeftOrRight = responseMatrix(:,4)     ;   % Place the recorded left or right randomized values into a column called 'LeftOrRight' (this allows you to check response values and make sure that they are working correctly.) into the responseDataTable
responseDataTable.Condition = responseMatrix(:,5)       ;   % Place the condition values into a column called 'Condition' into the responseDataTable

%% Take the response scores from the data table and place them into proper response vectors &&

% Initilaze variables for the loop below for the different
% condition values.
brightDress15Response = zeros(10,1)        ;
brightDress30Response = zeros(10,1)        ;
brightDress45Response = zeros(10,1)        ;
brightDress60Response = zeros(10,1)        ;
brightDress75Response = zeros(10,1)        ;
brightDress90Response = zeros(10,1)        ;
brightDressNeg75Response = zeros(10,1)     ;
brightDressNeg60Response = zeros(10,1)     ;
brightDressNeg45Response = zeros(10,1)     ;
brightDressNeg30Response = zeros(10,1)     ;
brightDressNeg15Response = zeros(10,1)     ;

% Below loop explained:
    % Loop through 110 rows of the responseDataTable 11 times and take the response
    % value for that row, and place it into a condition-labeled vector that
    % will be used for plotting the psychometric function.

% Condition values in the loop below are explained here:
    % 1 = negative 75 condition
    % 2 = negative 60 condition
    % 3 = negative 45 condition
    % 4 = negative 30 condition
    % 5 = negative 15 condition
    % 6 = positive 15 condition
    % 7 = positive 30 condition
    % 8 = positive 45 condition
    % 9 = positive 60 condition
    % 10 = positive 75 condition
    % 11 = positive 90 condition
    
for conditions = 1:numConditions                                                            % For 11 conditions
    for rows = 1:numTrials                                                                  % For 110 rows 
        if responseDataTable.Condition(rows) == conditions                                  % This will alway be true, included for clarity. We are looping through the **conditions column** of the responseDataTable
            if conditions == 1
                brightDressNeg75Response(conditions) = responseDataTable.Response(rows) ;   % Place response value into the appropriate condition vector
            elseif conditions == 2
                brightDressNeg60Response(conditions) = responseDataTable.Response(rows) ;   % Place response value into the appropriate condition vector
            elseif conditions == 3
                brightDressNeg45Response(conditions) = responseDataTable.Response(rows) ;   % Place response value into the appropriate condition vector
            elseif conditions == 4
                brightDressNeg30Response(conditions) = responseDataTable.Response(rows) ;   % Place response value into the appropriate condition vector
            elseif conditions == 5
                brightDressNeg15Response(conditions) = responseDataTable.Response(rows) ;   % Place response value into the appropriate condition vector
            elseif conditions == 6
                brightDress15Response(conditions) = responseDataTable.Response(rows) ;      % Place response value into the appropriate condition vector
            elseif conditions == 7
                brightDress30Response(conditions) = responseDataTable.Response(rows) ;      % Place response value into the appropriate condition vector
            elseif conditions == 8
                brightDress45Response(conditions) = responseDataTable.Response(rows) ;      % Place response value into the appropriate condition vector
            elseif conditions == 9
                brightDress60Response(conditions) = responseDataTable.Response(rows) ;      % Place response value into the appropriate condition vector
            elseif conditions == 10
                brightDress75Response(conditions) = responseDataTable.Response(rows) ;      % Place response value into the appropriate condition vector
            else
                brightDress90Response(conditions) =  responseDataTable.Response(rows) ;     % Place response value into the appropriate condition vector
            end  
        end
    end
end

%% Find the mean proportion of these response values and plot a psychometric curve

% Take the mean of each response vector and rename for the psychometric
% plot.
BD15 = mean(brightDress15Response)          ;
BD30 = mean(brightDress30Response)          ;
BD45 = mean(brightDress45Response)          ;
BD60 = mean(brightDress60Response)          ;
BD75 = mean(brightDress75Response)          ;
BD90 = mean(brightDress90Response)          ;
NegBD15 = mean(brightDressNeg15Response)    ;
NegBD30 = mean(brightDressNeg30Response)    ;
NegBD45 = mean(brightDressNeg45Response)    ;
NegBD60 = mean(brightDressNeg60Response)    ;
NegBD75 = mean(brightDressNeg75Response)    ;


brightnessLevels = brightFactorVec                                          ;   % Represents the x-axis values
meanProportion = [NegBD75 , NegBD60, NegBD45, NegBD30 , NegBD15,...
        BD15, BD30, BD45, BD60, BD75, BD90]                                 ;   % Represents the y-axis values

plotFigure = figure                                                         ;   % Open a figure called plotFigure
plot(brightnessLevels,meanProportion, '-o')                                 ;   % Plot the data
xlim(xLimits)                                                               ;   % Limit of x-axis = 0 to 277
ylim([startPoint max(meanProportion) + yhair])                              ;   % Limit of x-axis = 0 to 4297 (4297 = 250 ms greater than the largest recorded observation)
xlim(xLimits)                                                               ;   % Set x-limits
xticks(xTicMarks)                                                           ;   % Set x-tic marks
xlabel('Brightness Levels')                                                 ;   % x-axis label
ylabel('Mean Proportion of Responding Blue' )                               ;   % y-axis label
title('"Blueness" of "The Dress" as a Function of Brightness')              ;   % Title of graph
set(gca,'FontSize', fS)                                                     ;   % Setting font size for all graph labels to 14
set(gca,'TickDir', 'out')                                                   ;   % Setting tick marks to be outside of graph
set(gca,'box','off')                                                        ;   % Get rid of the unnecessary tic marks

%% Save the workspace...
% Place the participant number into the filename for reference/organization
% and save the figure and workspace.
savefig(plotFigure, 'participantNum'+ string(participantNum) + '.fig')      ; % Save a figure file
save('participantNum' + string(participantNum) +'Responses.mat')            ;

%% END




