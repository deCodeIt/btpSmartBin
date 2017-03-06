%% The analysis of correlation between audio recordings for bin being empty or having either water or papers
% Assuming the files are of same length (~ 40 secs)
% for each frequency in 3 classes and their samples, plot the bargraph
% denoting the mean and variance for the respective classes

clear all;
close all;
soundFileDir = './sound_files/500-500-10000Hz/';

filesEmpty = {'v_empty.wav','v_empty_2.wav','v_empty_3.wav'};
filesPaper = {'v_paper.wav','v_paper_2.wav','v_paper_3.wav'};
filesWater = {'v_water.wav','v_water_2.wav','v_water_3.wav'};
currentFiles = {filesEmpty,filesPaper,filesWater};
le={'diff(Empty,Paper)','diff(Empty,Water)','diff(Water,Paper)'};
fileName = 'mean_std_of_empty_paper_water';

duration = 2;% interval/seconds for each frequency sample
classes = length(currentFiles); % audio classes like empty,paper,water

figure('name','Absolute Difference - Mean and Variance Analysis');

%extract sample count and frequency for the audio wave assuming all are of
%same duration and have same sampling rate

audiofile = strcat(soundFileDir,filesEmpty{1});
[y,f] = audioread(audiofile);

samples = length(y)/(duration*f);
freq = 500*(1:samples);

%extracted

meanSignal = zeros(classes,samples);
stdSignal = zeros(classes,samples);
averageSignal = zeros(classes,length(y)); % stores the average of each class (y)

classCount = 1; %keeps the number of the class that needs to be processed
for classFiles = currentFiles
    
    currentAverageSignal = zeros(length(classFiles{1}),length(y));
    
    audioCount = 1; % keeps track of the number of file, to be read, of the current class of audio files
    for audioFiles = classFiles{1}
        audiofile = strcat(soundFileDir,audioFiles{1});
        [y,~] = audioread(audiofile);
        y = y(1:f*samples*duration);
        [~,y] = smooth_signal(y,1000);
        currentAverageSignal(audioCount,:) = y; % store the current audio for later average calculations
        audioCount = audioCount + 1; % increment the file number count
    end
    % get the mean of the signals for each sample of the average of every recordings of the class
    averageSignal(classCount,:) = mean(currentAverageSignal,1);
    
    classCount = classCount + 1; % increment current class count

end

% Calculate mean and standard deviation of the differences
empty = 1;
paper = 2;
water = 3;

emptyPaperDiff = abs(averageSignal(empty,:) - averageSignal(paper,:));
emptyWaterDiff = abs(averageSignal(empty,:) - averageSignal(water,:));
waterPaperDiff = abs(averageSignal(water,:) - averageSignal(paper,:));
classCount = 1;
for yy = [emptyPaperDiff;emptyWaterDiff;waterPaperDiff]'
    y = yy'; % correcting y to be a row vector
    for i=0:(samples-1)
        % for each sample calculate its average over 2 secs and put that
        % average in the results
        sample = y(i*duration*f+1:(i+1)*duration*f); % extract the current frequency sample
%         [~,sample] = smooth_signal(sample,1000); % smooth the sample
        meanSignal(classCount,i+1) = mean(sample); % store its average across the duration
        stdSignal(classCount,i+1) = std(sample); % store its average across the duration
    end
    classCount = classCount + 1;
end

% now plot the bar and errorbar graph to display mean and standard
% deviation of the differences
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
title('Absolute Difference - Mean and Variance Analysis');
save(strcat(fileName,'.fig'),'meanSignal','stdSignal');
saveas(gcf,strcat(fileName,'.png'),'png');