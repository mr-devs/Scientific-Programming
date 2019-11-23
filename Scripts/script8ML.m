%Machine learning methods are all the rage because they allow us to
%automate otherwise cognitive tasks. For instance, spam detection, virus
%detection, making a self-driving car, robots, etc. 
%We could call it "AI". It is driven by "big data" to work properly.

%Today, we'll use a toy example. Imagine you work for the wellness exchange
%at NYU. You want to predict who will get depressed in college. 
%So we can allocate resources to improve academic success rates.
%To make such a prediction, we have to use relevant (!) data and use ML
%methods to discern patterns - relationships in the data. Then apply it to
%a new set of data. 

%% 0 Init
clear all
close all
clc

%% 1 Loader
load('/Users/lascap/Documents/Desktop as of August 2017/Old Desktop/Work/Teaching/Spring 2018/Programming Spring 2018/Programming Summer 2019/studentDataset.mat')


%% 2 Exploring a new data type
%We know about matrices and we know about cell arrays
%Those work fine, but imagine we have a matrix with 100 columns that
%represent the variables. Immediate question: What does each column
%represent. That's where structures come in
%The structure "students" is an object. It has fields and each field for
%each member of the structure has a value
students(22)
students(2)
students(1714).age %Just the value of that field. Syntax: dot - field name
ages = [students.age]'

%Coding principle: Organisms store information with DNA. But organisms
%compute with RNA - that's what makes the actual proteins.
%So: Strong advice: STORE your data in structures. They will be inherently
%labeled. But do your computations with matrices. Because either many
%functions will flat out not work with structures. Or it will be very
%solution.
%General solution: Store data in structures, read out - on an as needed
%basis into matrices what the computation requires. 
%Another underrated property of structures is that they allow to represent
%data hierarchical. So you can represent several experiments in one
%structure
students(20).exp1 = []; %Add a new field
students(20).exp1.COND1 = randn(10);
students(20).exp1.COND2 = randn(10);

%% 3 Extract what we need from the students structure to do the job
%We're going to extract 6 predictors and 1 outcome
%For the time being, we won't extract gender because it is categorical. It
%can be used, but it complicates thing. 
%We also don't extract age because we will have a restricted age problem. 
%In general, ML methods are not magic. If the data going in has
%limitations, ML won't be able to rescue you. If the data is problematic,
%ML methods could make the situation worse. 
yOutcomes = [students.depression]' %Transpose because by convention, cases are in rows, variables in columns
PREDICTORS = [[students.friends]; [students.FBfriends]; [students.extraversion]; ...
    [students.neuroticism]; [students.stress]; [students.cortisol]]';

%If this was the 20th century, we would now do classical statistics
%Null hypothesis significance testing. But: What will that tell you you?
%You could test 6 relationships here. Say we find that mean number of
%friends is significantly different between people with or without
%depression.
%This approach can still be meaningfully done, but it tells us about the
%population, i.e. the relationship between the constructs, i.e. between
%friendship and depression.
%What do we want to know?
%Our question is different. Of these specific students, who is likely to 
%become depressed?
%Related: We want to use all predictors at once, for a given individual

%Taking a closer look: Are the predictors uncorrelated?
%By common sense, these variables are very unlikely to be independent

%1 To ascertain whether a PCA is indicated, let's look at the correlation
%heatmap
figure
imagesc(corrcoef(PREDICTORS)); colorbar
shg
%1 The variables are not uncorrelated. There is a correlation structure
%2 The correlation structure suggests that there will be 2 meaningful
%factors. 1-3 are correlated (1 cluster) and 4-6 are correlated (2nd
%cluster), but they are not correlated between clusters
%3 The intercorrelations in one cluster are slightly higher than in
%another, so we predict that eigenvalues in 1 are going to be slightly
%higher

%2 PCA is indicated, and we have an expectation of the results
%So let's do a PCA
[loadings origDataNewCoordinates eigValues] = pca(zscore(PREDICTORS))

%%
figure
bar(eigValues)
title('Scree plot')
xlabel('Factors')
ylabel('Eigenvalues')
set(gca,'fontsize',26)
shg

%Problem: PCA does not technically work with the correlation matrix. It
%works with the covariance matrix. That is not independent of units. 
%It also assumes normal distributions. 
%Both is violated here. This didn't really rear its head with the evals
%because they were all bounded and on the same scale.
%Normalization: By z-scoring. --> Mean (0) and STD (1) - normalize by
%putting things on a STANDARD NORMAL DISTRIBUTION

%% Looking at the corrected scree plot, we get 2 factors, both by 
%Kaiser criterion and Elbow 
% Next step: Look at the loadings to figure out meaning
%Factor 1: 
loadings(:,1) %"Pressed" or "Challenges"
%Factor 2:
loadings(:,2) %"Social support" or just "support"

%% Old wine in new bottles:
figure
plot(origDataNewCoordinates(:,1),origDataNewCoordinates(:,2),'.','markersize',20)
xlabel('Challenges')
ylabel('Support')
set(gca,'fontsize',26)
shg

%% 5 Clustering - doing quantitatively what can be seen intuitively
%Clustering answers - in a data-driven way - which subgroup a datapoint
%belongs to.
%The "kMeans clustering" is like pca of clustering. It's not the only
%clustering method, but it is the most commonly used one
%Algorithm: Minimize the summed distances between a cluster center and its
%members. Once the minimum has been found (regardless of starting
%position), it stops. "Converging"
X = [origDataNewCoordinates(:,1),origDataNewCoordinates(:,2)];
%We extracted two meaningful predictors out of the raw PREDICTORS matrix
figure %Silhouette: How similar to points in cluster vs. others, arbitrariness
for ii = 2:15
[cId cCoords SSd] = kmeans(X,ii) %Output: Vector of cluster IDs that the row belongs to
s = silhouette(X,cId);
histogram(s,20)
title([num2str(ii), ' , s = ', num2str(sum(s))]) 
Q(ii) = sum(s);
pause
end
figure
plot(Q,'linewidth',3)
indexVector = 1:length(unique(cId)); %[1:length(unique(cId))]'; %Indices
xlabel('Number of clusters')
ylabel('Sum of silhouette scores')
set(gca,'fontsize',26)
%Plot this to make it clearer what is going on
%kMeans gives you the center coordinates of the clusters, assuming a number
%of clusters. Silhouette gives you how many are most unamigously described
%by the clusters. Most likely "real" number: Where the sum of the
%silhouette scores peaks. In reality, they are complementary. Use together
figure
for ii = indexVector
plotIndex = find(cId == ii);
plot(origDataNewCoordinates(plotIndex,1),origDataNewCoordinates(plotIndex,2),'.','markersize',20)
xlabel('Challenges')
ylabel('Support')
set(gca,'fontsize',26)
hold on
plot(cCoords(ii,1),cCoords(ii,2),'.','markersize',50,'color','k')
shg
end

%As you can see, kMeans returns as many clusters as you ask for. 
%What it does is, is return the optimal center that minimizes the summed
%distance from all centers. But it requires - as an input (!) how many
%clusters to look for. Basically, you find what you look for in terms of
%cluster number. And the sum of the summed distances is only going down

%Solution: "Silhouette"
%Silhouette takes distances nearest neighbor clusters into account


%% 6 Classification: Using the predictors to predict an outcome
%In general, you use some data to build a model
%Then you use other data to test the model and check how accurate it is
%Intuition
figure
plot3(X(:,1),X(:,2),yOutcomes,'.','markersize',14)

%% This visualizes the issue: Some people do get depressed, others don't 
%In 3d. 
figure
h = gscatter(X(:,1),X(:,2),yOutcomes, [0 1 0; 0 0 1],'.',14) %Grouped scatter plot
xlabel('Challenges')
ylabel('Support')
set(gca,'fontsize',26)
shg
%Another view on this, but the outcome is represented by color, not a 3rd
%dimension. To make it clear that you have to draw a line in predictor
%space, not outcome space
%Name of the game: Draw a straight line ("linear separator") that optimally
%separates people with 1 outcome from people with another outcome. In
%higher dimensions: "Hyperplane", 2D: Line, 3D: Plane, 4D: Hyperplane

%Insight: 
%Given this data, it is impossible to draw a line that perfectly separates
%the subgroups (depressed vs. not). This is normal. There will
%misclassifications (people who should be depressed, given how terrible
%everything is, but are not, and vice versa). 
%Does something have to be perfect to be good? The SVM finds what is called
%the "widest margin classifier" - that seperatates the two outcomes - in
%predictor space as best as possible. Widest possible margin that is
%spanned by the "support vectors". 

%Step 1: Fit the model to the data
svmModel = fitcsvm(X,yOutcomes)

%Step 2: Visualize the support vectors (you can skip this once you know
%what you're doing). For now, I want to add that to the scatter plot
sV = svmModel.SupportVectors; %Retrieve the support vectors from the model
hold on
plot(sV(:,1),sV(:,2),'.','markersize',20,'color','r')
%These "support vectors" span the decision boundary

%Step3: Use model to make predictions and assess accuracy of model
%You will want to do this on new data to avoid overfitting. If you test the
%model on the same data that you fit it on, you will overestimate the
%accuracy of the model. It will not generalize because you are fitting to
%noise
[decision score] = predict(svmModel,X) %Decision reflects who the model thinks will be depressed

%Step4: Assess model accuracy by comparing predictions with reality
comp = [decision yOutcomes]
modelAccuracy = sum(comp(:,1)==comp(:,2))./length(comp)

%This model would predict the depression status of 95% of the students
%correctly. Given an overfit model. 
%Baseline: 75% - we guess "not depressed" - we could weight outcomes
%Correctly guessing depression might be more valuable than the other
%Also, the "errors" are not equal

%SVM are a cardinal example of linear classifiers. They are used very
%often. Their advantage is that they are easily understood. Directly
%theoretically interpretable. Problem: They basically known to be too
%simple to really model complex phenomena perfectly.

%There is a large number of nonlinear classifiers, like CNNs, RNNs, ANNs,
%and so on. Here, we will show one commonly used one. The random forest.

%% The random forest. 
%Advantage: Very powerful. Allows to learn and model complex behavior of
%data. 
%Disadvantage: Very hard to interpret the output

treeModel = TreeBagger(100,X,yOutcomes) %1) Build the model
view(treeModel.Trees{28}, 'Mode', 'graph') %2) Inspect it
%Use it to make predictions
[treeDecisions score] = predict(treeModel,X) %3) Use the model to make predictions
%The output of the treebagger are labels, we need to convert to numbers
numericalOutcomes = str2num(char(string(treeDecisions)));
empiricalVsPrediction = [yOutcomes numericalOutcomes]
modelAccuracy = sum(empiricalVsPrediction(:,1)==empiricalVsPrediction(:,2))./length(empiricalVsPrediction)*100

%We are able to predict 100% of the outcomes with this model. There are no
%errors. Even the strange cases, we got. The problem is that if you have
%results that are too good to be true, they probably are not true. 
%We committed the sin of "overfitting", due to the fact that we used the
%same data to both fit ("train") the model and test it.
%Prescription: "Don't do that". Use one set of data to build the model and
%another to train it.
%The problem is that results from overfit models won't generalize because
%some proportion of the data is due to noise. If you fit perfectly, you fit
%to the noise. The noise will - by definition - not replicate. 
%Best solution: Get new data. Rarely practical.
%Most common solution: Split the dataset. There are many ways to do this,
%e.g. 50/50, 80/20 (at random. Most powerful (most computationally
%intensive): "Leave one out": Use the entire dataset to build the model,
%expect for one point. Predict that point from n-1 data. Do that many
%times, at random, and average the results. 