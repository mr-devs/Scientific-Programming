%Assignment 3
%The purpose of this assignment is to analyze data from the midterm and
%final exam in an advanced statistics class to test the hypotheses about
%the impact of cell phone use and recitation attendance on class
%performance, as well as whether there is evidence that midterm and finals
%measures similar things.
%Header
%First, we will load the data into our workspace and clean it. We will
%clean it by removing the NaN's and replacing them with the class average
%means of each the midterm and the final.
%Second, we will determine whether there is a significant correlation
%between the midterm and final performance and make a scatter plot of
%midterm vs. final to see this significance correlation visually.
%Third, we will create a new, fifth variable called "gradeScore" to
%represent the total grade score which is made up by the average between
%midterm and final score. This variable, along with the existing four
%variables in the original dataset, are arranged in a matrix called "DATA"
%and independent and paired t-tests are run on the data.
%Fourth, we will do a two-way ANOVA to test the impact of cell phone use
%and recitation attendance on total grade score.
%Finally, we will calculate the mean difference between midterm and final
%score and use bootstrapping methods to assess if the difference is
%statistically reliable. We will then make a histogram of the means.

%Dependencies/assumptions: Assumes the dataset is in the same path as the
%script.
%6/23/19

%% 0 Initialization ("Birth") to avoid logical errors
%Step 1: "Blank slate"
clear all %Clear memory
close all %Closes open figures
clc %Clear command history

%Step 2: Load data
load('studentGradesAdvancedStats.mat')

%Step 3: Priors: List all variables used in the code
%Graphing variables
lW = 3; %Line width
fS = 9; %Font size
startPoint = 0; %Start point of x-axis
endPoint = 20; %End point of x-axis
size = 80; %Size of scatter plot points

%% 1 Pruning/Cleaning Data

%Cleaning data by taking out the NaNs and replacing them with the mean
%scores (impute the mean) for each the midterm and the final, preserving
%the 100 items in the dataset.

cleanFinalScore = [finalScore];
cleaningFinal = (1:length(cleanFinalScore))';
cleanFinalScore = interp1(cleaningFinal(~isnan(cleanFinalScore)), ...
    cleanFinalScore(~isnan(cleanFinalScore)), cleaningFinal)

cleanMidtermScore = [midtermScore];
cleaningMidterm = (1:length(cleanMidtermScore))';
cleanMidtermScore = interp1(cleaningMidterm(~isnan(cleanMidtermScore)), ...
    cleanMidtermScore(~isnan(cleanMidtermScore)), cleaningMidterm)

%% 2 Determine if there is a significant correlation between midterm and final

%Step 1) Calculate the correlation between cleaned midterm and final scores
corr(cleanFinalScore, cleanMidtermScore) %Calculating the correlation
[sig, p] = corr(cleanFinalScore, cleanMidtermScore) %Two output variables,
    %significance and p value?
[sig, p, CI, tstats] = corrcoef(cleanFinalScore, cleanMidtermScore) %Full output
r = (corrcoef(cleanFinalScore, cleanMidtermScore)) %Calculates Pearson's r

%p = 1.0235e-9 with a correlation of 0.56, which is a medium-high correlation.
%We take this to indicate that midterm scores are moderately highly
%correlated with final scores.


%Yes, significant


%Step 2) Make a scatter plot of midterm vs final performance
figure %Open figure
scatter(cleanFinalScore, cleanMidtermScore, size, 'filled', '^', 'r')
%Makes scatter plot with 
xlabel('Midterm Performance Scores') %Sets a label for the x-axis
ylabel('Final Performance Scores') %Sets a label for the y-axis
title('Midterm vs. Final Performance Scores') %Sets a title for the graph
set(gca,'FontSize',fS) %Sets font size for graph
set(gca, 'TickDir', 'out') %Sets tick marks on graph to the outside
set(gca, 'LineWidth', lW); %Sets linewidth as defined in priors
lsline %Least squares linear regression line at best fit
set(lsline, 'LineWidth', lW);
shg %Show graph

%The graph is showing a significant positive correlation


%% 3 Create a 5th variable and matrix & t-tests with 3 hypotheses

gradeScore = (cleanFinalScore + cleanMidtermScore) / 2; %Represents total grade score, calculation and creation of new variable "gradeScore"

DATA = [attendedRecitation, finalScore, midtermScore, usedCell, gradeScore]; %Creating the matrix with data

%Do suitable t-tests testing the following hypotheses:

%a) Is there an effect of cell phone use on total grade score?
ttest2(usedCell, gradeScore) %Independent two-sample t-test
[sig, p, CI, tstats] = ttest2(usedCell, gradeScore) %Full output

%Yes, there is an effect of cell phone use on total grade score because
%it is significant with p = 2.8126e-97.

%The ans as "1" indicates that the t-test rejects the null hypothesis at
%the 5% significance level. (On the other hand: if the ans is "0" the null
%hypothesis is accepted.)

%b) Is there an effect of recitation attendance on total grade score?
ttest2(attendedRecitation, gradeScore) %Independent two-sample t-test
[sig, p, CI, tstats] = ttest2(attendedRecitation, gradeScore) %Full output

%Yes, there is an effect of recitation attendance on total grade score
%because it is significant with p = 2.8126e-97.

%The ans as "1" indicates that the t-test rejects the null hypothesis at
%the 5% significance level. (On the other hand: if the ans is "0" the null
%hypothesis is accepted.)

%c) Was one exam harder than the other?
ttest(cleanFinalScore, cleanMidtermScore) %Pairwise t-test
[sig, p, CI, tstats] = ttest(cleanFinalScore, cleanMidtermScore) %Full output

%Yes, because it is significant with p = 1.7280e-6.

%The ans as "1" indicates that the t-test rejects the null hypothesis at
%the 5% significance level. (On the other hand: if the ans is "0" the null
%hypothesis is accepted.)

%% 4 ANOVA

anovan(gradeScore, {attendedRecitation usedCell}, 'model', 'full')

%This ANOVA tests the impact of cell phone use and recitation attendance on
%total grade score at once and notes any interaction effect.

%The two-way ANOVA output suggests that there is a significant effect of
%recitation attendance on total grade score (p = 0.0001) and significant
%effect of cell phone use on total grade score (p = 0). There is no
%significant interaction between recitation attendance and cell phone use
%on total grade score (p = 0.7456).

%Essentially, individually, recitation attendance and cell phone use have
%an effect on total grade score but do not have effect when put together.


%% 5 Calculate mean difference between midterm and final score

%Use bootstrapping

empiricalMeanDifference = mean(cleanMidtermScore) - mean(cleanFinalScore)
numSample = 1e5; %100k times ;
resampledMeans = nan(numSample, 2); %Preallocate memory for all resampled
%means, 1 column per movie, each run will be a row

lMidterm = length(cleanMidtermScore); %Length of cleaned midterm scores
lFinal = length(cleanFinalScore); %Length of final scorse

for ii = 1:numSample %Resample
    index = randi(lMidterm, [lMidterm, 1]); %We will use this index to subsample from the M1ratings
    resampledMidterm = cleanMidtermScore(index);
    resampledMeans(ii, 1) = mean(resampledMidterm);
    %This would be a good place to write a resampling function because all
    %that is necessary to do it comes from the input array itself and we
    %literally have to do it again for the 3rd movie, which means if we
    %don't make it a function, we'll probably make copy/paste mistakes.
    index = randi(lFinal, [lFinal, 1]); %We will use this index to subsample from the M1ratings
    resampledFinal = cleanFinalScore(index);
    resampledMeans(ii, 2) = mean(resampledFinal); %Subsampling from means
end

meanDifferences = resampledMeans(:,1) - resampledMeans(:,2);
%Uses resampled means to plot data
figure
histogram(meanDifferences)
shg

%Confidence intervals
%1) Sort resampled means
%2) Find your cutoffs (lower and higher)
%3) Use cutoffs to determine percentiles
%4) Use those to find the CI

%This figure is strictly optional, but it will help you understand what is
%going on if you see this for the first time
sortedResampledMeans = sort(meanDifferences); %This sorts the resampled means
%Sorting pertains to "arrange by magnitude" here

%Step 1) Pick cutoffs
CIwidth = 95; %CI 95%
lowerBound = (100-CIwidth)/2; %
upperBound = 100-lowerBound;

%Step 2) Find corresponding indices
lowerBoundIndex = round(lowerBound*length(sortedResampledMeans)/100) %These are the indices, not the values
upperBoundIndex = round(upperBound*length(sortedResampledMeans)/100)

%Step 3) Reach into the SORTED (arranged by magnitude) mean differences to
%find the value of the upper and lower bound of the confidence interval
lowerCI = sortedResampledMeans(lowerBoundIndex);
upperCI = sortedResampledMeans(upperBoundIndex);

%Step 4) Add those to the figure
histogram(meanDifferences)
lCI = line([lowerCI lowerCI], [min(ylim) max(ylim)]); set(lCI, 'color', 'g'); set(lCI, 'linewidth', lW)
uCI = line([upperCI upperCI], [min(ylim) max(ylim)]); set(uCI, 'color', 'g'); set(uCI, 'linewidth', lW)

set(gca, 'FontSize', fS) %Sets font size for graph
set(gca, 'TickDir', 'out') %Sets tick marks on graph to the outside
title('Distribution of resampled mean differences of cleaned midterm and final scores') %Sets a title for the graph
xlabel('Magnitude of the resampled difference') %Sets a label for the x-axis
ylabel('nth resampled mean difference in order of magnitude') %Sets a label for the y-axis
xlim([startPoint endPoint])
shg %Show graph

%Interpretation: 
%The empirical mean difference following resampling methods between the
%cleaned midterm and final scores is 8.24.


%% 6 Save the workspace

%save('Assignment3')

%% 7 Fin