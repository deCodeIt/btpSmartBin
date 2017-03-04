%% The analysis of audio recordings for bin being empty or having either water or papers

clear all;
close all;
soundFileDir = './sound_files/500-500-10000Hz/';

filesEmpty = {'v_empty.wav','v_empty_2.wav','v_empty_3.wav'};
filesPaper = {'v_paper.wav','v_paper_2.wav','v_paper_3.wav'};
filesWater = {'v_water.wav','v_water_2.wav','v_water_3.wav'};

for audioFilesEmpty = filesEmpty
    for audioFilesPaper = filesPaper
        for audioFilesWater = filesWater
    
            figure('name',sprintf('Frequency_Analysis_Of %s, %s, and %s',audioFilesEmpty{1},audioFilesPaper{1},audioFilesWater{1}));
            audiofile = strcat(soundFileDir,audioFilesEmpty{1});
            [y,Fs] = audioread(audiofile);
            y_1 = y;
            F = fftshift(abs(fft(y)));
            f = linspace(-Fs/2, Fs/2, numel(y)+1);
            f(end) = []; 
            subplot(3,1,1);
            plot(f, F);
            title(strrep(audioFilesEmpty{1},'_','\_'))
            xlim([0,10000])
            ylim([0,50])


            audiofile = strcat(soundFileDir,audioFilesPaper{1});
            [y,Fs] = audioread(audiofile);
            y_2 = y;
            F = fftshift(abs(fft(y)));
            f = linspace(-Fs/2, Fs/2, numel(y)+1);
            f(end) = []; 
            subplot(3,1,2);
            plot(f, F);
            title(strrep(audioFilesPaper{1},'_','\_'))
            xlim([0,10000])
            ylim([0,50])

            audiofile = strcat(soundFileDir,audioFilesWater{1});
            [y,Fs] = audioread(audiofile);
            y_3 = y;
            F = fftshift(abs(fft(y)));
            f = linspace(-Fs/2, Fs/2, numel(y)+1);
            f(end) = []; 
            subplot(3,1,3);
            plot(f, F);
            title(strrep(audioFilesWater{1},'_','\_'))
            xlim([0,10000])
            ylim([0,50])

            saveas(gcf,sprintf('Frequency_Analysis_Of_%s_%s_and_%s.tif',audioFilesEmpty{1},audioFilesPaper{1},audioFilesWater{1}),'tiffn');
%             saveas(gcf,sprintf('Frequency_Analysis_Of_%s_%s_and_%s.fig',audioFilesEmpty{1},audioFilesPaper{1},audioFilesWater{1}),'fig');
            close;
            
            figure('name',sprintf('Time_vs_Amplitude_Analysis_Of %s, %s, and %s',audioFilesEmpty{1},audioFilesPaper{1},audioFilesWater{1}))
            hold on
            plot(y_1,'-k','DisplayName',strrep(audioFilesEmpty{1},'_','\_'))
            plot(y_2,'-r','DisplayName',strrep(audioFilesPaper{1},'_','\_'))
            plot(y_3,'-b','DisplayName',strrep(audioFilesWater{1},'_','\_'))
            legend('show')
            title(strrep(sprintf('Combined Analysis of Time vs Amplitude for %s, %s, and %s',audioFilesEmpty{1},audioFilesPaper{1},audioFilesWater{1}),'_','\_'));
            saveas(gcf,sprintf('Time_vs_Amplitude_Analysis_Of_%s_%s_and_%s.tif',audioFilesEmpty{1},audioFilesPaper{1},audioFilesWater{1}),'tiffn');
%             saveas(gcf,sprintf('Time_vs_Amplitude_Analysis_Of_%s_%s_and_%s.fig',audioFilesEmpty{1},audioFilesPaper{1},audioFilesWater{1}),'fig');
            close;
        end
    end
end