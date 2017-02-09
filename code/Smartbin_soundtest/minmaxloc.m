function [imn,imx]=minmaxloc(y)
%
% Locate indexes of minima and maxima
%
S=diff(y);
S1=S(2:end);
S2=S(1:end-1);
imx=find(S1.*S2 < 0 & S1-S2 < 0)+1;
imn=find(S1.*S2 < 0 & S1-S2 > 0)+1;
end