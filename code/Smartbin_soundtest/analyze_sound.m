clear all;
close all;
soundFileDir = './sound_test/500-500-10000Hz/';

audiofile = strcat(soundFileDir,'v_book.mp3');
[y,Fs] = audioread(audiofile);
y = y(1:Fs*2);
y_1 = y;
%sound(y,Fs);
F = fftshift(abs(fft(y)));
f = linspace(-Fs/2, Fs/2, numel(y)+1);
f(end) = []; 
figure(1)
plot(f, F);
title(strrep(audiofile,'_','\_'))
xlim([0,10000])
% ylim([0,50])


audiofile = strcat(soundFileDir,'v_book_2.mp3');
[y,Fs] = audioread(audiofile);
y = y(1:Fs*2);
%sound(y,Fs);
y_2 = y;
F = fftshift(abs(fft(y)));
f = linspace(-Fs/2, Fs/2, numel(y)+1);
f(end) = []; 
figure(2)
plot(f, F);
title(strrep(audiofile,'_','\_'))
xlim([0,10000])
% ylim([0,50])

audiofile = strcat(soundFileDir,'v_book_3.mp3');
[y,Fs] = audioread(audiofile);
y = y(1:Fs*2);
%sound(y,Fs);
y_3 = y;
F = fftshift(abs(fft(y)));
f = linspace(-Fs/2, Fs/2, numel(y)+1);
f(end) = []; 
figure(3)
plot(f, F);
title(strrep(audiofile,'_','\_'))
xlim([0,10000])
% ylim([0,50])


% audiofile = '8000_water.mp3';
% [y,Fs] = audioread(audiofile);
% %sound(y,Fs);
% y_4 = y;
% F = fftshift(abs(fft(y)));
% f = linspace(-Fs/2, Fs/2, numel(y)+1);
% f(end) = []; 
% figure(4)
% plot(f, F);
% title(audiofile)
% % xlim([6000,9000])
% % ylim([0,50])

figure(5)
hold on
plot(y_1,'-k')
plot(y_2,'-r')
plot(y_3,'-b')

% figure(6)
% hold on
% 
% [imn,imx] = minmaxloc(y_1);
% plot(y_1(imx))
% 
% [imn,imx] = minmaxloc(y_2);
% plot(y_2(imx))
% 
% [imn,imx] = minmaxloc(y_3);
% plot(y_3(imx))
% 
% % [imn,imx] = minmaxloc(y_4);
% % plot(y_4(imx))