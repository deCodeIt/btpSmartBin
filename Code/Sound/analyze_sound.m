clear all;
close all;
soundFileDir = './sound_files/500-500-10000Hz/Audacity/';

for audioFiles = {{'v_empty.wav','v_book.wav','v_water.wav'},{'v_empty_2.wav','v_book_2.wav','v_water_2.wav'},{'v_empty_3.wav','v_book_3.wav','v_water_3.wav'}}
    
    figure('name',sprintf('Frequency_Analysis_Of %s, %s, and %s',audioFiles{1}{1},audioFiles{1}{2},audioFiles{1}{3}));
    
    audiofile = strcat(soundFileDir,audioFiles{1}{1});
    [y,Fs] = audioread(audiofile);
    % y = y(1:Fs*2);
    y_1 = y;
    F = fftshift(abs(fft(y)));
    f = linspace(-Fs/2, Fs/2, numel(y)+1);
    f(end) = []; 
    subplot(1,3,1);
    plot(f, F);
    title(strrep(audioFiles{1}{1},'_','\_'))
    xlim([0,10000])
    % ylim([0,50])


    audiofile = strcat(soundFileDir,audioFiles{1}{2});
    [y,Fs] = audioread(audiofile);
    % y = y(1:Fs*2);
    y_2 = y;
    F = fftshift(abs(fft(y)));
    f = linspace(-Fs/2, Fs/2, numel(y)+1);
    f(end) = []; 
    subplot(1,3,2);
    plot(f, F);
    title(strrep(audioFiles{1}{2},'_','\_'))
    xlim([0,10000])
    % ylim([0,50])

    audiofile = strcat(soundFileDir,audioFiles{1}{3});
    [y,Fs] = audioread(audiofile);
    % y = y(1:Fs*2);
    y_3 = y;
    F = fftshift(abs(fft(y)));
    f = linspace(-Fs/2, Fs/2, numel(y)+1);
    f(end) = []; 
    subplot(1,3,3);
    plot(f, F);
    title(strrep(audioFiles{1}{3},'_','\_'))
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
    
    saveas(gcf,sprintf('Frequency_Analysis_Of_%s_%s_and_%s.tif',audioFiles{1}{1},audioFiles{1}{2},audioFiles{1}{3}),'tiffn');

    figure('name',sprintf('Time_vs_Amplitude_Analysis_Of %s, %s, and %s',audioFiles{1}{1},audioFiles{1}{2},audioFiles{1}{3}))
    hold on
    plot(y_1,'-k','DisplayName',strrep(audioFiles{1}{1},'_','\_'))
    plot(y_2,'-r','DisplayName',strrep(audioFiles{1}{2},'_','\_'))
    plot(y_3,'-b','DisplayName',strrep(audioFiles{1}{3},'_','\_'))
    legend('show')
    title(strrep(sprintf('Combined Analysis of Time vs Amplitude for %s, %s, and %s',audioFiles{1}{1},audioFiles{1}{2},audioFiles{1}{3}),'_','\_'));
    saveas(gcf,sprintf('Time_vs_Amplitude_Analysis_Of_%s_%s_and_%s.tif',audioFiles{1}{1},audioFiles{1}{2},audioFiles{1}{3}),'tiffn');
    
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
end