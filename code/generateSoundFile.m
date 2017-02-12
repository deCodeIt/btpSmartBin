%generates Sine wave audio

fs = 44100; % Hz
duration = 2; % seconds
t = 0:1/fs:duration; % time interval to generate audio waveform at the given sample rate
%f = 440; % Hz
y=[];
for f = 250:250:10000
    y = [y sin(2.*pi.*f.*t)];
end

audiowrite('sinewave250.wav',y,fs,'BitsPerSample',16,'Comment','Each frequency stays for 2 secs');