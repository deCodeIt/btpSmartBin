function[x,sY] = smooth_signal(y,num_samples)

    % num_samples = 1000; % samples in one sliding window
    coeff = ones(1,num_samples)/num_samples; %coeff for smoothening
    fDelay = (length(coeff)-1)/2;

    x = 1:size(y,1);
    x = x-fDelay/num_samples;
    
    [eH,eL] = envelope(y,num_samples,'rms');
    sY = filter(coeff,1,eH);

    % hold on;
    % plot(x,ye,'b',...
    %     x,hY,'g');
    
end