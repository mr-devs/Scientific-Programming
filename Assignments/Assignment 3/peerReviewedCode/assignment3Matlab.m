%% Header: Assignment 3
%This script computes inferential statistical tests on the data of 100
%students in an advanced statistics class
%Goals:
    %Clean and prune the data
    %Correlation between midterm and final score: correlation,
%scatterplot and interpret the findings in the comments
    %Create a new matrix with attendedRecitation, finalScore,
%midtermScore, usedCell and a new column: gradeScore (mean of midterm and 
%final scores)
        %Execute the appropriate t-tests on the following pairs and 
    %interpret the findings in the comments
            %1) Effect of cellUse on gradeScore
            %2) Effect of attendedRecitation on gradeScore
            %3) Midterm Score and finalScore
    %Run an ANOVA where the independent variables are attendedRecitation
    %and cellUse and the dependent variable is gradeScore and 
        %interpret the findings in the comments
    %Use bootstrapping to find the mean difference between the midterm
%and the final scores. Use 100,000 resamples.
        %Additionally: make a histogram with a 95% CI and comment the
    %interpretation
    
%Inputs: the 'studentGradesAdvancedStates.mat' workspace, which has the
%midterm and final scores, as well as information on if the students attended 
%the recitation and if they used their cellphones during class

%Assumptions: the 'studentGradesAdvancedStates.mat' folder is in the
%current working directory

%Outputs:
    %Correlation statistics and scatterplot between midterm and final
    %scores
    %t-test results for the 3 aforementioned pairs (usedCell v.
    %gradeScore, attendedRecitation v. gradeScore, and midterm v. final
    %ANOVA output where the independent variables are 1. usedCell, 2. 
    %attended recitaiton and the dependent variable is gradeScore
    %Results of boostrapping resampling and histogram of the bootstrapped means 
        
%% 0 Initialization
%Blank slate
clear all %clears memory
close all %clears open figures
clc %clears command window

%initializing variables
minScore = 0; %minimum score on exams
maxScore = 100; %maximum score on exams
numCleaned = 90; %total number of participants who have both midterm and 
%final scores
rng('shuffle') %sets the seed of the randome number generator
gradeScore = zeros(100,1); %preallocating gradeScore so that it can be 
%added to the initial matrix
numSamples = 1e5; %number of samples we want to take
%% 1 a) Loader
load('studentGradesAdvancedStats.mat'); %loading the student file

%% 1 b) Clean and prune the data
%In order to be conservative, I am going to clean the data
%participant-wise, meaning that if a student does not have either of
%the two exam scores, they will be removed from further analysis.
concatData = [midtermScore, finalScore, gradeScore, usedCell, attendedRecitation]; 
%Horizontal concatenation of all the data into one matrix
countNans = sum(isnan(concatData),2); %Counts missing values (nans) per row, 
%over the 2nd dimension
idClean = find(countNans==0); %Only keep rows of students that took both exams
DATA = concatData(idClean,:); %makes it so there is only valid data (no NaNs
%in the DATA file)
%% 2 Correlation between midterm and final scores


scatPlot = figure; %assigns a handle to the figure
%Setting x, y 
X = DATA(:,1); %assigning the midterm scores to the x value
Y = DATA(:,2); %assigning the final scores to the y value
[coeff, p] = corrcoef(X,Y); %runs Pearson's r and outputs the correlation 
%coefficient and the p value
x_pos = 5; %x position for the box with the stats
y_pos = 90; %y position for the box with the stats
corrRValue = 'r = 0.64';  %text with stats for figure
corrPValue = 'p < .001***'; %text with stats for figure
corrStatsConcat = [corrRValue newline corrPValue];

%correlation coefficient Pearson's r = 0.6064 and p < .0001
%Therefore, the relationship between midterm and final scores is a strong,
%positive, significant relationship.

%%making/formatting the scatterplot
scatter(X,Y) %creates the scatterplot
regLine = lsline; %assigns lsline to the handle regLine
regLine.LineWidth = 1; %makes the regression line thicker
regLine.Color = 'r'; %changes the line color to red
xlabel('Midterm Scores'); %Labels the x axis
xlim([minScore maxScore]) %setting the bounds of the x axis
ylim([minScore maxScore]) %setting the bounds of the y axis
ylabel('Final Scores'); %Labels the y axis
title('Relationship Between Midterm and Final Scores');
corrStats = text(x_pos,y_pos,corrStatsConcat);
hold on
set(gca, 'TickDir', 'out'); %Takes the tick marks and puts them on the 
%outside of the graph
box off %turns off the box that usually outlines the graph
shg %shows the graph

%% 3 a) gradeScore variable and new matrix
%goal: create a gradeScore variable that finds the mean of the midterm and
%the final scores 

for ii = 1:numCleaned %for all 90 students
    DATA(ii,3) = (DATA(ii,1) + DATA(ii,2))/2; %gradeScore is equal to
    %the midterm score plus the final score divided by 2
end %getting the mean of the midterm and 

%% 3 b) t-tests 
%For each of the following comparisons, I will be using t-tests
%% 3 b) i) cellphone use impact on gradescore
%Method: create new arrays to which gradeScore data can be assigned as a
%function of whether students used their cellphone or not
yesUsedCell = NaN((length(DATA)),1); %preallocate matrix for when students
%used their cellphone 
noUsedCell = NaN((length(DATA)),1); %preallocate matrix for when students
%DID NOT used their cellphone 
for ii = 1:numCleaned %for numbers 1 through numCleaned
    if DATA(ii,4) == 0 %if the specified cell in column 4 of the data matrix is 0
        noUsedCell(ii,1) = DATA(ii,3); %input the gradeScore data of the same row
        %number into noUsedCell
    elseif DATA(ii,4) == 1 %otherwise, if the specified cell in column 4
        %is equal to 1
        yesUsedCell(ii,1) = DATA(ii,3); %input the gradeScore data of the 
        %same row into yesUsedCell
    end
end

%removing the nans
cleanNoUsedCell = rmmissing(noUsedCell); %uses rmmissing to remove nans from 
%noUsedCell and assigns that data to cleanNoUsedCell
cleanYesUsedCell = rmmissing(yesUsedCell); %uses rmmissing to remove nans from 
%noUsedCell and assigns that data to cleanYesUsedCell

[cellGrade, p, ci, stats] = ttest2(cleanNoUsedCell,cleanYesUsedCell)
%did not end with a semi-colon intentionally, wanted the grader to see the output
%t-test for independent means that will provide the p value, confidence 
%interval, t value, and degrees of freedom

%interpret: results show that t(88) = 7.6374, p < .001, and the 95% CI = [14.7239, 25.0864]
%These results suggest that there is a statistically significant differnece
%between average grade scores of students who use cell phones during class
%and those who did not.

%% 3 b) ii) attended recitation impact gradeScore

yesAttended = NaN((length(DATA)),1); %preallocate yesAttended so it has 
%one column and 90 rows of nans
noAttended = NaN((length(DATA)),1); %preallocate noAttended so it has 
%one column and 90 rows of nans

for ii = 1:numCleaned %for all numbers 1 to numCleaned
    if DATA(ii,5) == 0 %if the specified cell in column 4 of the data 
        %matrix is 0
        noAttended(ii,1) = DATA(ii,3); %input the gradeScore data (column 3)
        %of the same row number into noAttended
    elseif DATA(ii,5) == 1 %if the specified cell in column 4 of the data 
        %matrix is 1
        yesAttended(ii,1) = DATA(ii,3); %input the gradeScore data (column 3)
        %of the same row number into yesAttended
    end
end

%removing the nans
cleanNoAttended = rmmissing(noAttended); %removes the nans from noAttended
%when assigns elements from noAttended to cleanNoAttended
cleanYesAttended = rmmissing(yesAttended); %removes the nans from yesAttended
%when assigns elements from noAttended to cleanYesAttended

[attendGrade, p, ci, stats] = ttest2(cleanNoAttended,cleanYesAttended) 
%t-test for independent means that will provide the p value, confidence 
%interval, t value, and degrees of freedom

%interpret: 
    %Output t(88) = -4.8073, p < .0001 and the 95% CI = [-20.3215, -8.4341]
%These results suggest that students who attended
%recitation did significantly better in terms of their average scores in
%the course than students who did not.

%% 3 b) iii. do the midterm exam and the final exam suggest that the two exams
%are similar in terms of level of difficulty?
%t-test for paired means
%The midterm scores (column 1) versus the final scores (column 2)
[midFinal, p, ci, stats] = ttest(DATA(:,1),DATA(:,2)) %t-test for paired
%means that will output the p value, confidence interval, t value and
%degrees of freedom
%output: 
    %t(89) = 5.0536, p < .0001, CI = [5.1107,11.7337]
%interpretation: Using the scores on the exams as a proxy, these results 
%suggest that there is a significant difference between the midterm and final scores, 
%such that the final was statistically significantly harder than the
%midterm

%% 4) ANOVA 
%independent variables: usedCell (2 levels), attendedRecitation (2 levels)
%dependent variable: gradeScore

[p,tbl,stats,terms] = anovan(DATA(:,3),[DATA(:,4) DATA(:,5);],'model','interaction', 'varnames',{'Used Cellphone','Attended Recitation'});
%The above code runs an anova where usedCell and attendedRecitation are the
%independent variables and gradeScore is the dependent variable

%**The following commented line of code creates a graph to view the
%directions of the lines
%interactionplot(DATA(:,3),[DATA(:,4) DATA(:,5);], 'varnames',{'Used Cellphone','Attended Recitation'});

%Output
    %Main effect of using cellphone, F(1,86) = 51.17 p<.001
    %Main effect of attending recitation, F(1,86) = 18.27 p<.001
    %Non-significant interaction of usedCellhphone * attendedRecitation, 
%F(1,86) = .17, p = 0.6854
    %To understand the impact of cellphone use and recitation attendance on
%average grades, I used a 2(cellphone use - yes or no) x 2(attended 
%recitation - yes or no) ANOVA, in which the independent variables are 
%grouping variables. The results support the notion that cellphone use and 
%attending recitation individually impacted the average grades in the 
%advanced statistics class,but they do not interact with one another to 
%impact grades.


%% 5) Bootstrapping
%Goal: examine the mean difference between midterm and final scores using
%the bootstrapping method (with 100,000 samples)
    %Additionally, make a histogram of boostrapped means
        %Sort by rows to sort in order of magnitude
        %Find the 95% CI
        
empiricalMeanDiff = mean(DATA(:,1)) - mean(DATA(:,1)); %Restating the 
%empirical difference

resampledMeans = NaN(numSamples,2); %Preallocating memory for all resampled 
%means, with one column per test score
nMidterm = length(DATA(:,1)); %creates nMidterm with length of the first 
%column in DATA
nFinal = length(DATA(:,2));%creates nFinal with the length of the second
%column in DATA

%do you need to specify where in DATA you want to index?
for ii = 1:numSamples %for all 100,000 smamples
    index = randi(nMidterm,[nMidterm,1]); %Use this index to subsample the 
    %midterm scores
    resampledMidterm = DATA(index,1); %
    resampledMeans(ii,1) = mean(resampledMidterm);
    
    index = randi(nFinal,[nFinal,1]);
    resampledFinal = DATA(index,2);
    resampledMeans(ii,2) = mean(resampledFinal);
end
 

%sorting the rows for both the midterm and final resmapled means
sortrows(resampledMeans(:,1)); %midterm
sortrows(resampledMeans(:,2)); %final

meanDiffMidFinal = resampledMeans(:,1) - resampledMeans(:,2); %mean difference
%of the resampled means
mean(meanDiffMidFinal) %The mean of the mean differences = 8.4249
%Finding the 95% confidence interval (at 2.5 and 97.5 percentiles)
lB = 2.5; %lowerbound
MidFinalLB = prctile(meanDiffMidFinal,lB); %finding the 2.5 percentile
%Output: 3.2667
uB = 97.5; %upperBound
MidFinalUB = prctile(meanDiffMidFinal, uB); %finding the 2.5 percentile
%Output: 13.5444
% 95% CI = [3.2667,13.5444]
% Because the mean difference is 8.4249 and the confidence interval does 
%not contain 0, the distrubtion of bootstrapped means suggests that there 
%is meaningful difference between the difficulty of the midterm and the 
%final scores

%makign the histogram
lBVal = 3.2667; %2.5 percentile value
uBVal = 13.5444; %97.5 percentile value
figure; %opens figure
bootHist = histogram(meanDiffMidFinal); %creates a histogram
set(gca, 'TickDir', 'out'); %turns the tick direction outward
box off 
hold on; %will hold the histogram in the figuer with the lines
line([lBVal, lBVal], ylim, 'LineWidth', 2, 'Color', 'r'); %2.5 percentile
%mark,also makes line thicker and changes the color to red
line([uBVal,uBVal], ylim, 'LineWidth', 2, 'Color', 'r'); %97.5 percentile 
%mark, also makes line thicker and changes the color to red
xlabel('Mean difference between midterm and final'); %x axis label
ylabel('Number of samples used'); %y axis label
title('Using resampling to determine the mean difference in exam scores');
shg %shows graph
%The plot displays a normal distribution

% The bootstrapping procedure shows that the calcuated emperical mean 
%difference stable and statistically reliable
% Our empirical mean difference is centered within the the 95% CI for the 
%bootstrapped data. Furthermore, because 0 does not fall within the 95%
%confidence interval, it is likely that the exam scores for the midterm 
%and the final are significantly different. This also indicates that the two 
%exams were differentially difficult
%% Saving the workspace

save thirdAssignmentMATLAB.mat`