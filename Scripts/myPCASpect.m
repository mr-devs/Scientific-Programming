%% combining primary component analysis and spectral analysis

load handel     % Load a preinstalled timeseries dataset

sound(y,Fs)     % you can listen to any matrix (Pascal plays this at the end of a long data analysis)

clear sound     % kills the sound

% Sound interprets the numbers in the matrix as a timeseries of amplitudes
% Each # represents the speaker membrane's r

%%

% singaling - window viewing tool
wvtool(hanning(256))
wvtool(hamming(256))
wvtool(bartlett(32))
wvtool(kaiser(128))
% !!! need to use a factor of two in the above!!! 

% A wide window gives you a good idea of the frequencies
% However, it does not give you any idea about the time - when these frequencies happened
% Windowsize is typically chosen as a result of 'domain knowledge' 
    % eeg = 10 milliseconds, etc.
windowShape = hanning(256) ;
frequencyRange = 0:64:Fs/2 ;
overl = length(windowShape)/2 ; % overlap
spectrogram(y,windowShape, overl, frequencyRange, Fs, 'yaxis') ;
colormap(jet)

%% building up a complex signal from simple signals (pure sine waves)

samplingFrequency = 1e4 ; % 10,000
signalFreq1 = 404 ; % hz A notes
t = 0:1/samplingFrequency:1 ; % Create a 1 second time base
signal1 = sin(2*pi*signalFreq1*t);
signalFreq = 523.25 ; % C note
signal2 = sin(2*pi*signalFreq2*t);
signal3 = signal2 + signal3 ;

figure
plot(t,signal1) % zoom into this bitch
soundsc(signal3, samplingFrequency) ;

%% take a break to create white noise..

wN = randn(samplingFrequency,1) ; % 10k random frequencies
sound(wN,samplingFrequency) ; 
% okay back to class
%% use a spectrogam to figureout the signals of signal 3


