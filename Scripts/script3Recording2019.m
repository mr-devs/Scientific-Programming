%% Header
%Inputs: None, this is a coding exercise
%Processing (the purpose of the program): Introducing basic data recording
%elements, like timing, stimulus presentation, randomization, etc.
%Outputs: A bunch of figures
%Who did this? 
%When? 

%% 0 Init - avoid logical errors
clear all
close all
clc

%% 1 Measuring time in Matlab - a critical skill - either to structure stimulus presentation or rt
%a) Very basics
%As usual, there are many ways to do this. I'll start with the simplest one
tic %Starts a timer
toc %Ends a timer

%toc represents how long it takes Matlab to read and execute line 17
%Running it again is always faster

%This is fast enough for anything we care about (physiology ~1 ms)
%This is literally the time taken to execute the line itself, if there is
%nothing between tic and toc.

%b) Cumulative time
toc %Time taken since the last time tic was executed
%Toc increases in real time

%% 2 Measuring the consistency of the timer
numReps = 1e6; %Running this 1 million times
%Preallocation (!) - assigning a chunk of memory as big as we need it to
%be, so there is no copying and incrementing dimensionality later
A = zeros(numReps,2); %Assign the right dimensionality to begin with
for ii = 1:numReps %From 1 to 1 million
    tic; %Start a new timer
    A(ii,1) = ii; %Record the iteration
    A(ii,2) = toc; %Record how long it took
end

%How long did it take in total?
sum(A(:,2)) %A long time!

%How consistent is it?
figure
histogram(A(:,2),100) %It seems to be that most runs are very short, but others are rather long
%In other words, there is disturbing inconsistency here

%Let's see if there is a substructure here, so we plot all times over the
%number of the index
figure
plot(A(:,1),A(:,2))

%% The most disturbing trend seems to be that later runs take a lot longer
%than earlier ones. There is clear ramp. 
%What is going on is that memory is the problem, specifically, incrementing
%and copying larger and larger pieces of memory. Incrementing
%dimensionality of a matrix takes a lot of time, and more, the bigger it
%is.

%If you pre-allocate *before* a loop, you can expect a speedup of 1-2000
%times. So you should always do this.
%Issue: What to preallocate with? There are several reasonable choices,
%depending on use case.
%0: Good - we don't presume anything that is not nothing. 
%Bad: If not all numbers are allocated - the 0 could be interpreted as a
%real number, and lower the mean 

%This is a great example of a potential logical error. 
%Imagine I preallocate an array with a million zeroes, and call it A
%Later, I index from 1 to 500,000. Very on the nose, so you'll probably
%notice it.

%Preallocating with nans - good: This can't happen
%"Bad": You really need to be careful handling them.

%Preallocate with a number that is an error code, e.g. 999
A = ones(numReps,2).*999; %This preallocates with that number.

%% The remaining inconsistency is minimal (microseconds), but not great.
%It stems from processes and threads running in the background. All modern
%operating systems are multi-threaded.
%Prescription: Before recording data in an actual experiment, restart your
%machine and - if possible - only open programs that you absolutely have
%to.

%% 3 Using basic timing functionality to measure reaction time
tic %Start a timer - maybe do this at the beginning of the trial
%Instructions
disp('Press a key to continue')
pause %Nothing happens until a key is pressed
rt = toc %Reaction time in seconds
%The focus needs to be in the command window for this to work

%% 4 Pause is very versatile, we can *also* use it for stimulus presentation
%For instance, if we want to present a stimulus for 200 ms: 
tic
pause(0.2)
toc

%Trust, but verify: Measure how long the pause actually is, then adjust.
%Do this 100,000 times, then adjust by the mean

%This works for general structuring of program flow. 
%But let's go back to capture user input

%% 5 More specific user input
%a) Straight up with the "input" function
tic
kP = input('Please press the "k" key ', 's')
toc

%% 
tic
kA = input('Please input your age: ')
toc

%Input captures everything until carriage return ("enter"), which is great
%for meta-data, like "provide your email" or "your age" or something like
%that. It's not great to capture single keys.

%% b) Capturing single keys (without carriage return)
beth = figure; %Open a new figure
pause %Wait for user input 
%To retrieve the last key the user pressed:
userPressedKey = get(beth,'CurrentCharacter')

beth.CurrentCharacter %Also works since 2015b

%% c Let's use this logic to define valid keys - only move on if the user pressed a valid key
%Say q and p
matt = figure; %Open a figure, call it matt
tic; %Start the timer
validKeyPressed = 157.5; %initialize a new variable that checks if a valid key was pressed

while validKeyPressed == 157.5 %while the condition is true
    pause
if strcmp(matt.CurrentCharacter,'q') == 1 %Check if q was pressed
    toc;
    validKeyPressed = pi; %Update validKeypressed so it is not an infinite loop
elseif strcmp(matt.CurrentCharacter,'p') == 1 %If q was not pressed, check if p was pressed
    toc;
    validKeyPressed = -9000; %Update validKeypressed so it is not an infinite loop
else 
    disp('You pressed the wrong key! Try again') %If neither was pressed, then the user must have pressed an invalid key
    %No update here because no valid key was pressed. We WANT to present
    %the choice again
end
matt.CurrentCharacter %Outputting what was actually pressed as a manipulation check
end

%All we need to make this run is one value that is the same (so that the
%loop runs if the wrong keys are pressed) and a value that is different, so
%that it terminates if the right keys are pressed. For didactic reasons, we
%don't pick 0 and 1, which are what we do usually.

%In the spirit of our creative problem solving: There an infinite number of
%ways to do this. Another obvious choice could have been to
%use a while loop that is always true, then use a "break" statement when a
%valid key is pressed. I leave that as an exercise for the user.
%Similarly, we didn't need the elseif, we could have used a joint
%conditional

%% Example of a condition that will always be true
ii = 0;
while 1
    ii = ii + 1
    if ii == 50000
        break %Once ii reaches the condition, it breaks
    end
end

%% 6 Understanding the randomizer a bit better
%Bottom line: Matlab (and any other programming language does not create
%random numbers. It creates pseudorandom numbers that are 100%
%deterministic, but that appear random at first glance. 
%If you want actual random numbers, you have to buy a hardware random
%number generator (or a book of random numbers)
%The way the pseudorandom number generator works is:
%1) We pick a very long number (a mathematical object), like one with the
%periodicity of a very large Mersenne prime number ("Mersenne Twister")
%2) The starting point is called the "seed", think of the digit of pi
%3) Every time a random number function like rand, randn or randi is
%called, the state of the random number generator is advanced
rng %Gives you the state of the random number generator
%Unless specified otherwise, the seed is 0. So if you don't initialize your
%rng, all your participants will have the *same* sequence of random
%numbers.
rng(20) %Sets the seed of rng to 20
rand(5,1) %Creates a vector of 5 random numbers from 0 to 1, from a uniform distribution

%Say you create complex random movies that take 100 GB to store. You don't
%have to store them. As long as you store the seed used to create them, you
%can always recreate them. All you need to store is the seed. 

%% You should initialize the rng with a unique value
%Most people use the system clock
seed = round(sum(clock)); %This is gives us an integer, which the seed needs to be
rng(seed)

%Positive: This gives us an integer, and one number, from the 6 element
%clock vector.
%Negative: There are between 120 and 200 unique states, assuming everyone
%is run in the same year.

%So how to get truly unique seeds?
%a) Use rng('shuffle')
rng('shuffle') %Uses the clock vector at higher precision
%b) If you want to be sure: Tie it to the participant number
%This presumes you have a master sheet of participant IDs, and every
%participant has a unique number. Challenging if you multiple RAs.
%Consecutive seeds yield completely independent numbers

%% 7 Putting this all together to create a stimulus display
%Let's say we want to create a display of 20 green X's on a black
%background at random locations
numSet = 30; %This is how many we want
garrett = figure; %New figure
mattHandle = text(0.5,0.5,'Hello world!')
axis off
mattHandle.FontSize = 30; %bigger font
mattHandle.HorizontalAlignment = 'center'; %Centered text
garrett.Color = 'k'; %Black background
mattHandle.Color = 'g'; %Green text

%% Now that we understand text handling, let's create 1 randomly placed X
dbg = 1; %Debug flag
rng(20) %"Seed" the random number generator with a known value, a technical term
numSet = 30; %This is how many we want
textLocation = rand(numSet,2); %Draw two random numbers from 0 to 1 which we will interpret as x and y values

garrett = figure; %New figure
garrett.Color = 'k'; %Black background
axis off %Turn this off before the loop, otherwise the axis will be white

for ii = 1:numSet
mattHandle = text(textLocation(ii,1),textLocation(ii,2),'X') %Use 1st column of textLocation vector as x coordinate, 2nd column as y coordinate. ii as row index
mattHandle.FontSize = 30; %bigger font
mattHandle.HorizontalAlignment = 'center'; %Centered text
mattHandle.Color = 'g'; %Green text
if dbg == 1 %Test (verify) mode on?
%Check number of X's 
%rhonda = text(textLocation(ii,1),textLocation(ii,2),num2str(ii)); %num2str takes a number and interprets it as a string
%Check coordinates
rhonda = text(textLocation(ii,1),textLocation(ii,2),['(',num2str(textLocation(ii,1),'%1.2f'),',',num2str(textLocation(ii,2),'%1.2f'),')']) %This checks the actual coordinates

rhonda.FontSize = 20; %In the future, don't hardcode this 
rhonda.Color = 'w'; %White index

pause(1)
shg
end

end
shg
%We would like to verify that the code did what we think it did
