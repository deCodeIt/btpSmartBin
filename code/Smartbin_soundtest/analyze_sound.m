clear all;
close all;
audiofile = '8000_books.mp3';
[y,Fs] = audioread(audiofile);
y_book = y;
%sound(y,Fs);
F = fftshift(abs(fft(y)));
f = linspace(-Fs/2, Fs/2, numel(y)+1);
f(end) = []; 
figure(1)
plot(f, F);
title(audiofile)
xlim([6000,9000])
ylim([0,50])


audiofile = '8000_empty.mp3';
[y,Fs] = audioread(audiofile);
%sound(y,Fs);
y_empty = y;
F = fftshift(abs(fft(y)));
f = linspace(-Fs/2, Fs/2, numel(y)+1);
f(end) = []; 
figure(2)
plot(f, F);
title(audiofile)
xlim([6000,9000])
ylim([0,50])

audiofile = '8000_flowee.mp3';
[y,Fs] = audioread(audiofile);
%sound(y,Fs);
y_flower = y;
F = fftshift(abs(fft(y)));
f = linspace(-Fs/2, Fs/2, numel(y)+1);
f(end) = []; 
figure(3)
plot(f, F);
title(audiofile)
xlim([6000,9000])
ylim([0,50])


audiofile = '8000_water.mp3';
[y,Fs] = audioread(audiofile);
%sound(y,Fs);
y_water = y;
F = fftshift(abs(fft(y)));
f = linspace(-Fs/2, Fs/2, numel(y)+1);
f(end) = []; 
figure(4)
plot(f, F);
title(audiofile)
xlim([6000,9000])
ylim([0,50])

% figure(5)
% plot(y_empty,'ok')
% hold on
% plot(y_water,'+r')
% plot(y_book,'^b')
% plot(y_flower,'sc')
% hold off
y_empty = y_empty(200000:end);
[imn,imx] = minmaxloc(y_empty);
figure(6)
plot(y_empty(imx))
[imn,imx] = minmaxloc(y_water);
 hold on
plot(y_water(imx))
[imn,imx] = minmaxloc(y_book);
plot(y_book(imx))
[imn,imx] = minmaxloc(y_flower);
plot(y_flower(imx))