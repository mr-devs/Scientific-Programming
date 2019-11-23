%% EDITOR INTRODUCTION
% This script shows how to use the editor, and how to use Matlab as a
% graphic calculator. It presumes nothing and produces a bunch of figures.
% ^/3/19: V1 - The code itsellf
% M_DeVerna


%% Two percent signs set up a code section - this line
% Code Sections should be logical segments.

% IMPORTANT: If you want to be able to maintain your code, each cell should fit on
% one screen!! If it gets longer, you should abstract or break
% it up!!


%% 0 Initialization (Number sections to know where you are)
% logical errors are predominantly bred by stuff floating around in memory
% that you forgot about. So you should always start from a blank slate.
% This initialization step is akin to the birth of your program.
 
clear variables ;% This clears memory
close all ;% Closes all figures
clc       ;% Clears the command window
 
% Have a block of constants and flags that are defined here.
stepSize = .01 ; % create your step size variable to utilize in the below plot
startPoint = 0 ; % good place to start for a sinewave plotting 
numCycles = 3 ;  % end point should be chosen in radians so the sinewave doesn't get cut off
endPoint = numCycles * 2 * pi ; % the equation of a sine wave in radians
lW = 3 ;     % Line Width variables to use within plot
hair = .24 ; % space between axes 
fS = 16 ;    % Our general fontsize (in points)
nBins = 21 ; % number of nBins for our histogram

%% 1 Basic plotting
% This section introduces basic plotting/drawing commands

Taylor = figure ; % open a canvas to draw on (you don't need to do this, but it is a good habit) /// Taylor = handle for figure

x = startPoint : stepSize : endPoint; % Creates numbers from 0 through 10 counting by one
y = sin(x) ; % Sine of x. Could be anything
h = plot(x,y) ; % Plot y as a function of x /~~/ 'h' = an OBJECT
xlabel('Time in seconds') ;
ylabel('Voltage in mV') ;
title('Voltage Over Time') ;

% get(h) % gets the propoerties of 'h' -- this allows you to see what the propoerties
% of that plot are. You can change then change them.
% IMPORTANT!! you can't run this if you close the figure. Doing so deletes
% 'h' from memory so you will error-out

% GENERAL 'SET' SYNTAX: NAME OF HANDLE TO MODIFY, PROPERTY, TARGET VALUE
set(h, 'LineWidth', lW) ; 

% get(gca) = GET CURRENT AXES

% Need to plot the figure with a 'HAIR OF AIR' between line and axis limit

% 'xlim' method to set X=axis
xlim([startPoint - hair endPoint + hair])

% 'set' method to set X-axis
% set(gca, 'Xlim', [startPoint - hair endPoint + hair] ) 

% get(0) --> to get 'root' 
% NOTE: this is the like the most basic object in Matlab. It allows
% you to see the # of children as well as basic characteristics like
% screensize

% This will change the color of the figure background b/c 'Taylor is the
% handle for this figure
set(Taylor, 'Color', 'c') ;

% change fontsize
set(gca,'FontSize', fS) ; 
 
% Change the line to the color black
h.Color = 'r' ;

% Make sure tickmarks corresponds to TUFTE 'data ink'
set(gca, 'TickDir' , 'out') ;
box off ;

%% 2 Multi-Line (multi-object) plots
% adding a second line to the graph

y2 = cos(x) ; % Cosine of X
hold on % this makes Matlab hold onto the previous plot
Rhonda = plot(x,y2) ; % named this bitch Rhonda
Rhonda.Color = 'r' ;
Rhonda.LineWidth = lW ; 
Rhonda.LineStyle = '--' ;

% Add a legend to the figure
% General syntax of Legend: Set of Handles, Labels, Position

legend([h, Rhonda], {'Cond1', 'Cond2'}, 'Location', 'southeastoutside')

%% 3 Multi-panel figures
Matt = figure; 
set(Matt, 'Color', 'w') % white background
set(Matt, 'Position', [350 100 800 500]) % these numbers represent the screen size values

% this is how you check your screen size --> get(0,'ScreenSize')

% create subplots
subplot(2,3,1)
plot(x,x) % x vs. x
title('1')

subplot(2,3,2) 
plot(x,y) % sin vs. x
title('2')

subplot(2,3,3)
plot(x,y2) % cos vs. x
title('3')

subplot(2,3,4)
plot(y,y2) % cos vs. sin
title('4')

% change aspect ratio
axis square % make sure that the aspect ratio is even to ensure the circle is represented accurately
 % the screensize that you dicated in the above plot details need to ALLOW
 % this to be feasible. If not, it won't matter if you change this 


%% 4 Lets create a histogram 
% Histogram - utilized for CONTINUOUS VARIABLES

% We also need to talk about the echo operator (;) it turns off the ECHO 
% or
% ; = ECHO OFF //~~// echo meaning the command window output
% A = rand(1e6,1) % outputs 1 million random numbers in the command window
A = randn(1e6,1) ; % this keeps us from killing out output time as the computer writes every single datapoint

% also a seperator of commands
figure; set(gcf,'color','w')

% also it is a vertical concatenation operator
B = [1 ; 2 ; 3] ;
C = [1 , 2 , 3] ;

histHandle = histogram(A,nBins) ;
set(histHandle, 'FaceAlpha', .2) ; 
set(histHandle, 'FaceColor', 'k') ; 

% Alpha = the transparency of your bars
% Goes from 0 to 1
% 0 = completely transparent
% 1 = completely non-transparent

%% 5 Create a Bar Graph
x2 = 1:4;   %4 categories
y3 = x2.^2; % Some function

% This creates the bar graph
subplot(1,2,1)                      % create subplot - 1 row, 2 columns, placed in 1st position
handleBarMoustach = bar(x2,y3)  ;   % plot the bar graph
ylim([min(y3)-hair max(y3)+hair])   % One school of thought - leads to bad ratio representation of data

% Another school- better ratio
ylim([0 max(y3)+hair])

% set the properties of the bars
set(handleBarMoustach, 'FaceColor', [.8 .8 .8]) % using RGB values to set bars to grey
set(handleBarMoustach, 'EdgeColor', 'g') % set edge to green
set(handleBarMoustach, 'LineWidth', .9) % set edge to lW

hold on

% Adding an Error bar to the earlier bargraph
z = ones(4, 1) ; % We represent the error as 'z' (or zed), and assume it is constant. Needs to match the category number (this is why it is FOUR ZEROS)
h16 = errorbar(x2, y3, z) ;
ylim([0 max(y3)+hair+max(z)]) ;
set(h16, 'LineStyle', 'none') ; set(h16, 'LineWidth', lW); h16.Color = 'r' ;
% This creates an symmetic error bar which has lines that go above and
% below the bar's data point for a given category

% Sometimes you want to do ASYMMETRIC ERROR BAR which only goes above or
% below the bar's data point for a given category

subplot(1,2,2)                      % Plot to place in the second subplot position
handleBarMoustach2 = bar(x2,y3) ;   % plot the bar graph
ylim([0 max(y3)+hair+max(z)])       % set y limits

set(handleBarMoustach2, 'FaceColor', [.4 .3 .4]) % using RGB values to set bars to grey
set(handleBarMoustach2, 'EdgeColor', 'b') % set edge to green
set(handleBarMoustach2, 'LineWidth', lW) % set linewidth 
hold on
% Create a plot in the subplot which shows the errorbar but NOT BELOW THE
% BAR'S DATA POINT

% 'negLobe' will denote the length of the line below the bar's data point
% for a given category. We could create individual values for each
% category and assign them specific variable names - however, in this case
% we can simply create a vector of zeros because we want this value to be
% zero for all.

negLobe = zeros(4,1); 
z = ones(4,1) ; % We represent the error in z (zed), and assume it is constant needs to match the category number (this is why it is FOUR ZEROS)

h17 = errorbar(x2,y3, negLobe, z) ; %% WHY DOES THIS FUCK UP
set(h17, 'LineStyle', 'none') ; set(h17, 'LineWidth', lW); h17.Color = 'r' ;


 
%% multi-demnsional figures (poor Man's version)
figure
X = pascal(5) ; % creates a pascal triangle matrix
imagesc(X)
% colormap(jet) %Matlab classic - switched to "Parula" 
% colormap(hot) % These two gives an increased contrast, but color
% perception is CATEGORICAL
% 'Parula' is much more gradual - allows for less visual error inference
% colormap(bone) % just grey
colorbar % This will tell us which number corresponds to which color

% Making our own colormap

% Color map is a MATRIX OF COLOR CORRESPONDENTS

france = [0 0 1; 1 1 1 ; 1 0 0 ] ; 
colormap(france)






