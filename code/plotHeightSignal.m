function [ output_args ] = plotHeightSignal()
%Plots the graph of height v/s signal for a given substance
X_mean = [];
Y = [];
hold on;

fid = fopen('signalData.txt');
while 1
    tline = fgetl(fid);
    if ~ischar(tline)
        break;
    end
    data_instance = str2num(tline);
    instance = data_instance(1,1);
    data_instance = data_instance(1,2:end);
    
    signal = data_instance(1,1:2:end); % column vector with signal
    freq = data_instance(1,2:2:end); % column vector with freq of ith signal
    
    sxf = sum(signal.*freq,1);
    n = sum(freq,1);
    mean_signal = sxf/n;
    
    X_mean = [X_mean; mean_signal];
    Y = [Y; instance];
    scatter(repmat(instance,1,size(signal,2)),signal,freq,'r.');
%     Y = [Y; repmat(data_instance(1,1),1,size(signal,2))];
%     X_signal = [X_signal; signal];
%     X_freq = [X_freq; freq];
end

plot(Y,X_mean,'b-','linewidth',2);
end

