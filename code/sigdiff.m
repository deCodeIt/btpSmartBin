function [ y ] = sigdiff( x )
%differentiation of sigmoid function
    tmp_y = sig(x);
    y = tmp_y*(1-tmp_y);
end

