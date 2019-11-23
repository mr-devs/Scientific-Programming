%This script implements a basic analysis of behavioral data
%Using both classical descriptive and inferential statistics
%Specifically, we will analyze real data that the instructor
%logged in the early 2000s. The data represents how much a given
%participant enjoyed the movies Matrix I to III. 
%We will test hypotheses
%Hypothesis I: "Trilogy hypothesis": Enjoyment decreases with each
%iteration
%Hypothesis II: "Fanboy hypothesis: People who suffered through the first
%one and come back to see the others will enjoy the later ones more
%Who did this?
%When?

%% 0 Init - not initializing is a primary breeder of logical errors
clear all
close all
clc

pruningMode = 1; %If pruningmode = 1, eliminate nans elementwise. If 2, do so participant-wise

%% 1 Loader: Transduction - bringing your data from the format of origin into a matrix format
%xlsread reads in an excel file and puts out a matrix
%Make sure this is your directory
M1 = xlsread('C:\Users\mdeve\OneDrive\Documents\NYU\2019 Summer\classData\MATRIX1.xls')
M2 = xlsread('C:\Users\mdeve\OneDrive\Documents\NYU\2019 Summer\classData\MATRIX2.xls')
M3 = xlsread('C:\Users\mdeve\OneDrive\Documents\NYU\2019 Summer\classData\MATRIX3.xls')

%This should work, but sometimes it doesn't, because Matlab does not always
%integrate well with Microsoft products. In that case, just use load (.mat)
%I preprocessed it.

%Usually, this is more involved. Sometimes, writing a loader that takes
%data from your rig can take a long time. That's why recording data with
%your coding language is the way to go. 

%% 2 Pruning/cleaning ("Thalamus") 
%We need to handle missing data. In real life, you will always have missing
%data. If you are lucky, it is missing at random. Here, we suspect that it
%might be missing systematically. 

%The way you handle missing data sets up the analysis that can be done and
%how you can - in principle - answer your theoretical questions.

%So it does matter, and there are different ways of doing this.
if pruningMode == 1
%1) Removing missing data element-wise (as it occurs)
%a) With the built-in function rmmissing
M1cleaned = rmmissing(M1)
mean(M1) %Evaluates to nan
mean(M1cleaned) %Test whether rmmissing "worked" - it now evaluates to a number, but we don't know if it takes off too much
%% b) By hand
temp = isnan(M1) %Find all the nans in an array, replace them with 1 if nan, and 0 if not
temp2 = find(temp) %Translates the boolean array to indices where there are nans
cleansedM1 = M1; %Make a copy of M1
cleansedM1(temp2,:) = []; %Eliminate all nans from the array, call it "cleansed"

%% c) With our function
M2cleaned = removenans2019(M2);
M3cleaned = removenans2019(M3);

elseif pruningMode == 2 %Participant-wise
RATINGS = [M1,M2,M3]; %Horzcat
temp = sum(isnan(RATINGS),2); %Counts missing values per row, over the 2nd dimension
temp2 = find(temp==0) %Only keep rows of people that saw all the movies
validRATINGS = RATINGS(temp2,:); %Pick out the legit ratings
%Upside: We eliminated survivorship bias
%Downside: We lost most of the data
%Participant-wise elimination is very conservative. 

%3: "Imputation": Replace the missing value with what you think it should
%be. In science, this feels wrong. It is routinely done in engineering.
%Reasonable choices here: 
%Mean
%Bayesian estimation ("people who like a bug's life, also like human
%centipede)
%-1 for missing data - it might be a deliberate choice to avoid the movie
%whatever makes for better predictability


end
%% 3 Formatting
%Usually, you will spend most of your time here, but for now, there is
%nothing to do

%% 4 Analysis proper (Calculations
%a) Descriptives
if pruningMode == 1
%means
mu1 = mean(M1cleaned)
mu2 = mean(M2cleaned)
mu3 = mean(M3cleaned)

%ns
n1 = length(M1cleaned)
n2 = length(M2cleaned)
n3 = length(M3cleaned)
elseif pruningMode == 2
mean(validRATINGS)
end

%% b) Inferential statistics - 
%1 Independent samples t-test
if pruningMode == 1
ttest2(M1cleaned,M3cleaned) %Independent samples ttest of M1cleaned vs. M3cleaned
[sig, p] = ttest2(M1cleaned,M3cleaned) %2 output variables, significant and p value?
[sig, p, CI, tstats] = ttest2(M1cleaned,M3cleaned) %Full output
elseif pruningMode == 2 % Do a pairwise t-test
[sig, p, CI, tstats] = ttest(validRATINGS(:,1),validRATINGS(:,3)) %Full output for a pairwise ttest
end

%% 2 ANOVA - We could now do all the t-tests to test all pairwise mean differences
%But we are concerned about the inescapable dilemma between inflating alpha
%error (without multiple comparison correction - "the rock") and inflating
%beta error (with multiple comparison correction - "the hard place"). 
%A better solution is to avoid doing multiple comparisons to begin with,
%which is what the ANOVA is.

%We will use the ANOVA to partition variability. 
%We basically test the hypothesis whether people discern between the
%movies. It is conceivable that there is a "bandwagon" effect - you either
%like them all or hate them all. 

% Version that follows pruningmode 2 (participant-wise cleaning)
% equal n - in this version, each column of the ANOVA is interpreted as a
% level
if pruningMode == 2
[p, anTable, fStats] = anova1(validRATINGS)
%p value: Probability of observing this (or a more extreme) test-statistic,
%given chance (i.e. the movies are all of the same quality). Area under the
%test-statistic curve, in this case the F ratio curve.

%Participant-wise pruning amounts to a repeated measures design.
%So we should run a repeated measures anova
%Function: "ranova". 
%Technically, a repeated measures or "within group" design partitions
%the SS further. Specifically, participant is a random-effects factor.
%Daily form is what is variable. This further reduces "error" variability.
%These designs are often much more powerful. 

elseif pruningMode == 1
%If you eliminate missing or ill-formed data element-wise, you'll probably end up with unequal n
%In that case, ANOVA has its own syntax to handle that.
%Briefly, we have to create surrogate vectors that denote group membership
validRATINGS = [M1cleaned;M2cleaned;M3cleaned];
level1 = ones(length(M1cleaned),1); %1060 1's in a column
level2 = ones(length(M2cleaned),1).*2; %837 2's in a column
level3 = ones(length(M3cleaned),1).*3; %770 3's in a column
levels = [level1;level2;level3]; %stack them
figure
imagesc(levels); colorbar; shg
[p, anovatab, fstats] = anova1(validRATINGS,levels) 

%There are many ways to do anova. If you have more than 1 IV, you should
%use anovan, which allows you to look at interactions
end

%% 3 Technically, we did it all wrong. We shouldn't have done any of this
%Because the step-size between ordinal data is not constant, it makes no
%sense to calculate the sum and interpret the mean meaningfully. 
%Mean = a parameter. Makes no sense here.
%So we have do a nonparametric way.
%There are a lot of nonparametric tests.
%The closest analogy to doing a non-parametric ANOVA is the Kruskal-Wallis
%test
[p, antab, hstats] = kruskalwallis(validRATINGS,levels)
%This is very analogous. Similarly, we could replace the ttests above
%with Mann-Whitney U tests. The MATLAB function for that is "ranksum". 
