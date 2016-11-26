function [ y ] = sig( x )
%Returns sigmoid of x
    y = 1/(1+exp(-x));
end

