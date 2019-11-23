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
brightFactorVec = [-25 -20 -15 -10 -5 5 10 15 20 25 30 ] ;   % Here is our blur factor vector

% 1.b ~ Initialize the blurred dress variables to be created in the loop

brightDress5   = zeros(imageSize)   ; % Create a variable of zeros the same size as the dress image for blur factor 5
brightDress10  = zeros(imageSize)   ; % Do the same for blur factor 10
brightDress15  = zeros(imageSize)   ; % Do the same for blur factor 15
brightDress20  = zeros(imageSize)   ; % Do the same for blur factor 20
brightDress25  = zeros(imageSize)   ; % Do the same for blur factor 25
brightDress30  = zeros(imageSize)   ; % Do the same for blur factor 30
brightDressNeg5   = zeros(imageSize)   ; % Create a variable of zeros the same size as the dress image for blur factor 5
brightDressNeg10  = zeros(imageSize)   ; % Do the same for blur factor 10
brightDressNeg15  = zeros(imageSize)   ; % Do the same for blur factor 15
brightDressNeg20  = zeros(imageSize)   ; % Do the same for blur factor 20
brightDressNeg25  = zeros(imageSize)   ; % Do the same for blur factor 25


% 1.c ~ A loop which creates 6 blurred versions of the dress image

rng('shuffle') % Make sure to 'shuffle' the random number generator seed each time the program is ran

for numCond = 1:11                                                              % For all scalars in blurFactorVec
                                                                  % Create a square of 1's the size of the blur factor
    if      brightFactorVec(numCond) == -5                                                                 % If the blur factor is equal to 5...
        brightDressNeg5   = dress + brightFactorVec(numCond)   ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel) - make sure it is an 8-bit unassigned intger type ('uint8()')
        
    elseif  brightFactorVec(numCond) == -10                                                                % If the blur factor is equal to 10...
        brightDressNeg10  = dress + brightFactorVec(numCond)  ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
        
    elseif  brightFactorVec(numCond) == -15                                                                % If the blur factor is equal to 15...
        brightDressNeg15  = dress + brightFactorVec(numCond)   ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
        
    elseif  brightFactorVec(numCond) == -20                                                                % If the blur factor is equal to 20...
        brightDressNeg20  = dress + brightFactorVec(numCond)   ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
        
    elseif  brightFactorVec(numCond) == -25                                                                % If the blur factor is equal to 25...
        brightDressNeg25  = dress + brightFactorVec(numCond)   ;
        
    elseif      brightFactorVec(numCond) == 5                                                                 % If the blur factor is equal to 5...
        brightDress5   = dress + brightFactorVec(numCond)   ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel) - make sure it is an 8-bit unassigned intger type ('uint8()')
        
    elseif  brightFactorVec(numCond) == 10                                                                % If the blur factor is equal to 10...
        brightDress10  = dress + brightFactorVec(numCond)  ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
        
    elseif  brightFactorVec(numCond) == 15                                                                % If the blur factor is equal to 15...
        brightDress15  = dress + brightFactorVec(numCond)   ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
        
    elseif  brightFactorVec(numCond) == 20                                                                % If the blur factor is equal to 20...
        brightDress20  = dress + brightFactorVec(numCond)   ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
        
    elseif  brightFactorVec(numCond) == 25                                                                % If the blur factor is equal to 25...
        brightDress25  = dress + brightFactorVec(numCond)  ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
        
    else                                                                            % If the blur factor is equal to 30...
        brightDress30  = dress + brightFactorVec(numCond)   ;       % ... set the blurredDress variable equal to the convolution of this image (a summation effect, divide by the weight of the kernel)- make sure it is an 8-bit unassigned intger type ('uint8()')
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



dressVector = [{brightDressNeg25}, {brightDressNeg20}, {brightDressNeg15}, ...
    {brightDressNeg10}, {brightDressNeg5}, {brightDress5} , {brightDress10 } , ...
    {brightDress15} , {brightDress20} , {brightDress25} , {brightDress30}]  ;

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
    counter = counter + 1
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
%     pause
%     if strcmp(welcomeFigure.CurrentCharacter,'s') == 1
%         counter = counter+1  ;
%     end
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
            combinedImage = [dress dressVector{randomizedImageOrder(ss)} ] ;
            responseMatrix(counter,4) = leftOrRight ;
            tic ;
            image(combinedImage)
            axis equal
            axis off
            % pause % COMMENT OUT FOR SIMULATION
            responseTime = toc ;
            response = 0 ;
            responseMatrix(counter,1) = counter  ;
            responseMatrix(counter,2) = response ;
            responseMatrix(counter,3) = responseTime;
            counter = counter+1  ;
            
            
            %           if strcmp(presentationFigure.CurrentCharacter,'v') == 1
            %               response = 0 ;
            %               responseMatrix(counter,1) = counter  ;
            %               responseMatrix(counter,2) = response ;
            %               responseMatrix(counter,3) = responseTime;
            %               counter = counter+1  ;
            %           elseif strcmp(presentationFigure.CurrentCharacter,'n') == 1
            %               response = 1 ;
            %               responseMatrix(counter,1) = counter  ;
            %               responseMatrix(counter,2) = response ;
            %               responseMatrix(counter,3) = responseTime;
            %               counter = counter+1  ;
            %           else
            %               counter  ;
            %           end
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4 simulation only
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
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  4 simulation only
        else
            combinedImage = [dressVector{randomizedImageOrder(ss)} dress] ;
            responseMatrix(counter,4) = leftOrRight ;
            tic ;
            image(combinedImage)
            axis equal
            axis off
            % pause % COMMENT OUT FOR SIMULATION
            responseTime = toc ;
            response = 1 ;
            responseMatrix(counter,1) = counter  ;
            responseMatrix(counter,2) = response ;
            responseMatrix(counter,3) = responseTime;
            counter = counter+1  ;
            if strcmp(presentationFigure.CurrentCharacter,'v') == 1
                %               response = 1 ;
                %               responseMatrix(counter,1) = counter  ;
                %               responseMatrix(counter,2) = response ;
                %               responseMatrix(counter,3) = responseTime;
                %               counter = counter+1  ;
                %           elseif strcmp(presentationFigure.CurrentCharacter,'n') == 1
                %               response = 0 ;
                %               responseMatrix(counter,1) = counter  ;
                %               responseMatrix(counter,2) = response ;
                %               responseMatrix(counter,3) = responseTime;
                %               counter = counter+1  ;
                %           else
                %               counter  ;
                %           end
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4 simulation only
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
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4 simulation only
                
            end
            
        end
        close all
    end
end
close all
responseDataTable =  table ;
responseDataTable.Trials = responseMatrix(:,1) ;
responseDataTable.Response = responseMatrix(:,2) ;
responseDataTable.ResponseTime = responseMatrix(:,3) ;
responseDataTable.LeftOrRight = responseMatrix(:,4) ;
responseDataTable.Condition = responseMatrix(:,5) ;
responseDataTable

 

    
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




