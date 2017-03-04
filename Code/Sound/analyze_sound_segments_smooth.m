%% The analysis of correlation between audio recordings for bin being empty or having either water or papers
% Assuming the files are of same length (~ 40 secs)
% using sliding window technique to smoothen the signal
clear all;
close all;
soundFileDir = './sound_files/500-500-10000Hz/';

filesEmpty = {'v_empty.wav','v_empty_2.wav','v_empty_3.wav'};
filesPaper = {'v_paper.wav','v_paper_2.wav','v_paper_3.wav'};
filesWater = {'v_water.wav','v_water_2.wav','v_water_3.wav'};

% filesEmpty = {'v_empty.wav'};
% filesPaper = {'v_paper.wav'};
% filesWater = {'v_water.wav'};

for audioFilesEmpty = filesEmpty
    for audioFilesPaper = filesPaper
        for audioFilesWater = filesWater
    
            figure('name',sprintf('Correlation_Amplitude_Analysis_Of %s, %s, and %s',audioFilesEmpty{1},audioFilesPaper{1},audioFilesWater{1}));
            
            audiofile = strcat(soundFileDir,audioFilesEmpty{1});
            [ye,Fs] = audioread(audiofile);
            
            audiofile = strcat(soundFileDir,audioFilesPaper{1});
            [yb,Fs] = audioread(audiofile);
            
            audiofile = strcat(soundFileDir,audioFilesWater{1});
            [yw,Fs] = audioread(audiofile);
            
            [xe,sye] = smooth_signal(ye,5000);
            [xb,syb] = smooth_signal(yb,5000);
            [xw,syw] = smooth_signal(yw,5000);
            
            hold on;
            plot(xe,sye,'k','DisplayName','Empty')
            plot(xb,syb,'r','DisplayName','Paper')
            plot(xw,syw,'b','DisplayName','Water');
        
            ylim([0,0.3]);
            legend('show');
            
            saveas(gcf,sprintf('Envelope_Analysis_Of_%s_%s_and_%s.png',audioFilesEmpty{1},audioFilesPaper{1},audioFilesWater{1}),'png');
        
            close;
            
            
% correlation
            duration = 2; % secs for each frequency
            audioC = zeros(floor((size(yw,1)/Fs)/duration),3); % stores the information of correlation between every pair of signal
            
%             for i = 0:duration:floor(size(yw,1)/Fs)-duration
%                 figure;
%                 yes = ye(i*Fs+1:(i+duration)*Fs); % samples of duration (2 secs) of different frequency
%                 ybs = yb(i*Fs+1:(i+duration)*Fs);
%                 yws = yw(i*Fs+1:(i+duration)*Fs);
%                 
%                 %smooth Y <class> sample - sYes,sYbs, sYws
%                 [xes,sYes] = smooth_signal(yes,1000);
%                 [xbs,sYbs] = smooth_signal(ybs,1000);
%                 [xws,sYws] = smooth_signal(yws,1000);
%                 
%                 plot(xes,sYes,'y',...
%                     xbs,sYbs,'r',...
%                     xws,sYws,'b');
%                 
% %                 aC1 = abs(corr(yes,ybs));
% %                 aC2 = abs(corr(yes,yws));
% %                 aC3 = abs(corr(ybs,yws));
% %                 audioC(i/duration+1,:) = [aC1,aC2,aC3];
%             end

    
            
%             h = bar(audioC);
%             grid on
%             % legend
%             le={'Empty & Paper','Empty & Water','Paper & Water'};
%             legend(h,le);
%             
%             xAxisLegend = {'0.5','1','1.5','2','2.5','3','3.5','4','4.5','5','5.5','6','6.5','7','7.5','8','8.5','9','9.5','10'};
%             set(gca,'xtick',1:floor(size(yw,1)/Fs)/duration,'xticklabel', xAxisLegend);
%             xlabel('KHz');
%             
%             xlim([0,floor(size(yw,1)/Fs)/duration+1])
%             ylim([0,1])
%             
%             % save the figure and variables
%             save(sprintf('CorrAmp_%s_%s_%s.mat',audioFilesEmpty{1},audioFilesPaper{1},audioFilesWater{1}),'audioC')
%             saveas(gcf,sprintf('Correlation_Amplitude_Analysis_Of_%s_%s_and_%s.tif',audioFilesEmpty{1},audioFilesPaper{1},audioFilesWater{1}),'tiffn');
%             close; % to close the fugure and save some memory ;)
        end
    end
end