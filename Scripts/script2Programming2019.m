% This is a HEADER

% This script will be a legit script that uses programming concepts. Doing
% things very fast, over and over again - based on conditions.
% This will include loops and switches

% Loop - doing the same thing over and over again, very fast. (serial)
% Switch - Depending on conditions, do one thing or another. (fork)

% Dependencies/Assumptions: None
% Who wrote this?
% How can I reach them?
% When did they do this?

%% 0 Initializations ("Birth")

% Step 1. Create a 'blank state'
clear all  % clear memory
close all  % Close open figures
clc        % clear command window

% Step 2. Priors
startPoint = 1 ;
endPoint = 100 ;

%% 1 Loops
%Some DNA codes for proteins. This corresponds to the commands.
% Other DNA changes how the coding DNA is expressed. This corresponds to
% the operators.

% 1a. The simplest possible counter
for ii = 1      % Do the assignments in the for line, each iteration (update)
    ii          % Execute these commands each iteration
end             % Until end

% 1b. A little more sophisticated

for ii = 1:3    % Do the assignments in the for line, each iteration (update)
    ii          % Execute these commands each iteration
end             % Until end

% Side note: Why use ii instead of i or j? (i is much more common)
% 1. i and j represent preallocated imaginary values, you end up overwriting them
% 2. People may confuse i and 1 visually
% 3. Get in the habit of using meaningful indices

%% 1c Generally speaking, you should never hardcode in your loops

for ii = startPoint: endPoint
    ii
end

%% 1d the vector we use to update ii at each iteration can be ade of many differeny values
iterationVector = [3 12 -1 5 pi];

for beth = iterationVector
    beth
end


%% 1e Doing something with a loop

% creating a cumulative sum
tally = 0 ;
for ii = startPoint:endPoint
    tally = tally + ii ;
end
tally

%% 1f demonstrate the power of a loop

% creating a cumulative sum
indexVector_ = 1:1e6 ;
tally = 0
for ii = indexVector_
    tally = tally + ii ;
end
tally

%% 2 - to illustrate the full power of loops, we now include switches
% Do the same thing each time, mutatis mutandis (latin for with necessary adjustments)
% Switch: Either do one, or the other thing, depending on the conditions
%%%%% SWITCH - condition is met once

% creating a cumulative sum - IMPORTANT: the order of sequenced events is
% EXTREMELY IMPORTANT
indexVector_ = 1:1e6 ;
tally = 0 ;
cumSumAtLocation = 4 ;
for ii = indexVector_
    tally = tally + ii ;
        if ii == cumSumAtLocation
        tally
    end
end

%% 2b - loop doesn't start until it meets a specific criteria
% Do the same thing each time, mutatis mutandis (latin for with necessary adjustments)
% Switch: Either do one, or the other thing, depending on the conditions

% creating a cumulative sum - IMPORTANT: the order of sequenced events is
% EXTREMELY IMPORTANT

indexVector_ = 1:1e6 ;
tally = 0 ;
cutoff = 1000 ;
for ii = indexVector_
    if ii > cutoff
        tally = tally + ii ;
    end
end
tally

%% 2c - distinguish several cases
% Do the same thing each time, mutatis mutandis (latin for with necessary adjustments)
% Switch: Either do one, or the other thing, depending on the conditions
%%%%% SWITCH - condition is met once

% Use case: Raffle
raffle = randi(10); % gives us ONE RANDOM NUMBER between 1 and 10

if raffle == 10
    disp('You won!')
elseif raffle == 9 
    disp('Close, but not quite')
elseif raffle == 1
    disp('Total Disaster')
else
    disp('Sorry, you lost. Try again next time')
end
raffle

%% 3 - the while loop!!
% the for loop assumes that you know how many times to loop through 
% the while loop - doesn't presume to know this.
%%% it runs until the conditions are met

raffle = randi(9);     % gives us ONE RANDOM NUMBER between 1 and 10
failsafe = 1000 ;         % denotes the number of times that a loop runs. Either very unlucky or an infinite loop
numTries = 1 ;

while raffle < 10
    
    if raffle == 10
        disp('You won!')
    elseif raffle == 9
        disp('Close, but not quite')
    elseif raffle == 1
        disp('Total Disaster')
    else
        disp('Sorry, you lost. Try again next time')
    end
    
    if numTries == failsafe
        disp('You''re very unlucky or you''re caught in an infinite loop')
        break
    end
    raffle = randi(10); % gives us ONE RANDOM NUMBER between 1 and 10
    numTries = numTries + 1 ;

end
raffle
numTries



%% 5 Using loops to something actually useful
% Toy use case. Imagine you ran en experiment and you want to know how long
% it takes, so you know if you can afford the fMRI hours. (this is a pilot)

numParticipants = 30 ; % this is not enough (outliers will trash your data but this is a pilot!
numTrials = 200 ; % fairly normal # of trials in psychophysics
reactionTimes = rand(numParticipants,numTrials) ; % this will draw numParticipants x numTrials reaction times from 0 to 1
totalDuration = 0 ;
stimulusOnset = .2 ;
validTrials = 0;
% in a nested loop, integrate across all trials (by each person) then go
% through your participants as new loop

for pp = 1:numParticipants
    for tt = 1:numTrials
        if reactionTimes(pp,tt) > stimulusOnset
            totalDuration = totalDuration + reactionTimes(pp,tt) ;
            validTrials = validTrials + 1 ;
        end
    end
end
totalDuration
validTrials

% To wit:
validTrials %needs to match what we would expect from a sanity check
check = find(reactionTimes>stimulusOnset); % Sums/counts all instances when the parentheses is true
check1 = length(check) ;
check1 == validTrials

%% DIFFERENT TURN - strings/characters/etc

name1 = 'becky'
name2 = 'becky'

% blah blah numbers are handled differentlly
% each letter is represented in unicode

%%Cell Arrays
% This is an organic way to store things, from what 
% Scalars are single numbers
% Vectors are stacks of numbers
% Matrices are stacks of vectors
% Cells are stocks of matrices
% This of cells as a shelf with multiple drawers with a whole matrix in it
% You can now mix and match variable types, or matrices with different
% dimensions

A = cell(5,1) % a 5x1 cell - one shelf with five drawers
A{1} = reactionTimes; 
A{2} = name1;
A{3} = name2;
A{4} = 'bobbbboo';
A{5} = nan

A(1) % Just shows us what the drawer is - 30x200 double
A{1} % this opens the drawer and displays it's contents
A{1}(:,1) % opens and then displays the specific values indexed
