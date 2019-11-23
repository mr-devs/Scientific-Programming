%From now on, we will write everything in scripts, in the editor.
%Everything after the % sign is interpreted as a "comment" and ignored by
%Matlab. The corresponding sign in Python is the #. 
%Whereas you don't *have to* make any comments, I personally increase the
%number of comments all the time. Specifically, so:
A = 5 %This is a command

%I recommend to implement Marr's hierarchy in the comments:
%1) At the beginning of the program, write a paragraph on what the purpose
%of the program is, what it assumes, what the output is, when this was done
%and who is responsible. Basically, write a high level header.

%2) Each code section should have a subheader of what it does
%3) At least in the beginning, I recommend to comment each line briefly as
%to what the variables represent and what is done to them

%This script shows how to use the editor, and how to use Matlab as a
%graphing calculator. It presumes nothing and produces a bunch of figures. 
%06/03/2019: V1 - The code itself
%Pascal Wallisch (your name), pascallisch@gmail.com

% One percent sign sets up a comment

%% Two percent signs set up a code section - the one you have active right now
%is highlighted in yellow. Code sections should be logical segments.
%Modular. Important: If you want to be able to maintain your code, it
%should fit on one screen. Per section. If it gets longer, you should
%abstract or break it up. 

%% 0 Initialization
%Logical errors are predominantly bred by stuff floating around in memory
%that you forgot about. So you should always start from a blank slate.
%This init step is akin to the birth of your program. 

clear all %This clears the memory
close all %Closes all figures
clc %Clears the command window

%Have a block of constants and flags that are defined here. 
stepSize = 0.1; %non-hardcoded step size. 0.1 is finely grained enough.
startPoint = 0; %0 is as good a place as any to start drawing
numCycles = 3; %Number of sine wave cycles you want to represent
endPoint = numCycles * 2 * pi; %The equation of a sine wave in radians
lW = 3; %Our new linewidth
hair = 0.2; %How much breathing room between axis and data
fS = 16; %Our general fontsize
nBins = 21; %number of bins for our histogram, make it an odd number
%% 1 Basic plotting
%This section introduces basic plotting/drawing commands
Taylor = figure %Open a canvas to draw on, explicitly, with handle
x = startPoint:stepSize:endPoint; %This will create 11 numbers from 0 to 10
y = sin(x); %Sine of x. Could be anything 
h = plot(x,y) %Plot y as a function of x
xlabel('time in seconds')
ylabel('Voltage in mV')
title('Voltage over time')
shg %Show graph

%Request 1: Change line thickness with the get/set combo
get(h) %Gets the properties of the object
set(h,'LineWidth',lW); 
%General set syntax: Name of handle to modify, property to modify, then
%target value

%Request 2: Change plotting range, make sure there is a hair of air between
%data and axis
%Another way of doing it. You know the set way
xlim([startPoint - hair endPoint + hair])

%These are equivalent 
set(gca,'XLim',[startPoint - hair endPoint + hair])

%Request 3: Make the background of the figure white
set(Taylor,'Color','y')
set(gcf,'Color','y')

%Handles are names of objects/axes/figures
%By naming your objects/axes/figures, you can reference them for
%modification

%If you have only one object/figure/axis, gca, gco and gcf will be just
%fine. But if you have multiple of each, you need handles

%Request 4: Change fontsize (an axis property)
set(gca,'FontSize',fS)

%Request 5: We can't afford color charges, so we have to change the line
%color to black. Let's do that with the new object-oriented style
h.Color = 'k';

%Request 6: Make sure tickmarks correspond to data ink
set(gca,'TickDir','out')
box off

%% 2 Multi-line (multi-object) plots
%Adding a 2nd line to the graph
y2 = cos(x); %Cosine
hold on %If you don't hold on, the new plotting command will erase what is on it
Rhonda = plot(x,y2); %Plot cosine as a function of x and christen it "Rhonda"
Rhonda.Color = 'r'; 
Rhonda.LineWidth = lW;
Rhonda.LineStyle = '--'; %Dashed
shg

%Adding a legend to the figure
%General syntax: Set of object handles, Labels, Position
legend([h Rhonda],{'Cond1', 'Cond2'},'Location','SouthEastOutside')

%% 3 Multi-panel figures
Matt = figure; %Why it is a good idea to name your figures
set(Matt,'Color','w') %White background
set(Matt,'Position',[200 100 1500 800])

%Going forward, we will automate this, but today, we'll type it out, so you
%see what is going on
subplot(2,3,1)
plot(x,x) %x vs. x
title('1')
subplot(2,3,2)
plot(x,y) %sin vs. x
title('2')
subplot(2,3,3)
plot(x,y2) %cos vs. x
title('3')
axis off
subplot(2,3,4)
plot(y,y2) %cos vs. sin
title('4')
axis square %This makes sure that the aspect ratio is square

%% 4 Histograms of random numbers
%Histogram: Plot the frequency of a continuous distribution in terms of how
%often they happen within a certain interval (the bin)
% We also need to talk about the echo operator (;)
A = randn(1e6,1); %This draws 1 million random numbers from a normal distribution and assigns it to A
%At the end of a line, it means "echo off", meaning "do it, but don't show
%me the output. It is also a separator of commands. 
figure; set(gcf,'color','w')
%It is also vertical concetenation (vertcat)
B = [1; 2; 3]
C = [1, 2, 3]
histHandle = histogram(A,nBins);
set(histHandle,'FaceAlpha',0.2) %0 = completely transparent, 1 = completely intransparent
set(histHandle,'FaceColor','k')

%% 5 Bar graphs
x2 = 1:4; %4 categories
y3 = x2.^2; %Some function of x
subplot(1,2,1)
handleBar = bar(x2,y3) %The bar graph
ylim([min(y3)-hair max(y3)+hair]) %One school of thought - represent the range of the data
%Other school of thought: y-axes have to start with 0, otherwise the ratio
%between categories is not meaningful
set(handleBar,'FaceColor',[0.8 0.8 0.8])
set(handleBar,'EdgeColor','g')
set(handleBar,'LineWidth',lW)
hold on
z = ones (4,1); %We represent the "error" in z, and we assume it is constant
h16 = errorbar(x2,y3,z) %Our 16th handle
ylim([0 max(y3)+hair+max(z)]) %One school of thought - represent the range of the data
set(h16,'LineStyle','none'); set(h16,'LineWidth',lW); h16.Color = 'r';
shg

%This was a symmetric error bar. It will work in most cases. Sometimes, you
%want to be able to do asymmetric ones. Sometimes, per journal policy, you
%only want the positive lobe.
negLobe = zeros(4,1); %We should replace the 4 everywhere with "numCat" in the constants
%This will create 4 zeros
subplot(1,2,2)
ylim([min(y3)-hair max(y3)+hair]) %One school of thought - represent the range of the data
%Other school of thought: y-axes have to start with 0, otherwise the ratio
%between categories is not meaningful

hold on
z = ones (4,1); %We represent the "error" in z, and we assume it is constant
h17 = errorbar(x2,y3,negLobe,z) %Our 17th handle
ylim([0 max(y3)+hair+max(z)]) %One school of thought - represent the range of the data
set(h17,'LineStyle','none'); set(h17,'LineWidth',lW); h17.Color = 'r';
handleBar2 = bar(x2,y3) %The bar graph
set(handleBar2,'FaceColor',[0.8 0.8 0.8])
set(handleBar2,'EdgeColor','g')
set(handleBar2,'LineWidth',lW)
shg

%% 6 Multi-dimensional figures (poor man's version)
figure
X = pascal(5) %Create array X as pascal's triangle
imagesc(X) %Interpret and show array X as a heat map
%colormap(jet) %This is Matlab classic. It switched to "Parula" in 2014b
%colormap(hot)
colormap(bone) %Just grey
colorbar %This will tell us which number corresponds to which color
%Making our own colormap: 
%A color map is literally just a matrix of color correspondences, in RGB
france = [1 0 0; 1 1 1; 0 0 1;1 0.5 1]; %maybe
colormap(france)
shg