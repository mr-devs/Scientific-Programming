%% Statistics %%

%% The canonical data analysis cascade

% 1. Create a loader function - this program puts dat into Matlab format.
% Analogous to transducer: Retina or cochlea.

% 2. Pruner/Integrity checker/Filter - this makse sure that the data to be
% analyzied is usable. Analogous to filter dunction of LGN or MGN THalamus,
% Choking off irrelevant data.

% 3. Categorizer. Analogous to V1. Format the data properly. 

% 4. a/b/c Calculator Analogous to extrastriate cortex. Do specialized
% calculations on the same data. Specialized streams.

% 5. a/b/c Plotter - output. Analagous to motor cortex. Makes figures. Also
% saves files.

% 6. Wrapper - involking the previous programs, in the correct order. That
% would be the brain itself. 
%% 0 Initialize
clear
close all
clc

%% 1. Loader - Transduction - bring your data from the format it is saved in

M1_ = xlsread('C:\Users\mdeve\OneDrive\Documents\NYU\2019 Summer\classData\MATRIX1.xls')
M2_ = xlsread('C:\Users\mdeve\OneDrive\Documents\NYU\2019 Summer\classData\MATRIX2.xls')
M3_ = xlsread('C:\Users\mdeve\OneDrive\Documents\NYU\2019 Summer\classData\MATRIX3.xls')

%% 2. Pruning

% 2.a Removing missing values
m1cleaned = rmmissing(M1_) % removes all NaN values
mean(M1_) 
mean(m1cleaned)
%% 2.b
% 
M1cleaned = removenans2019(M1_)
M2cleaned = removenans2019(M2_)
M3cleaned = removenans2019(M3_)

%% 3. Format
% Usually spend most of your time here, but data is already cleaned.
 
%% 4. Analysis proper (Calculations)

mu1 = mean(M1cleaned)
mu2 = mean(M2cleaned)

%% You gave up.
mu3 = mean(M3cleaned)

n1 = length(M1cleaned_