%% Header

% Inputs: None, this is a coding exercise
% Processing (the purpose of the program): introducing basic data recording
% elements, like timing, stimulus presentation, randomization, etc. 
% Outputs: A bunch of figures
% Who did this?
% When?

%% 0 Init - avoid logical errors by clearing the space

clear all   ;
close all   ;
clc         ;

%% Measuring time in Matlab (CRITICAL)

% Many ways to do this...


% Simplest way to do this...
% a) start to finish
tic     % Starts the timer
toc     % Stops the timer

% How long it takes Matlab to read and execute both of those lines.
% this is fast enough for anything that we care about in physiology (floor
% ~ 1ms)
% b) cumulative time
toc % run toc by itself - the computer keeps time from the last executed toc

%% Measure the consistency of Matlab timer

numReps = 1e6 ; % one million times

% Preallocation to save time through less memory costs
A = zeros(length(numReps)); 

for ii = numReps
    tic % start a new timer
    A(ii,1) = ii ;  % record the iteration 
    A(ii,2) = toc ; % record the iteration 
end

sum(A(ii,2))

% Preallocating takes much less time!

%% What can we preallocate with?
% We used zeros above:
    % Good - we don't presume anything that is not nothing.
    % Bad - if not all numbers are allocated - the 0 could be interpreted
    % as a real number, and lower the mean

% Using NaN:
    % Good - the above can't happen
    % Bad - may screw up certain equations, you need to be much more
    % careful with this

% Preallocate with an error check value (something that can't be real -
% this would help you notice the problem)
% Example:
    A = ones(numReps,2) * 9999 ;% sets all values to 9999
    A

%% 3 Using basic timing functionality to measure reaction time
tic % start a timer (perhaps at the beginning of the trial)

% Instructions
disp('Press a Key to continue')
pause % Nothing happens until a key is pressed (Computer waits to run the below line so once you do, you are executing toc as well as setting rt to it's value and the lackk of an echo suppression spits out the answer)
rt = toc % reaction time in seconds

%% 4 Pause is very versatile, you can also use it for stimulus presentation

% For instance, if we want to present a stimulus for 200 ms:
tic
pause(.02)
toc

% This will run a bit longer b/c it has to execute tic and toc as well
% TRUST, BUT VERIFY: run the lag a 1000 times (or whatever), find the
% standard deviation and mean and adjust your measurements based on that.

%% Capturing User Input

% a) - using the 'input' function

tic
kP = input('Please press the "k" key: ', 's') % 's' assumes a string
toc

% Problem --> this waits for a "carriage return" (a.k.a the slide of a typewritter)

%% b) lets fix this problem (Capturing single keys)

beth = figure ; % Open a new figure
pause           % Wait for user input
% To retrieve the last key the user pressed:
userPressedKey = get(beth, 'CurrentCharacter')
% OOORRRR ---> = get(beth.CurrentCharacter)

%% c) lets use this logic to define valid keys - only letters acceptable as input

% lets say the keys are 'q' and 'p'

matt = figure ; % open figure
validKeyPressed = 0 ; % initialize new vairable that checks if a valid key is pressed
tic % start timer
while validKeyPressed == 0
    pause % wait until input
    if strcmp(matt.CurrentCharacter, 'q') == 1 % 'strcmp' = string compare
        toc ;
        validKeyPressed = 1;
    elseif strcmp(matt.CurrentCharacter, 'p') == 1
        toc;
        validKeyPressed = 1;
    else
        print('You fucked up and hit the wrong key, try again.')
    end
matt.CurrentCharacter    
end

%% ANother way to end a while loop

ii = 0 ; 
while 1     % this implies something along the lines of "1 equals (or is) 1"
    ii = ii + 1
    if ii == 1000
        break
    end
end

%% 5 Understanding the Randomizer a bit better

% Bottom Line: No programming language DOES NOT CREATE RANDOM NUMBERS
    % it creates pseudo-random numbers that are 100% deterministic but appear
    % random at first glance
    % If you want actual random numbers, you have to buy hardware or a book
    % which actually does this. 
    
    % How do Pseudo-random #s get generated?
    % 1) pick a very long number (a mathematical object), like the
    % multiplication of a very long Mersenne prime number ("Mersenne
    % Twister") (or, in english - like pi) which acts as a "seed"
    
    % 2) every time a random number function like rand, randn or randi is
    % colled, the state of the random number generator is 'advanced'
    rng % Gives the state of the random number generator
    % Unless you specified the RNG as something different from 0 - all
    % participants will have the SAME SEQUENCE of random numbers
    
rng(20) % sets the seed to 20
rand(3)

% VERY COOL - if you create something with a random number generator and a
% set process (code script). You can recreate it by only knowing the RNG
% seed.

%% You should initilize the rng with a unique value
% most people use the system clock
seed = round(sum(clock)); % This gives us a int
rng(seed)

% Positive - This give us an integer, and one number, from the 6 element
% clock vector.
% Negative - there are between 120 and 200 unique states, assuming everyone
% is run in the same year.

% So how do we get truly random numbers?
% a) use rng('shuffle') - adds much more precision to the clock
rng('shuffle') % Uses the clock vector at higher precision 
% b) To be sure: Tie it to a participant number 
% !!!! ---- check Pascal's version he wrote a bit more detail ---- !!!!! %

%% Putting this all together to create a stimulus display

% Lets create a display of 20 green X's on a black background at random
% locations.

numSet = 20 ; % This is how many we want
garret = figure ; % New figure
mattHandle = text(0.5, .5, 'Hello World!') ;
mattHandle.FontSize = 30 ;
mattHandle.HorizontalAlignment = 'center' ;
garret.Color = 'k' ;
mattHandle.Color = 'g' ;
axis off

%% Lets create 1 randomly placed 'X' now that we understand how displaying text works

rng(20) % seed the random number generator with a known value, (technical term)

textLocation = rand(1,2) ; % we need TWO NUMBERS that will be utilized as x and y values

numSet = 20 ; % This is how many we want
garret = figure ; % New figure
mattHandle = text(textLocation(1,1), textLocation(1,2), 'x') ;
mattHandle.FontSize = 30 ;
mattHandle.HorizontalAlignment = 'center' ;
garret.Color = 'k' ;
mattHandle.Color = 'g' ;
axis off

%% now that we know how to place one, lets place 20??

% PASCAL UPLOADED THE CODE THAT IS CORRECTED - THE BELOW DOESN'T WORK.

rng(20) % seed the random number generator with a known value, (technical term)
numSet = 30 ; % This is how many we want
textLocation = rand(numSet,2) ; % we need TWO NUMBERS that will be utilized as x and y values

garret = figure ; % New figure
for ii = 1:numSet
    mattHandle = text(textLocation(ii,1), textLocation(ii,2), 'x') ;
    mattHandle.FontSize = 30 ;
    mattHandle.HorizontalAlignment = 'center' ;
    garret.Color = 'k' ;
    mattHandle.Color = 'g' ;
end
axis off

%% how do we verify that the code did what we think it did.

rng(20) % seed the random number generator with a known value, (technical term)
numSet = 30 ; % This is how many we want
textLocation = rand(numSet,2) ; % we need TWO NUMBERS that will be utilized as x and y values

garret = figure ; % New figure
for ii = 1:numSet
    mattHandle = text(textLocation(ii,1), textLocation(ii,2), 'x') ;
    pause 
    rhonda = text(textLocation(ii,1), textLocation(ii,2), num2str(ii)) ;
    mattHandle.FontSize = 30 ;
    rhonda.FontSize = 30 ;
    mattHandle.HorizontalAlignment = 'center' ;
    garret.Color = 'k' ;
    mattHandle.Color = 'g' ;
    rhonda.Color = 'r' ;
end
axis off











