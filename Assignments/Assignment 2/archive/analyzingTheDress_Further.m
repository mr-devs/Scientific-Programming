%% Analyzing The Effect of Blur on how blue "The Dress" is Peceived to Be %%

% Project Summary:
    % This project analyzes the relationship between how blurry "the
    % dress" and how blue it is perceive to be. "The Dress" is an infamous
    % image which spread virally as a result of individuals differently
    % perceiving it to be either blue and black or white and gold with
    % great conviction. Specifically, the hypotheses
    
% Script Summary:
    % The purpose of this script is to create an experimental structure
    % which alters "the dress" in it's level of blur, and presents these
    % different versions beside the original in order to record their
    % individual psychophysical data. Once observations have been made, a
    % psychometric function will be plotted. 
        % ~ There will be 11 different images, each with 11 different levels
        % of blurr. These will be in addition to the original image. (12 total images)
        % ~ Blurred images will be presented side by side with the original.
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
cd(dressPath)                   ;   % change the current directory to the this path
dress = imread('thedress.jpg') ; 

% 0.c ~ Set up prior variables
imageSize       = size(dress)                                   ;   % Set imageSize equal to the size of the image (750 x 495 x 3) - used to initilize loop variables
biggerImageSize = [imageSize(1),imageSize(2)*2,imageSize(3)]    ;   % Set the biggerImageSize equal to a ((750 x 445 x 3) matrix - used to initilize loop variables
numTrials       = 110                                           ;   % The total amount of trials 
leftRightRand   = 2                                             ;   % Used to randomly sample 1 or 2 to determine whether the orignal image will be presented on the left or right of the altered image
numOfSample     = 1                                             ;   % Used to select one random number from the 1 or 2 in the above line
% 0.d ~ Graphing Variables - Properties for the final plot
lW          = 1                 ;   % Line width for each trace line in final graph
fS          = 14                ;   % General fontsize for final graph
startPoint  = 0                 ;   % Start point for x-axis in final graph
xhair       = 5                 ;   % x-axis graphing property to add space between plotted lines and graph edge
yhair       = 250               ;   % y-axis graphing property to add space between plotted lines and graph edge

%% 0.e ~ READ ME: Procedure for Creating Altered Images of 'The Dress'%%

    % In order to create 11 different versions of the image that are both
    % more and less blurry in comparison to the original, we will both
    % apply convolutional methods (to increase blur) and utilize a sharpening
    % function ('imsharpen').
    % ~ A vector of 6 blur factos and a vector of 5 sharpening factors will
    % be created. Then, two loops will be run on the original image to
    % create altered version. The first loop will increase blur based on
    % the factors chosen. The second loop will sharpen the image based on
    % the factors chosen.
        % The final result will be 12 images in total. 6 images will be
        % more blurry than the original image, and 5 will represent higher
        % spatial frequency versions - this gives us a nice range of image
        % alteration which falls on "both sides" of the "blur spectrum".

%% 1 ~ Create the Blurred Images %%
        
% 1.a ~ Create the blur factor vector 
blurFactorVec = [5 10 15 20 25 30 ] ;   % Here is our blur factor vector

% 1.b ~ Initialize the blurred dress variables to be created in the loop

blurredDress5   = zeros(imageSize)   ; % Create a variable of zeros the same size as the dress image for blur factor 5
blurredDress10  = zeros(imageSize)   ; % Do the same for blur factor 10
blurredDress15  = zeros(imageSize)   ; % Do the same for blur factor 15
blurredDress20  = zeros(imageSize)   ; % Do the same for blur factor 20
blurredDress25  = zeros(imageSize)   ; % Do the same for blur factor 25
blurredDress30  = zeros(imageSize)   ; % Do the same for blur factor 30
% blurredDress5LG = size(biggerImageSize)    ;
% blurredDress20LG = size(biggerImageSize)   ;
% blurredDress15LG = size(biggerImageSize)   ;
% blurredDress20LG = size(biggerImageSize)   ;
% blurredDress25LG = size(biggerImageSize)   ;
% blurredDress30LG = size(biggerImageSize)   ;

% 1.c ~ A loop which creates 6 blurred versions of the dress image

rng('shuffle') % Make sure to 'shuffle' the random number generator seed each time the program is ran

for bf = blurFactorVec                                                              % For all scalars in blurFactorVec
    kernel = ones(bf)                                                           ;   % Create a square of 1's the size of the blur factor
    leftOrRight = randsample(leftRightRand,numOfSample)                         ;   % Randomly select a one or a two
    if      bf == 5                                                                 % If the blur factor is equal to 5...
        blurredDress5   = convn(dress,kernel,'same')./sum(sum(kernel))   ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel) - make sure it is an 8-bit unassigned intger type ('uint8()')
        if leftOrRight == 1
            blurredDress5LG = [dress blurredDress5] ;
        else
            blurredDress5LG = [blurredDress5 dress] ;
        end
        
    elseif  bf == 10                                                                % If the blur factor is equal to 10...
        blurredDress10  = convn(dress,kernel,'same')./sum(sum(kernel))  ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
        if leftOrRight == 1
            blurredDress10LG = [dress blurredDress10] ;
        else
            blurredDress10LG = [blurredDress10 dress] ;
        end
        
    elseif  bf == 15                                                                % If the blur factor is equal to 15...
        blurredDress15  = convn(dress,kernel,'same')./sum(sum(kernel))   ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
        if leftOrRight == 1
            blurredDress15LG = [dress blurredDress15] ;
        else
            blurredDress15LG = [blurredDress15 dress] ;
        end
        
    elseif  bf == 20                                                                % If the blur factor is equal to 20...
        blurredDress20  = convn(dress,kernel,'same')./sum(sum(kernel))   ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
        if leftOrRight == 1
            blurredDress20LG = [dress blurredDress20] ;
        else
            blurredDress20LG = [blurredDress20 dress] ;
        end
        
    elseif  bf == 25                                                                % If the blur factor is equal to 25...
        blurredDress25  = convn(dress,kernel,'same')./sum(sum(kernel))  ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
        if leftOrRight == 1
            blurredDress25LG = [dress blurredDress25] ;
        else
            blurredDress25LG = [blurredDress25 dress] ;
        end
        
    else                                                                            % If the blur factor is equal to 30...
        blurredDress30  = convn(dress,kernel,'same')./sum(sum(kernel))   ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
        if leftOrRight == 1
            blurredDress30LG = [dress blurredDress30] ;
        else
            blurredDress30LG = [blurredDress30 dress] ;
        end
    end
end



%% 2 ~ Create the Sharper Images %%

% 2.a ~ Create a vector of sharpening factors that increase linearly in the same 
% fashion as the blur factor, but is reduced by a factor of 10. This is
% done due to the nature of the 'imsharpen()' function which is used to
% create sharper images. Factors typically range from 0 - 2, thus the
% largest factor of 2.5 is quite extreme.

sharpenFactorVec = [1 2 3 4 5] ;   % create vector of sharpening factors [0.5, 1, 1.5, 2, 2.5, 3]

% 1.b ~ Initialize the sharper dress variables to be created in the loop.
% The end portion of the variable (i.e. - 'half', '1', '1.5') represents
% the factor applied (i.e. .5, 1, 1.5).

sharpDressHalf  = zeros(imageSize)  ;   % Initializ a matrix of zeros that is the same size as the original image with a sharpen factor of .5
sharpDress1     = zeros(imageSize)  ;   % Do the same for sharpen factor 1
sharpDress1Half = zeros(imageSize)  ;   % Do the same for sharpen factor 1.5
sharpDress2     = zeros(imageSize)  ;   % Do the same for sharpen factor 2
sharpDress2Half = zeros(imageSize)  ;   % Do the same for sharpen factor 2.5
sharpDressHalfLG  = size(biggerImageSize)  ;
sharpDress1LG     = size(biggerImageSize)  ;
sharpDress1HalfLG = size(biggerImageSize)  ;
sharpDress2LG     = size(biggerImageSize)  ;
sharpDress2HalfLG = size(biggerImageSize)  ;

% 1.c ~ A loop which creates 5 sharper versions of the dress image

for ss = 1:length(sharpenFactorVec)                                     % For a vector the length of 'sharpenFactorVec'
    sharpenF = sharpenFactorVec(ss)                             ;       % Set sharpenF equal to the factor

    if ss == 1                                                     % If the factor is .5 ...
        sharpDressHalf  = imsharpen(dress, 'Amount', sharpenF)  ;       % ... then create the sharpened image based on the set factor
        if leftOrRight == 1
            sharpDressHalfLG = [dress sharpDressHalf] ;
        else
            sharpDressHalfLG = [sharpDressHalf dress] ;
        end        
    elseif ss == 2                                                  % If the factor is 1 ...
        sharpDress1     = imsharpen(dress, 'Amount', sharpenF)  ;       % ... then create the sharpened image based on the set factor
        if leftOrRight == 1
            sharpDress1LG = [dress sharpDress1] ;
        else
            sharpDress1LG = [sharpDress1 dress] ;
        end
    elseif ss == 3                                                % If the factor is 1.5 ...
        sharpDress1Half = imsharpen(dress, 'Amount', sharpenF)  ;       % ... then create the sharpened image based on the set factor
        if leftOrRight == 1
            sharpDress1HalfLG = [dress sharpDress1Half] ;
        else
            sharpDress1HalfLG = [sharpDress1Half dress] ;
        end        
    elseif ss == 4                                                  % If the factor is 2 ...
        sharpDress2     = imsharpen(dress, 'Amount', sharpenF)  ;       % ... then create the sharpened image based on the set factor
        if leftOrRight == 1
            sharpDress2LG = [dress sharpDress2] ;
        else
            sharpDress2LG = [sharpDress2 dress] ;
        end        
    elseif ss == 5                                                % If the factor is 2.5 ...
        sharpDress2Half = imsharpen(dress, 'Amount', sharpenF)  ;       % ... then create the sharpened image based on the set factor
        if leftOrRight == 1
            sharpDress2HalfLG = [dress sharpDress2Half] ;
        else
            sharpDress2HalfLG = [sharpDress2Half dress] ;
        end        
    end
end
    
%% 3 ~ Create New Larger Images (Original next to Altered Images 

% In order to present images in a clean fashion, each altered image will be
% combined with the original image into a larger matrix. These matrices
% will take the same exact variable form as previously named **with the 'LG' 
% appended to the end indicating it is the larger matrix version.  

% dressVector = [{blurredDress30LG} , {blurredDress25LG } , {blurredDress20LG} , {blurredDress15LG} , ...   ;
%                           {blurredDress10LG} , {blurredDress5LG} , {sharpDressHalfLG},  {sharpDress1LG},  ...  ;
%                           {sharpDress1HalfLG}, {sharpDress2LG}, {sharpDress2HalfLG}]  ;                                          
% something else



dressVector = [{blurredDress30} , {blurredDress25 } , {blurredDress20} , {blurredDress15} , ...   ;
                          {blurredDress10} , {blurredDress5} , {sharpDressHalf},  {sharpDress1},  ...  ;
                          {sharpDress1Half}, {sharpDress2}, {sharpDress2Half}]  ;                                          
combinedImage = zeros(biggerImageSize) ;
                      
responseMatrix = zeros(110,5) ;
counter = 0;

str = {'Welcome Participant!',' ', ...
    'This experiment will present two images side by side that vary in degrees of blurriness.', ...
    'Please select which image you believe is *more blue* by using the keyboard.',...
    'You can do so by using the V and N keys. V is used for the image on the left,', ...
    'and N is used for the image on the right. You will be presented the image', ...
    'for as long as needed and can make a selection whenever you are ready.', ...
    ' ', ' ', '**BEGIN THE EXPERIMENT BY PRESSING THE S KEY.**', ...
    ' ', 'Exit at anytime by x-ing out.'} ;

while counter ==0
if counter == 0
    welcomeFigure = figure; %New figure
    textHandle = text(0.5,0.5,str);
    textHandle.FontSize = 20; %bigger font
    textHandle.HorizontalAlignment = 'center'; %Centered text
    welcomeFigure.Color = [.9 .9 .9]; % grey background
    textHandle.Color = 'k'; %Green text
    axis off
    hold on
    pause
    if strcmp(welcomeFigure.CurrentCharacter,'s') == 1
        counter = counter+1  ;
    end
    close all
end
end
%randperm
for rr = 1:10
    vectorPopulation = linspace(1,11,11) ;
    randomizedImageOrder = randsample(vectorPopulation, 11) ;
    responseMatrix(counter:counter+10, 5) = randomizedImageOrder' ;
    
  for ss = 1:length(dressVector)                        % For a vector the length of 'sharpenFactorVec'
      presentationFigure = figure ;
      leftOrRight = randsample(leftRightRand,numOfSample)                         ;   % Randomly select a one or a two
      if leftOrRight == 1
          combinedImage = [dress dressVector{ss}] ;
          responseMatrix(counter,4) = leftOrRight ;
          tic ;
          image(combinedImage)
          axis equal
          axis off
          pause
          responseTime = toc ;
          if strcmp(presentationFigure.CurrentCharacter,'v') == 1
              response = 0 ;
              responseMatrix(counter,1) = counter  ;
              responseMatrix(counter,2) = response ;
              responseMatrix(counter,3) = responseTime;
              counter = counter+1  ;
          elseif strcmp(presentationFigure.CurrentCharacter,'n') == 1
              response = 1 ;
              responseMatrix(counter,1) = counter  ;
              responseMatrix(counter,2) = response ;
              responseMatrix(counter,3) = responseTime;
              counter = counter+1  ;
          else
              counter  ;
          end
          
      else 
          combinedImage = [dressVector{ss} dress] ;
          responseMatrix(counter,4) = leftOrRight ;
          tic ;
          image(combinedImage)
          axis equal
          axis off
          pause
          responseTime = toc ;
          if strcmp(presentationFigure.CurrentCharacter,'v') == 1
              response = 1 ;
              responseMatrix(counter,1) = counter  ;
              responseMatrix(counter,2) = response ;
              responseMatrix(counter,3) = responseTime;
              counter = counter+1  ;
          elseif strcmp(presentationFigure.CurrentCharacter,'n') == 1
              response = 0 ;
              responseMatrix(counter,1) = counter  ;
              responseMatrix(counter,2) = response ;
              responseMatrix(counter,3) = responseTime;
              counter = counter+1  ;
          else
              counter  ;
          end

      end

  end
close all
end
close all
responseDataTable =  table ;
responseDataTable.Trials = responseMatrix(:,1) ;
responseDataTable.Response = responseMatrix(:,2) ;
responseDataTable.ResponseTime = responseMatrix(:,3) ;
responseDataTable.LeftOrRight = responseMatrix(:,4) ;
responseDataTable.Condition = responseMatrix(:,5) ;
responseDataTable
table
%% 


image(uint8(round(blurredDress))); 
axis equal

image(uint8(dress))
axis equal

% image(uint8(round(blurredDress))); % Convolution makes it a double. So we need to round and uint8 it again
% image(dress)
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

% 4.b ~ Create a "Trials Variable" (serves as the x-axis values for all
% plots):
    % Create a "trials variable" that is the correct number of trials - not
    % 300 - as we have removed some invalid observations. NOTE: All participants
    % had an equal number of invalid trials, so only one trial variable is
    % necessary.

validNumTrials = 1:length(validTrials200) ; % Trials variable 

% 4.c ~ Create trace lines and set their properties

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
ylabel('Reaction Time (ms)')                                    ;   % Y-axis label
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

%% END




