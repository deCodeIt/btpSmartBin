%% The analysis of new recorded files where the bin was either empty or had water

clear all;
close all;
soundFileDir = './sound_files/500-500-10000Hz/';

filesEmpty = {'e1.wav','e2.wav','e3.wav','e4.wav','e5.wav'};
filesWater = {'w1.wav','w2.wav','w3.wav','w4.wav','w5.wav'};

% filesEmpty = {'v_empty.wav','v_empty_2.wav','v_empty_3.wav'}; %empty
% filesWater = {'v_paper.wav','v_paper_2.wav','v_paper_3.wav'}; %paper

for audioFilesEmpty = filesEmpty
    for audioFilesWater = filesWater

        figure('name',sprintf('Frequency_Analysis_Of %s and %s',audioFilesEmpty{1},audioFilesWater{1}));
        audiofile = strcat(soundFileDir,audioFilesEmpty{1});
        [y,Fs] = audioread(audiofile);
        y_1 = y;
        F = fftshift(abs(fft(y)));
        f = linspace(-Fs/2, Fs/2, numel(y)+1);
        f(end) = []; 
        subplot(2,1,1);
        plot(f, F);
        title(strrep(audioFilesEmpty{1},'_','\_'))
        xlim([0,10000])
        ylim([0,50])


        audiofile = strcat(soundFileDir,audioFilesWater{1});
        [y,Fs] = audioread(audiofile);
        y_3 = y;
        F = fftshift(abs(fft(y)));
        f = linspace(-Fs/2, Fs/2, numel(y)+1);
        f(end) = []; 
        subplot(2,1,2);
        plot(f, F);
        title(strrep(audioFilesWater{1},'_','\_'))
        xlim([0,10000])
        ylim([0,50])

        saveas(gcf,sprintf('Frequency_Analysis_Of_%s_and_%s.png',audioFilesEmpty{1},audioFilesWater{1}),'png');
        close;
        
        figure('name',sprintf('Time_vs_Amplitude_Analysis_Of %s and %s',audioFilesEmpty{1},audioFilesWater{1}))
        hold on
        plot(y_1,'-k','DisplayName',strrep(audioFilesEmpty{1},'_','\_'))
        plot(y_3,'-b','DisplayName',strrep(audioFilesWater{1},'_','\_'))
        legend('show')
        title(strrep(sprintf('Combined Analysis of Time vs Amplitude for %s and %s',audioFilesEmpty{1},audioFilesWater{1}),'_','\_'));
        saveas(gcf,sprintf('Time_vs_Amplitude_Analysis_Of_%s_and_%s.png',audioFilesEmpty{1},audioFilesWater{1}),'png');
        close;

    end
end