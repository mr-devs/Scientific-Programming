%% Beginning of psychophysics
 
% Process images in matlab, 
% Handle multidimensional matrices, 
% how to handle new data types 

%% Understanding how Matlab represents images

% represented with LCD three lights - different from paint.
% All light colors = white
% All paint colors = black

umbrella = uint8(zeros(4,5,3)) ; % represents the matrix as a matrix of INTEGERS which is importnat

temp = 5 ;% representation as double 
temp2 = uint8(temp) ; % represented as integer
% this allows for you to process images more easily. More details in
% Pascals' script. 

% there is a catch
temp3 = 300 ;
temp4 = uint8(temp3) ; % this is maxed out

uint8(9001) % no difference! 255 in int means infinitely large

image(umbrella)
size(umbrella) % 4 rows, 5 columns, 3 "channels". The values represent

% for the below - the row and columns indicate the LOCATION of the pixel to
% control it's color, and the channels/guns are representative of the
% actual RGB values

% Turn the red channel ( or 'gun')
umbrella(1,1,1) = 255;
image(umbrella)

% Turn upper right white
umbrella(1,end,:) = 255 
image(umbrella)

% lower right, light green
umbrella(end,end, [1 3]) = 50
umbrella(end,end, 2) = 205
umbrella(end,end, [1 3]) = 50
image(umbrella)

% lower left, lavender
umbrella(end,1, 1:2) = 230
umbrella(end,1 , 3) = 250
image(umbrella)

% entire central column yellow
umbrella(:,3, 1:2) = 255
image(umbrella)

%% 2 how to create a gradient with an index 
% w/e color you want - 10,000 shades of [N.E. thing]

clear all
numRows = 255       ;
numColumns = 255    ;
bruins = uint8(zeros(numRows,numColumns, 3)) ; % new matrix, 3 

% Creeate every pixel with a double loop changing rows and columns as you
% go through each.

for rr = 1:numRows
    bruins (rr,:,1) = bruins (rr,:,1) + rr ;
    for cc = 1:numColumns
        bruins (rr,cc,3) = bruins (rr,cc,3) + cc ;
    end
end

image(bruins)

%% Transitioning to real images

% set folder 
cd 'C:\Users\mdeve\OneDrive\Documents\NYU\2019 Summer\Stimuli\'
dress = imread('thedress.jpg');

cd 'C:\Users\mdeve\OneDrive\Documents\NYU\2019 Summer\Scripts' % move up ONE level of the folder path hierarchy

% DOTS:
% one dot = object
% two dots = move up in the folder path 

%% "Dress" Code
figure 
image(dress) % gives you warped image - there are more rows than columns (aspect ratio is wrong)

% correcting for the aspect ratio by setting axis equal
axis equal
% getting rid of the white space by removing the axis
axis off

%% decomposing the dress into its component channels
dressModified = dress;
figure
subplot(2,2,1)
image(dress) % normal dress
 % now we need a RGB triplet without only red 
subplot(2,2,2)
dressModified(:,:,2:3) = 0 ;
image(dressModified)

% green version
subplot(2,2,3)
dressGreen = dress ;
dressGreen(:,:, [1 3]) = 0 ; 
image(dressGreen)

% blue version
subplot(2,2,4)
dressblue = dress ;
dressblue(:,:,1:2) = 0 ; 
image(dressblue)

%% Testing hypothesis about the dress: Is it just brightness?
% we can change the matrix values to adjust brightness

brightValue = 100 ; 
brightdress = dress + brightValue ; 
figure ; image(brightdress)

% lets put the bright dress side by side with the original
% subplot works do do this, but it leaves a lot of extra space.
% you could use "montage"  as well
% the best way is to create ONE matrix that is made up of both

crossSize = 10
biggerMatrix = [dress brightdress]; 
sizeMatrix = size(biggerMatrix)
temp1 = 1:sizeMatrix(1); 
centerRow = round(median(temp1));
temp2 = 1:sizeMatrix(2) ;
centerColumn = round(median(temp2));

%% Take a look at Pascals script from here on...
% Rows 
biggerMatrix(centerRow-crossSize:centerRow+crossSize , centerColumn-crossSize : centerColumn + crossSize,1) = 255 ;
biggerMatrix(centerRow-crossSize : centerRow+crossSize, ...
    centerColumn - crossSize : centerColumn + crossSize, 2:3) = 0 ;

image(biggerMatrix)
%% inverted color image

%simply take the image from 255
% Ex:
invertedDress = 255 - dress ;
image(invertedDress)

%% blurring the dress
%blur restuls from averaging of neighboring pixels. This is done by 
% convolving the image with a kernel

blurFactor = 35 ; 
kernel = ones(blurFactor);

blurredDress = convn(dress, kernel, 'same')./sum(sum(kernel)) ; 
image(uint8(round(blurredDress))) ;
axis equal
axis off

% conv different versions: - look at Pascal's version
% without any input - takes the average from non-existent values ( all
    % zeros) this darkens the edges of the image
% with 'valid' - zero padded
% with 'same'  - no zero padding

