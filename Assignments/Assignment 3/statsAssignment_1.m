%% The Impact of CellPhone Use and Recitation Attendance on Grades %%

% Project Summary:
    % This project analyzes the relationship between a students cellphone
    % use, as well as their recitation attendance on midterm and final
    % grades. Furthermore, general analysis between the midterm and final grades
    % is undertaken. Data was gathered in an education experiment. 
    
% INPUT: 
    % ~ studentGradesAdvancedStats.mat: the data file which is the focus of this analysis.
    % Variables: 
        % ~ attendedRecitation: whether or not the student attended
        % recitation (1 = yes, 0 = no)
        % ~ finalScore: final exam scores
        % ~ midtermScore: midterm scores
        % ~ usedCell: whether or not the student was allowed to use their
        % cellphone during class (1 = yes, 0 = no)
    
% OUTPUT: 
    % ~ correlational analysis between midterm and final grades 
        % scatterplot and linear regression line
    % ~ t-test analysis of multiple groups
    % ~ 2-way ANOVA of multiple groups
    % ~ 100K bootstrapping proceedure to assess difference between midterm
    % and final grades
        % histogram and 95% confidence interval

% Author:           Mystery (Wo)Man        
% Contact Email:    mystery(wo)man@nyu.edu
% Date Created:     06/24/2019 (mm/dd/yyyy)

% Revision History (date format: mm/dd/yyyy)

% Revision #: Original
% Date              % Author        % Description
% 06/24/2019        % M. (Wo)Man    % Script was created

%% 0 Initialize

% 0.a ~ Tabula Rasa
clear all
close all
clc

% 0.b ~ Priors
scatterPointSize = 7.5          ;
confidenceIntervalWidth = 95            ; %CI 95%

% 0.c ~ Graphing Variables - Properties for the final plot
fS          = 14                                            ;   % General fontsize for final graph
lW          = 1.5                                           ;   %Line width
arbitraryHeightOfCILine = [3500 3700] ;
centerOfArbitraryLine = 3600 ;

%% 1 Loader: Transduction - bringing your data from the format of origin into a matrix format

% load the data in a way that makes sense
dataPath = 'C:\Users\mdeve\OneDrive\Documents\NYU\2019 Summer\Assignments\Assignment 3' ; 
cd(dataPath)                            ;   % change the current directory to the this path
load('studentGradesAdvancedStats.mat')  ; 

allData = table                                 ;
allData.MidtermScore = midtermScore             ;
allData.FinalScore = finalScore                 ;
allData.AttendedRecitation = attendedRecitation ;
allData.UsedCell = usedCell                     ;   


%% 2 Pruning/cleaning ("Thalamus") 

% prune the data to eliminate participant-wise NaNs (as is standard in
% experimental psychology

validDataTable = rmmissing(allData) ; % Removes entire participant data if missing either midterm or final score.

%% 3 Formatting

% may not be anything to do here

%% 4 ~ Checking for Significant Correlations

% Determine whether there is a significant correlation between midtern and
% final performance. (corrcoef or corr to do so) 

[R,P,RL,RU] = corrcoef(validDataTable.MidtermScore, validDataTable.FinalScore)    ;   % Find the correlation coefficients between midterm and final exam scores

% Now Create a scatter plot of that data, including the regression line.
scatFig = subplot(2,1,1)                                                                            ;   % Open a figure
scatterPlot = scatter(validDataTable.MidtermScore, validDataTable.FinalScore, scatterPointSize)     ;   % Draw a scatterplot with midterm and final exam datapoints
regLine = lsline                                                                                    ;   % Create a regression line
hold on                                                                                             ;   % Hold the figure to make property adjustments...

% Adjust plot properties in order to clarify plot details...
xlabel('Midterm Scores')                                            ;   % Add x-axis label
ylabel('Final Exam Scores' )                                        ;   % Add y-axis label
title('Final Exam Grades as a Function of Midterm Exam Grades')     ;   % Create Title of Graph
set(gca,'FontSize', fS)                                             ;   % Setting font size for all graph labels to 14
set(gca,'TickDir', 'out')                                           ;   % Setting tick marks to be outside of graph
set(gca,'box','off')                                                ;   % Get rid of the unnecessary tic marks
set(lsline, 'LineWidth', lW)                                        ;   % Change linewidth
legend('Data', 'Regression Line', 'Location', 'southeastoutside')   ;   % Place legend outside of the plot

% Output a nice summary of this linear model in the command window.
    % (Intentionally not surpressed)
correlationSummary = fitlm(validDataTable.MidtermScore, validDataTable.FinalScore)   

% What do the results mean in terms of midterm and final measure?
% Comments:
    % ~ We can see that the F-statistic is quite high and the p-value is
    % extremely low, far below .05. 
    % ~ This allows us to accept that there is a significant positive correlation 
    % between midterm and final grade scores.
    % ~ This means that as one variable goes up (or down), the other tends
    % to do the same.
    % ~ However, this correlation does not tell us anything about the
    % causality of this relationship. Either the midterm grade or the final
    % grade could be responsible for causing the other variable to rise and
    % or fall with it.
    

%% 5 ~ t-Tests

% Create a 5th variable: gradeScore, which represents the total grade
% score, made up by the average between midterm and final score (they each
% have equal weights). 

% arrange all variables in a matrix within 5 columns called "DATA".

validMidterm        = validDataTable.MidtermScore                                   ;   % Midterm Scores
validFinal          = validDataTable.FinalScore                                     ;   % Final Scores
gradeScores         = (validDataTable.MidtermScore + validDataTable.FinalScore)/2   ;   % gradeScore Scores
validAttendedRec    = validDataTable.AttendedRecitation                             ;   
validUsedCell       = validDataTable.UsedCell                                       ;

DATA = [validMidterm validFinal gradeScores validAttendedRec validUsedCell]         ;

% Do suitable (independent or PAIRED) t-tests to test the following three
% hypotheses:
    % a) Is there an effect of cell phone use on total grade score?

disp('a) Is there an effect of cell phone use on total grade score?')
[sig, p, CI, tstats] = ttest2(DATA(:,3), DATA(:,5))   % Full output of independent t-test 
disp('See Comments in Script')
disp('---------------------------')

% Comment: Utilizing an alpha level of .05, we can reject the null
% hypotheses and conclude that there is a significant difference in 
% total grade scores as a result of cell phone use. When students were not
% allowed to use their phones, they earned better grades.
    % p = 1.0614e-84
    % t = 36.5691
    % df = 178
    % CI = 57.8344 <--> 64.4323

% --------------------------------------------------------------

% b) is there an effect of recitation attendance on total grade score?    
disp('b) is there an effect of recitation attendance on total grade score?')
[sig, p, CI, tstats] = ttest2(DATA(:,3), DATA(:,4))   % Full output of independent t-test 
disp('See Comments in Script')
disp('---------------------------')

% Comment: Utilizing an alpha level of .05, we can reject the null
% hypotheses and conclude that there is a significant difference in 
% total grade scores as a result of recitation attendence. If students
% attended recitation, they earned better grades.
    % p = 1.0316e-84
    % t = 36.5758
    % df = 178
    % CI = 57.8455 <--> 64.4434

% --------------------------------------------------------------
    
% c) Was one exam harder than the other one?
disp('c) Was one exam harder than the other one?')
[sig, p, CI, tstats] = ttest(DATA(:,1),DATA(:,2))   % Full output of Pairwise t-test 
disp('See Comments in Script')
disp('---------------------------')

% Comment: Utilizing an alpha level of .05, we can reject the null
% hypotheses and conclude that there is a significant difference in 
% total grade scores as a result of recitation attendence. If students
% attended recitation, they earned better grades.
    % p = 2.2967e-06
    % t = 5.0536
    % df = 89
    % CI = 5.1107 <--> 11.7337

% Can't do all of these because we are increasing Type I error to
    % unacceptable levels. Need an ANOVA analysis...

%% 6 ~ Analysis of Variance

% Run a 2-way ANOVA to test the impact of cell phone use and recitation
% attendance on total grade score at once. 

hold on
disp('A Two-Way ANOVA:')
[p,tbl,stats,terms] = anovan(DATA(:,3), {DATA(:,4),DATA(:,5)}, ...
    'model','interaction','varnames',{'Attended Recitation','Cell Use'} )

% Comments:
    % Based on the ANOVA table, the F Values and prob > F for both attended recitation
    % and cellphone use have a significant effect on the mean gradeScores.
    % However, there does not appear to be an interaction between these
    % variables. 
    
%% Bootstrap 100K: Mean Difference between Midterm and Final

% Calculate the mean difference between midterm and final score. Use
% bootstrapping methods to assess whether this difference is statistically
% reliable. 

%a) Restate explicitly the empirical mean difference (what needs to be
%explained). This is what we have
empiricalMeanDifference = mean(validDataTable.MidtermScore)-mean(validDataTable.FinalScore) ;

%Question: How stable/reliable is this mean difference (how does it
%distribute)? This is what we want.
%In the absence of unlimited funding, we resample what we have
numSamples = 1e5; %100k times
resampledMeans = nan(numSamples,2); %Preallocate memory for all resampled means, 1 column per movie, each run will be a row
nMidterm = length(validDataTable.MidtermScore); 
nFinal = length(validDataTable.FinalScore); 

for ii = 1:numSamples %Resample
    index = randi(nMidterm,[nMidterm, 1]); %We will use this index to subsample from the M1ratings
    resampledMidterms = validDataTable.MidtermScore(index); 
    resampledMeans(ii,1) = mean(resampledMidterms);
    %This would be a good place to write a resampling function because
    %all that is necessary to do it comes from the input array itself
    %and we literally have to do it again for the 3rd movie, which means
    %if we don't make it a function, we'll probably make copy/paste
    %mistakes
    index = randi(nFinal,[nFinal, 1]); %We will use this index to subsample from the M1ratings
    resampledFinals = validDataTable.FinalScore(index); 
    resampledMeans(ii,2) = mean(resampledFinals);
    %I almost forgot to update one of the M's. 
end

% Differences and plotting them
meanDifferences = resampledMeans(:,1) - resampledMeans(:,2) ; 
bootstrapFig = subplot(2,1,2) ;
histogram(meanDifferences,100)
hold on
meanDifferencesCI = prctile(meanDifferences, [2.5, 97.5]);

%Step 4) Add those to the figure
lowerCI = line([meanDifferencesCI(1) meanDifferencesCI(1)], arbitraryHeightOfCILine, 'color', 'k', 'linewidth', lW) ;
upperCI = line([meanDifferencesCI(2) meanDifferencesCI(2)], arbitraryHeightOfCILine, 'color', 'k', 'linewidth', lW) ;
connectingCI = line([meanDifferencesCI(1) meanDifferencesCI(2)], [centerOfArbitraryLine centerOfArbitraryLine],'color', 'k', 'linewidth', lW) ; 
connectingCI.LineStyle = '--' ;
set(gca, 'FontSize', fS) %Sets font size for graph
set(gca, 'TickDir', 'out') %Sets tick marks on graph to the outside
title('Mean Differences of Valid Midterm and Final Scores (100K Bootstraps)') %Sets a title for the graph
xlabel('Difference between Midterm and Final Grade') %Sets a label for the x-axis
ylabel('Number of Resamples') %Sets a label for the y-axis
legend ('Resampled Mean Differences', '95% Confidence Interval', 'location', 'southeastoutside')
box off

% Comments:
    % A 95% confidence interval drawn over 100K bootstrapped samples of the
    % mean difference between valid midterm and final grades indicates that
    % the difference does not include 0 (if it did, it would keep us from
    % rejecting the null hypothesis). Thus, we can conclude that the
    % midterm grades are significantly higher than the final grades. 
    
    % There are a number of ways that this can be interpretted from a
    % theoretical perspective. For example, the final was simply harder
    % than midterm - or - the flu was going around the week before the
    % final was given and a large portion of the class was unable to study
    % properly. Without further insight into how the experiment was
    % controlled, this and other options can't be ruled out. 
    
%% 5 Plotter (Output)

save('AdvancedStats_Analysis.mat')

