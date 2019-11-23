%% Data Analysis
%The programmer has analysed data from the scores of midterm and final exam
%for an advanced statistics class.
%Hypothesis: Impact of cellphone use and recitation attendance on class
%performance as well as whether there is evidence that midterm and final
%term
%measure similar things.
%Assumption: The data is located in the same directory as the code and the
%grader can load the file on their own if it is in another directory.
%The data file contains four variables: Scores of midterm and final exams
%and whether students attended recitation and/or they were allowed to use
%the cell phone. Students who missed an exam were represented by nans.

%This was created on June 24, 2019 for the Coding class as Assignment 3.
%Contact: Amateur Coder
%amateurcoder99@nyu.edu


%% 0 Initialization: 
clear all %clears the workspace
close all %closes all figures
clc %clears the command window

%% Priors:
rng('shuffle') %Will be useful when using random numbers
pruningMode = 2; %Initializing pruning mode
fS = 12; %Initializing font size
tL = [0.02 0.02]; %Initializing length of tickmarks
rC = ('1.00,0.00,0.00'); %Initializing color of the regression line
rLW = 0.8; %Initializing line width for regression line
lw = 2; %Initializing line width for confidence interval

%% Load the data
load('studentGradesAdvancedStats.mat') %Loads the data into the workspace assuming that the grader has the directory open or could drag it into the workspace before running it

%% Pruning:
%The amateur coder has eliminated data participant wise as it best fit the
%tasks that were asked ahead 
iniData = [attendedRecitation, usedCell, midtermScore, finalScore]; %Arranging all of the data into one matrix
if pruningMode == 2 %When pruning mode equals 2
    cleanData = sum(isnan(iniData),2); %Counts missing values per row, over the 2nd dimension
    removenans = find(cleanData==0); %Only keep rows of students that took the exam
    validData = iniData(removenans,:); %Creating a variable that will have eliminated rows of students who skipped/missed an exam
elseif pruningMode == 1 %The coder will use this when they want to eliminate nans element wise in the future
    ARcleaned = rmmissing(attendedRecitation) %Creating a variable that is without nans 
    FScleaned = rmmissing(finalScore) %Creating a variable that is without nans 
    MScleaned = rmmissing(midtermScore) %Creating a variable that is without nans 
    UCcleaned = rmmissing(usedCell) %Creating a variable that is without nans 
end %Ending the for loop

%% Determining if there is a significant relationship between midterm and final performance

[R,P] = corrcoef(validData(:,3),validData(:,4)); %Outputs the correlation stats for both exams
%With a R of 0.6064, it would be a strong correlation which indicates that
%the performance of say student abc in the midterm was strongly correlated
%with their performance in the final term. If the student did well in the
%mid term, chances are they did well in the final term and same goes for if
%they did not perform well.

finalVSmidterm = figure; %naming our figure
scatter(validData(:,3),validData(:,4)); %commanding the plot
axis equal %keeps axis equal
box off %make the plot neater
xlim([0 100]); %setting limits for our x-axis
ax = gca; %current axes
ax.FontSize = fS; %setting fontsize to 12
ax.TickDir = 'out'; %setting the tickmarks to be directed outside
ax.TickLength = tL; %setting the length of tickmarks
title ('Correlation between Midterm and Final Scores') %Naming our graph
ylabel('Final Scores') %naming the y-axis
xlabel('Midterm Scores') %naming the x-axis
hold on %plot a regression line over the existing graph
%Regression line:
%lsline(ax)
Rline = lsline(ax); %naming our line
Rline.Color = rC; %setting color to the line
Rline.LineWidth = rLW; %setting line width
%The positive slope of the regression line indicates a positive
%relationship between mid term and final term scores. Excluding exceptions,
%students who performed better in mid term have performed better in the
%final term.


%% Data analysis

MidandFinal = [validData(:,3) validData(:,4)]; %Creating a variable that includes only the cleaned midterm and final term scores.
gradeScore = mean(MidandFinal,2); %Creating a new variable that is the result of the average of both exams 
DATA = [validData, gradeScore]; %A grand matrix that includes all our valid variables

%Paired T tests: %This was more suitable because of the type of data we had
%a) Is there an effect of cell phone use on total grade score? 
[sig_1, p_1, CI_1, tstats_1] = ttest(DATA(:,2), DATA(:,5)) %Computing the results for ttest
%The '_1' would help the coder/grader/reader to check the output for each
%ttest. 
%The significance is 1 which indicates that cell phone use did have an
%effect on total grade score. The p value of 1.08490478728695e-54
%strengthens our interpretation

%b) Is there an effect of recitation attendance on total grade score?
[sig_2, p_2, CI_2, tstats_2] = ttest(DATA(:,1), DATA(:,5)); %Computing the results for ttest
%The '_2' would help the coder/grader/reader to check the output for each
%ttest. 
%The significance is 1 which indicates that attending recitation did have an
%effect on total grade score. The p value of 6.11279947411850e-56
%strengthens our interpretation.

%c) Was one exam harder than the other one?
[sig_3, p_3, CI_3, tstats_3] = ttest(DATA(:,3), DATA(:,4)); %Computing the results for ttest
%The '_3' would help the coder/grader/reader to check the output for each
%ttest. 
%The significance is 1 which indicates that one exam was harder than the other but it is difficult to say which one from this test.
%The p value of 2.29671740043321e-06 strengthens our interpretation.



%% ANOVA
%Testing the impact of cell phone use and recitation attendance on total
%grade scores at once
[p,tbl,stats,terms] = anovan(DATA(:,5),{DATA(:,1) DATA(:,2)},'model','interaction'); %Runs a full model of anova with interaction effect
%The results suggests that there is a significant effect of cell phone use and recitation attendance on total
%grade scores individually.
%The p value of 0.0005 and 0 restrengthens our interpretation
%The interaction effect,however, shows that together cellphone use and
%recitation attendance do not have an impact on total grade score at once.

%% Mean differences and resample means
%Bootstrapped means
empiricalMeanDifference = mean(DATA(:,3)) - mean(DATA(:,4)); %Calculating mean difference
%Checking how relaible is our empirical mean difference:
numSamples = 1e5; %number of samples or bootstraps
resampledMeans = nan(numSamples,2); %preallocate a mtrix of nans
n1 = length(validData(:,3)); %length of n1
n2 = length(validData(:,4)); %length of n2
cleanedMidterm = validData(:,3); %renaming our valid mid term scores for convenience
cleanedFinalterm = validData(:,4); %renaming our valid final term scores for convenience
for ii = 1:numSamples %Resample
    index = randi(n1,[n1,1]); %use random integers from n1
resampledMidtermScores = cleanedMidterm (index); %variable that will include the random indices
resampledMeans(ii,1) = mean(resampledMidtermScores); %subsampling from the means
index = randi(n2,[n2,1]); %use random integers from n2
resampledFinalScores = cleanedFinalterm (index); %variable that will include the random indices
resampledMeans(ii,2) = mean(resampledFinalScores); %subsampling from the means
end %ending the for loop


%% Histogram

meanDifferences = resampledMeans(:,1) - resampledMeans(:,2); %Reiterating the mean difference
sortedResampledMeans = sort(meanDifferences); %sorting the means in order of magnitude
md = figure; %naming the figure
histogram(meanDifferences,101) %plotting the histogram
set(gca,'TickDir','out') %setting the tickmarks outside
box off %Make a neater graph
hold on %adding the confidence interval markers

%Confidence interval:
% Pick cutoffs
CIwidth = 95; %Initializing the CIwidth
lowerBound = (100-CIwidth)/2; %Initializing the lower boundary
upperBound = 100-lowerBound; %Initializing the upper boundary

% Find corresponding indices
lowerBoundIndex = round(lowerBound*length(sortedResampledMeans)/100); %Indices we will be using
upperBoundIndex = round(upperBound*length(sortedResampledMeans)/100); %Indices we will be using
%Reach into the SORTED (arranged by magnitude) mean differences to find the
%value of the upper and lower bound of the CI
lowerCI = sortedResampledMeans(lowerBoundIndex); %Our value of the lower CI
upperCI = sortedResampledMeans(upperBoundIndex); %Our value of the upper CI

%add those to the figure
lCI = line([lowerCI lowerCI], [min(ylim) max(ylim)]); %lower confidence interval
set(lCI,'color','r'); %setting the color red
set(lCI,'linewidth',lw); %setting linewidth
uCI = line([upperCI upperCI], [min(ylim) max(ylim)]); %upper confidence interval
set(uCI,'color','r'); %setting the color red
set(uCI,'linewidth',lw); %setting the linewidth
title('Distribution of resampled mean differences between Midterm and Final scores') %giving a title
xlabel('nth resampled mean difference in order of magnitude') %labelling x-axis
ylabel('Magnitude of the resample mean differences') %labelling y-axis
set(gca,'FontSize',fS) %setting the fontsize


%The end