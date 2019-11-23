%Header (you don't have to spell out header, but have one)
%In this program, we show how to process images in Matlab, how to handle
%multidimensional matrices, how to handle data types other than double
%Who?
%When?

%% 0 Init
clear all
close all
clc

%% 1 Understanding how Matlab represents images
%The screen is divided into picture elements ("pixels")
%Each pixel has 3 "channels" that control the brightness of the LCD at that
%spot, R(ed), G(reen) and B(lue). With these, you can make any color.
%The intensity of each channel has a granularity. By default, there are 
%256 shades of red/green/blue, or 2^8 each.
%Before exploring this further, we need to see how images are represented
%in the first place.

umbrella = uint8(zeros(4,5,3)); %Just because you can call a variable anything you want, it doesn't mean it is a good idea to do so. It is particularly inadvisable to use a completely arbitrary term that means *something else*. We do here for didactic reasons - just to show that you can do it. And why it is a bad idea.
%Uint8 is a function that takes the double matrix of zeros we create
%and represent it as an "unsigned integer" - a data type.

temp = 5; %Representation as double
temp2 = uint8(temp); %Representation as int
%Representation as int saves a lot of space in memory. 
%double = 8 bytes per number, or 64 bit, or 2^64. That's overkill for light
%intensities. So an int is the more efficient representation, as no one can
%distinguish 2^64 shades of gray.
%There is a catch
temp3 = 300; 
temp4 = uint8(temp3); %255 is the largest possible number an unsigned int can represent. 
%Anything higher than that will be 255.
uint8(9001); %This value is actually larger than 9000, but is represented as 255.
%In terms of RBG, 255 is the highest value. That means "fully on", much
%like if you have a geiger counter that maxes out at 3.6 roentgen, but the
%actual radiation is much higher, say 15,000 roentgen.
%And that's generous because another int function, like 
int8(temp3) %will be even lower
%The range of int8 is -127 to 127 (plus 0). So why does Matlab (and
%everything else) use "unsigned" (positive) integers to represent lights?
%In this universe, we don't need to represent negative light energies. So
%we would waste half the range.
image(umbrella)
shg

size(umbrella) %This matrix has 4 rows, 5 columns and 3 "channels". The values represent light 
%intensities at that location. Y-axis: Rows, X-Axis: Columns. 
pause
%b) Turning the upper left pixel red
umbrella(1,1,1) = 255; %Turn the red channel (or "gun") all on
image(umbrella)
shg

pause
%Turning the upper right pixel white
umbrella(1,end,:) = 255; %All on
image(umbrella)
shg
pause
%Lower right lime green (look this up)
umbrella(end,end,[1 3]) = 50; %end is "last" in the matrix
umbrella(end,end,2) = 205;
image(umbrella)
shg
pause

%Lower left "lavender" (look this up too)
umbrella(end,1,1:2) = 230; 
umbrella(end,1,3) = 250;
image(umbrella)
shg

pause
%How to turn the entire middle column yellow?
temp = round(size(umbrella,2)/2);
umbrella(:,temp,1:2) = 255; %Yellow
image(umbrella)
shg

%% 2 How to create a gradient with an index
%Whatever color you want - 10,000 shades of purple
numRows = 255;
numColumns = 255;
bruins = uint8(zeros(numRows,numColumns,3)); %New matrix, 3 channels represented by... football?
%Want to address every pixel, much like an old CRT ray would.
for rr = 1:numRows %Go through all rows
       bruins(rr,:,1) = bruins(rr,:,1) + rr;
    for cc = 1:numColumns %Go through all columns
        bruins(rr,cc,3) = bruins(rr,cc,3) + cc; 
    end
end
image(bruins)
shg
%To take complete control of these images, you need to distuingish 4
%numbers: 1) The row index, 2) The column index, 3) The channel index and
%4) The actual luminance value (from 0 to 255)

%% 3 Transitioning to real images
%Assumption: The image file is in the "stimuli" directory 
%So we have to navigate there
%Either
cd stimuli %Go to the "stimuli directory"
dress = imread('thedress.jpg') %Load in the dress, assign it to matrix "dress"
cd .. %Go back to the directory you came from
%or go to the directory explicitly
%cd('/Users/lascap/Documents/Desktop as of August 2017/Old Desktop/Work/Teaching/Spring 2018/Programming Spring 2018/Programming Summer 2019/stimuli/')
%The catch is that this will depend on your machine, e.g. mac vs. pc
%You could write this flexibly, there are functions that are self-aware,
%e.g. ismac or ispc
%cd .. gets you out *one* hierarchy level. It is specific to change
%directory (which cd stands for)
%Dots in general:
%1 dot: Method of the object (function, property) and element wise
%division/multiplication
%2 dots: used in change directory
%3 dots: ... (ellipsis) - continue code in next line, very useful is line
%is too long

%% "Dress code"
figure
image(dress)
shg
%If you do this just like that, it will be stretched because there are more
%rows than columns. To get the "aspect ratio" right, we have to make sure
%each row takes up the same space as each column:
axis equal
axis off %Takes the white space off

%% b decomposing the dress into its component channels
dressModified = dress; %Make a copy
figure
subplot(2,2,1)
image(dress) %Just the actual dress
subplot(2,2,2) %The red channel
dressModified(:,:,2:3) = 0; %Turn the other 2 channels off
image(dressModified) %To image something as a matrix, each pixel needs a RGB triplet
%So we need to have a matrix where all other channels other than the red
%channel are off
subplot(2,2,3) %The green channel
dressGreen = dress; %Make a copy!
dressGreen(:,:,[1 3]) = 0; %Turn off red and blue
image(dressGreen)
subplot(2,2,4) %The blue channel
dressBlue = dress; %Make a copy!
dressBlue(:,:,1:2) = 0; %Yep
image(dressBlue)
shg
%Very Warhol
%Principle: Don't mess with the original data/image. Make a copy first,
%then work on that. The fundamental reason for this is that you might want
%to do more than 1 thing, and many computations are not loss-less (you
%can't go back). 

%Decomposing the image into its component channels reveals that it actually
%does have a blue hue

%% c) Testing hypothesis about the dress: Is it just brightness?
%Idea: Because the dress is a matrix (an array of numbers), we can change
%these numbers. In many ways. 
%Simplest one: Adding. A bit more complex: Multiplication
brightValue = 50;
brightFactor = 1.5; %50% more. This emphasizes pixels that are already bright

analysisFlag = 2; %if this flag is 1, we add, if this is 2, we multiply
if analysisFlag == 1 %We add
brightDress = dress + brightValue; %The simplest possibility - add 50 to each pixel on every channel
elseif analysisFlag == 2 %We multiply
    brightDress = dress .* brightFactor;
end
figure
image(brightDress)
shg

%To really test this hypothesis, we could put the dress side by side with
%the original and ask which is "goldener" 

%We could use subplot to create a side by side image. But that would leave
%a lot of air
%We could use "montage" (a function) to do that.
%But the easiest thing to do is to simply create a bigger matrix that
%contains both
figure
crossSize = 10;
crossThickness = 2;
biggerMatrix = [dress brightDress]; %Glue a matrix together without seams. Seamlessly
%Adding a fixation cross. Step 1: Find the center of the image
%Caroline's solution
sizeMatrix = size(biggerMatrix); %This is the size
temp1 = 1:sizeMatrix(1); %Vector made out of dimension 1
centerRow = round(median(temp1)); %Median column
temp2 = 1:sizeMatrix(2); %Vector made out of dimension 2
centerColumn = round(median(temp2)); %Median row
%Rows
biggerMatrix(centerRow-crossSize:centerRow+crossSize, ... 
    centerColumn-crossThickness:centerColumn+crossThickness,1) = 255; %Make crossrows red
biggerMatrix(centerRow-crossSize:centerRow+crossSize, ... 
    centerColumn-crossThickness:centerColumn+crossThickness,2:3) = 0; 

%Columns
biggerMatrix(centerRow-crossThickness:centerRow+crossThickness, ... 
    centerColumn-crossSize:centerColumn+crossSize,1) = 255; %Make crosscolumns red
biggerMatrix(centerRow-crossThickness:centerRow+crossThickness, ...
    centerColumn-crossSize:centerColumn+crossSize,2:3) = 0; %Make crosscolumns red


image(biggerMatrix)
axis equal
axis off
shg

%% 4 Other image processing
%a) Inverting colors
invertedDress = 255 - dress; %This is the color inversion
image(invertedDress)
shg

%% b) Blurring the dress
%Blur results from averaging of neighboring pixels. We do this by
%"convolving" the image with a kernel
blurFactor = 50; %Something reasonable
kernel = ones(blurFactor); %A square of 1s. 
blurredDress = convn(dress,kernel,'same')./sum(sum(kernel)); %The reason we need to divide is because convn just sums, we need to divide by the weight of the kernel
image(uint8(round(blurredDress))); %Convolution makes it a double. So we need to round and uint8 it again
shg
%Convolving without arguments does zero-padding, which creates
%edge-artifacts. The resulting image will be n-1 (where n is the kernel
%width) bigger.
%Convolution with the "valid" argument does not do any padding. The first
%resulting pixel happens once the *entire* kernel is entirely on the image
%Convolution with the "same" argument creates an image of the same
%dimensionality. Great for subtracting, otherwise a compromise between the
%other methods.
%What sophisticated people in the image processing community do is to
%create a bigger matrix from a tesselation of the old matrix, then "valid"
%convolve that. 
%I'll leave that as an exercise for the reader. 

%% High pass, from low-pass (for edge detection)
amplificationFactor = 4;
highFrequencyDress = dress-uint8(blurredDress);
image(highFrequencyDress.*amplificationFactor) %Bright, edge-enhanced, high spatial frequency version of the dress
shg

%% 5 Towards gabors - making stimuli that are a function of two variables

% a) Understanding meshgrid - a very useful function that greates gradients
%that will you to image things that are function of more than one variable
%I believe this is also the first time where we have more than out output
%of a function
numSteps = 101; %Number of steps in the gradient?
startPoint = -3; %Where does vector start?
endPoint = 3; %Where does vector end?
inputVector = linspace(startPoint,endPoint,numSteps); %Go from startPoint to endPoint, in numSteps, linearly
[X,Y] = meshgrid(inputVector); %Meshgrid takes an input vector and crosses it fully
%Let's illustrate that. You will use meshgrid a lot. It's better to
%understand it. 
figure
subplot(1,2,1) %Look at X by itself
imagesc(X)
subplot(1,2,2) %Look at Y by itself
imagesc(Y)
colorbar
shg

%The X matrix put the gradient in columns, keeping the value constant
%within the same row, the Y matrix did the opposite. So we now have 2
%gradients, one in x, and one in y. We can use this to greate sinewaves and
%gaussians, and gabors
gaussian = exp(-X.^2-Y.^2) %A 2d gaussian, in X and Y
figure
image(255*gaussian)
colormap(gray)
axis off
axis equal
shg


%% b) Let's make a 2D sinewave
numCycles = 7;
inputVector2 = linspace(-pi,pi,numSteps); %Go from -pi to pi in 101 steps
[X,Y] = meshgrid(inputVector2); 
sineWave2D = sin(numCycles*X); %Equation of a sine wave
figure
imagesc(sineWave2D)
colormap(gray)

%% c) An actual gabor
gabor = gaussian .* sineWave2D;
figure
imagesc(gabor)
axis off
axis equal
colormap(gray(256))
shg

%% d) Rotated gabors
angle = 30; %Rotation angle (in degrees)
ramp = cos(angle*pi/180)*X - sin(angle*pi/180) * Y; %Using trig to rotate and converting angle to radians
orientedGrating = sin(numCycles * ramp);
orientedGabor = orientedGrating .* gaussian;
figure
imagesc(orientedGabor)
axis off
axis equal
colormap(gray(256))
shg