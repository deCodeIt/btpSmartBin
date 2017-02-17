function [ output_args ] = getCoverageArea( x , y,slope, r, epsilon, scaleX, scaleY )
% Gives you the plane where (x,y), the mid point, has its coverage as a
% wifi hotspot
% r is the radius of coverage (approx. to rectangle)
% (x,y) is the point/bin coordinate
% epsilon defines the error with line of sight
% slope is the slope of line joining two intel edison nodes on the same bin


rx = r*scaleX;
ry = r*scaleY;
if slope ~= 0 && slope ~= inf
    mPerpendicular = 1.0/slope;

    X = sqrt((epsilon*epsilon)/(1.0+mPerpendicular*mPerpendicular));
    % Y = sqrt((epsilon*epsilon) - (X*X));
    Y = -X/slope;
elseif slope==0
    X = 0;
    Y = -epsilon;
else
    X = epsilon;
    Y = 0;
end
X = X*scaleX;
Y = Y*scaleY;

ydash1 = Y + y;
ydash2 = -Y + y;
xdash1 = X + x;
xdash2 = -X + x;

% plot(xdash1,ydash1,'o');
% plot(xdash2,ydash2,'o');

% _dash1 and _dash2 represent the coordinate of point throught which the
% top and below boundaries pass respectively

% now draw the rectangle, find the corner points and plot them

%contains the corner points
XX = zeros(1,5);
YY = zeros(1,5);

%top left point
XX(1,1) = xdash1 - rx/sqrt(1+slope*slope);
if slope==inf
    YY(1,1) = ydash1 - ry;
else
    YY(1,1) = ydash1 - ry*slope/sqrt(1+slope*slope);
end

%top right point
XX(1,2) = xdash1 + rx/sqrt(1+slope*slope);
if slope==inf
    YY(1,2) = ydash1 + ry;
else
    YY(1,2) = ydash1 + ry*slope/sqrt(1+slope*slope);
end

%bottom right point
XX(1,3) = xdash2 + rx/sqrt(1+slope*slope);
if slope==inf
    YY(1,3) = ydash2 + ry;
else
    YY(1,3) = ydash2 + ry*slope/sqrt(1+slope*slope);
end

%bottom left point
XX(1,4) = xdash2 - rx/sqrt(1+slope*slope);
if slope==inf
    YY(1,4) = ydash2 - ry;
else
    YY(1,4) = ydash2 - ry*slope/sqrt(1+slope*slope);
end

%top left point
XX(1,5) = XX(1,1);
YY(1,5) = YY(1,1);

h=fill(XX,YY,[rand(),rand(),rand()]);
set(h,'facealpha',0.5);
% plot(x,y,'*'); % plot the point
% text(x,y,strcat('(',num2str(x),',',num2str(y),')'),'HorizontalAlignment','left','VerticalAlignment','bottom');
% axis square;
% set (gcf, 'WindowButtonMotionFcn', @mouseclick);
end

