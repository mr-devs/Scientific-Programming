%The point of this script is to redo what we did with classical methods
%with resampling methods. We will also illustrate the clt

%% 0 Init (don't clear here)

%We will use a lot of random numbers, so it behooves us to seed the rng
rng('shuffle')

%% b) Illustrating distributions
x = -5:0.01:5; %Some arbitrary x-base
y = pdf('norm',x,0,1) %Normal distribution with 2 parameters
y = pdf('gam',x,1, 1) %Gamma distribution
figure
plot(x,y);shg

%Suggestion: Pick your distribution of choice and see what that looks like

%% 1 Illustration of CLT properties ("Proof by Matlab" - numerically)
%CLT: Means taken from a sample distribute normally if (and only if) 
%the sample is sufficiently large (~20-30) and drawn randomly and independetly, 
%regardless of how the population distributes. 
distType = 2; 

%a) For a uniform distribution
numPop = 1000; %Population consists of 1,000 cases
numReps = 1e4; %10k for teaching, 1e6 for research
maxSample = 100; %This is the maximal sample size we'll consider
meanRepository = nan(numReps,maxSample); %Preallocate where we put means for speed
if distType == 1 %If it is a uniform distribution
X = rand(numPop,1); %Draw the population from a uniform distribution
elseif distType == 2 %If it is a gamma distribution
X = random('gam',1,1,[numPop, 1]); %Draws at random from a gamma distribution    
end
%Now that we created the population, we have to draw from it randomly and
%independently
for nn = 1:numReps %Do this a lot of times
for sampleSize = 1:maxSample 
indicesWeUse = randi(numPop,[sampleSize, 1]); %Draw samplesize integers from 1 to population size to draw randomly, and independently with replacement
Y = X(indicesWeUse); %These are numbers in the sample (X is the pop, Y is the sample)
meanRepository(nn,sampleSize) = mean(Y); %Take the sample mean
end
nn %Output where we are in the loop
end

%% Plot it 
figure
numBins = 51;
for ii = 1:maxSample
histogram(meanRepository(:,ii),numBins)
title(['Sample size = ', num2str(ii)])
xlim([0 5])
shg
pause
end

%% 2 Monte Carlo methods - doing what we did again, but with resampling methods

%a) Restate explicitly the empirical mean difference (what needs to be
%explained). This is what we have
empiricalMeanDifference = mean(M1cleaned)-mean(M3cleaned)

%Question: How stable/reliable is this mean difference (how does it
%distribute)? This is what we want.
%In the absence of unlimited funding, we resample what we have
numSamples = 1e4; %10k times
resampledMeans = nan(numSamples,2); %Preallocate memory for all resampled means, 1 column per movie, each run will be a row
n1 = length(M1cleaned); 
n2 = length(M2cleaned); 
n3 = length(M3cleaned); 
for ii = 1:numSamples %Resample
    index = randi(n1,[n1, 1]); %We will use this index to subsample from the M1ratings
    resampledM1Ratings = M1cleaned(index); 
    resampledMeans(ii,1) = mean(resampledM1Ratings);
    %This would be a good place to write a resampling function because
    %all that is necessary to do it comes from the input array itself
    %and we literally have to do it again for the 3rd movie, which means
    %if we don't make it a function, we'll probably make copy/paste
    %mistakes
    index = randi(n3,[n3, 1]); %We will use this index to subsample from the M1ratings
    resampledM3Ratings = M3cleaned(index); 
    resampledMeans(ii,2) = mean(resampledM3Ratings);
    %I almost forgot to update one of the M's. 
end

%% Differences and plotting them
meanDifferences = resampledMeans(:,1) - resampledMeans(:,2); 
figure
histogram(meanDifferences,100)
shg

%% 3 Permutation tests
%As we discussed, bootstrapping relies on drawing *with* replacement
%Permutation tests rely on drawing *without* replacement, with amounts to
%reordering of an array.
%Example: Random reordering of ordered array
maxNum = 100;
orderedArray = 1:maxNum; %Ordered numbers from 1 to 100
reshuffledArray = randperm(maxNum); %Randomly reordered array
orderedArray(reshuffledArray) %Presenting original array in random order