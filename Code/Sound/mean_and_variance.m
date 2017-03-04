%% The analysis of correlation between audio recordings for bin being empty or having either water or books
% Assuming the files are of same length (~ 40 secs)
% for each frequency in 3 classes and their samples, plot the bargraph
% denoting the mean and variance for the respective classes

clear all;
close all;
soundFileDir = './sound_files/500-500-10000Hz/';

filesEmpty = {'v_empty.wav','v_empty_2.wav','v_empty_3.wav'};
filesBook = {'v_book.wav','v_book_2.wav','v_book_3.wav'};
filesWater = {'v_water.wav','v_water_2.wav','v_water_3.wav'};
currentFiles = {filesEmpty,filesBook,filesWater};
le={'Empty','Book','Water'};
fileName = 'mean_std_of_empty_book_water';

% filesEmpty = {'e1.wav','e2.wav','e3.wav','e4.wav','e5.wav'};
% filesWater = {'w1.wav','w2.wav','w3.wav','w4.wav','w5.wav'};
% currentFiles = {filesEmpty,filesWater};
% le={'Empty','Water'};
% fileName = 'mean_std_of_empty_water';

% filesEmpty = {'v_empty.wav','v_empty_2.wav','v_empty_3.wav'};
% filesBook = {'v_book.wav','v_book_2.wav','v_book_3.wav'};
% currentFiles = {filesEmpty,filesBook};
% le={'Empty','Book'};
% fileName = 'mean_std_of_empty_book';

duration = 2;% interval/seconds for each frequency sample
classes = length(currentFiles); % audio classes like empty,book,water

figure('name','Mean and Variance Analysis');

%extract sample count and frequency for the audio wave assuming all are of
%same duration and have same sampling rate

audiofile = strcat(soundFileDir,filesEmpty{1});
[y,f] = audioread(audiofile);

samples = length(y)/(duration*f);
freq = 500*(1:samples);

%extracted

meanSignal = zeros(classes,samples);
stdSignal = zeros(classes,samples);

classCount = 1; %keeps the number of the class that needs to be processed
for classFiles = currentFiles
    currentAverageSignal = zeros(length(classFiles{1}),samples);
    sampleCount = 1; % keeps track of the number of file, to be read, of the current class of audio files
    for audioFiles = classFiles{1}
        audiofile = strcat(soundFileDir,audioFiles{1});
        [y,~] = audioread(audiofile);

        for i=0:(samples-1)
            % for each sample calculate its average over 2 secs and put that
            % average in the results
            sample = y(i*duration*f+1:(i+1)*duration*f); % extract the current frequency sample
            [~,ys] = smooth_signal(sample,1000); % smooth the sample
            currentAverageSignal(sampleCount,i+1) = mean(ys); % store its average across the duration
        end
        sampleCount = sampleCount + 1; % increment the file number count
    end
    % get the mean of the signals for each sample of the average of every recordings of the class
    meanSignal(classCount,:) = mean(currentAverageSignal);
    stdSignal(classCount,:) = std(currentAverageSignal);
    
    classCount = classCount + 1; % increment current class count

end

% now plot the bar and errorbar graph to display mean and standard
% deviation

hold on;
hb = bar(1:samples,meanSignal');
drawnow(); % to allow the figure to be created
for ib = 1:numel(hb)
    %XData property is the tick labels/group centers; XOffset is the offset
    %of each distinct group
    xData = hb(ib).XData+hb(ib).XOffset;
    errorbar(xData,meanSignal(ib,:),stdSignal(ib,:),'r.')
end
legend(hb,le);
xAxisLegend = {'0.5','1','1.5','2','2.5','3','3.5','4','4.5','5','5.5','6','6.5','7','7.5','8','8.5','9','9.5','10'};
set(gca,'xtick',1:samples,'xticklabel', xAxisLegend);
xlabel('KHz');

save(strcat(fileName,'.fig'),'meanSignal','stdSignal');
saveas(gcf,strcat(fileName,'.png'),'png');