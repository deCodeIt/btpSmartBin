% This function is the primary driver for homework 3 part 1
function l3a
close all;
clear all;
clc;
% we will experiment with a simple 2d dataset to visualize the decision
% boundaries learned by a MLP. Our goal is to study the changes to the
% decision boundary and the training error with respect to the following
% parameters
% - increasing overlap between the data points of the different classes
% - increasing the number of training iterations
% - increase the number of hidden layer neurons
% - see the effect of learning rate on the convergence of the network

rand('seed', 1);

% Reading data from file

X = [];
Y = [];

fid = fopen('signalData.txt');
while 1
    tline = fgetl(fid);
    if ~ischar(tline)
        break;
    end
    data_instance = str2num(tline);
    
    instance = zeros(1,10);
    instance(1,data_instance(1,1)/11 + 1)=1; % height of bin
    
    data_instance = data_instance(1,2:end);
    
    signal = data_instance(1,1:2:end)'; % column vector with signal
    freq = data_instance(1,2:2:end)'; % column vector with freq of ith signal
    
    sxf = sum(signal.*freq,1);
    n = sum(freq,1);
    mean_signal = sxf/n;
    sx2f = sum(signal.*signal.*freq,1);
    ssx = sx2f - sxf*sxf/n;
    sd = sqrt(ssx/(n-1));
    
    Y = [Y; instance];
    
    instance = [mean_signal sd]; % our instance has meanSignal and Standard Deviation
    X = [X; instance];
end

[X Y]
fclose(fid);

% Experimenting with MLP

% number of epochs for training
nEpochs = 10000;

% learning rate
eta = 0.001;

% number of hidden layer units
H = 8;

[w, v, trainerror] = mlptrain(X,Y, H, eta, nEpochs);

%ydash = mlptest(testX, w, v);
return;

function [w v trainerror] = mlptrain(X, Y, H, eta, nEpochs)
% X - training data of size NxD
% Y - training labels of size NxK
% H - the number of hiffe
% eta - the learning rate
% nEpochs - the number of training epochs
% define and initialize the neural network parameters

% number of training data points
N = size(X,1);
% number of inputs
D = size(X,2); % excluding the bias term
% number of outputs
K = size(Y,2);

% add bias to X
Xbias = [ones(N,1) X];

% weights for the connections between input and hidden layer
% random values from the interval [-0.3 0.3]
% w is a Hx(D+1) matrix
w = -0.3+(0.6)*rand(D+1,H);

% weights for the connections between input and hidden layer
% random values from the interval [-0.3 0.3]
% v is a Kx(H+1) matrix
v = -0.3+(0.6)*rand(H+1,K);

% mlp training through stochastic gradient descent
trainerror = 0.0*zeros(1,nEpochs);

% correct height of instances
[~,idxY] = max(Y,[],2);

for epoch = 1:nEpochs
        % find S1 for input to hidden layer
        S1 = Xbias*w;
        % S1 is a NxH matrix where a row 'r' and column 'c' represents
        % hidden layer c th value for r th example/instance
        
        % Now use sigmoid to calculate Z from S1
        S1_dash = arrayfun(@sig,S1); % applies sig to every element as required
        %Z = S1_dash >= 0.5; % hidden layer units after applying threshold for sigmoid function
        Z = S1_dash;
        % Z is a NxH matrix
        Z = [ones(N,1) Z]; %now Z includes Z_0 as well and Z is now a NxH+1 matrix
        
        % now find S2 for hidden to output layer
        S2 = Z*v;
        S2_dash = arrayfun(@exp,S2);
        % S2 is a NxK matrix
        softMaxDen = sum(S2_dash,2); % summation k=1..K of exp(S2(k,i))
        softMaxDenForAll = repmat(softMaxDen,1,K);
        
        O = S2_dash./softMaxDenForAll;
        
        delta_v = eta*((O-Y)'*Z)';
        delta_w = eta*((arrayfun(@sigdiff,S1)'.*(v(2:end,:)*(O-Y)'))*Xbias)';
        v = v - delta_v;
        w = w - delta_w;
        
    ydash = mlptest(X, w, v);
    % compute the training error
    % ---------
    trainerror(epoch) = sum(-log2(sum(Y.*ydash,2)));
    % ---------
    
    [~,idx] = max(ydash, [], 2);
    
    correct = sum(idx == idxY,1);
    fprintf('training error for H:%d after epoch %d: %f, Accuracy : %.2f%%\n',H,epoch,...
        trainerror(epoch),100*correct/size(idxY,1));
    
end
return;

function ydash = mlptest(X, w, v)
% forward pass of the network

% number of inputs
N = size(X,1);

% number of outputs
K = size(v,2);

%add bias to X
X = [ones(N,1) X];

% forward pass to estimate the outputs
% --------------------------------------
% input to hidden for all the data points
% calculate the output of the hidden layer units
% find S1 for input to hidden layer
        S1 = X*w;
        
        % S1 is a NxH matrix where a row 'r' and column 'c' represents
        % hidden layer c th value for r th example/instance
        
        % Now use sigmoid to calculate Z from S1
        S1_dash = arrayfun(@sig,S1); % applies sig to every element as required
        %Z = S1_dash >= 0.5; % hidden layer units after applying threshold for sigmoid function
        Z = S1_dash;
        % Z is a NxH matrix
        Z = [ones(N,1) Z]; %now Z includes Z_0 as well and Z is now a NxH+1 matrix
        
        S2 = Z*v;
        S2_dash = arrayfun(@exp,S2);
        % S2 is a NxK matrix
        softMaxDen = sum(S2_dash,2); % summation k=1..K of exp(S2(k,i))
        softMaxDenForAll = repmat(softMaxDen,1,K);
        ydash = S2_dash./softMaxDenForAll;

return;