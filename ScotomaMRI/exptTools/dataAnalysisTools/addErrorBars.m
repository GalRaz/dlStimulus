function addErrorBars(x, y, ey, ex, lineStyle, yCapLength, xCapLength)% addErrorBars(x, y, ey, [ex], [lineStyle], [yCapLength], [xCapLength])%% Adds error bars to the current figure.% ey = error bars along the y-axis (length = +/- ey).% ex = error bars along the x-axis (length = +/- ex).% (either may be 0 for no error bars along that axis)%% lineStyle determines the style of the error bars% (do 'help plot' to see your options)% It defaults to 'k-', a solid black line, if omitted or empty.%% yCapLength determines the length of the little lines% which 'cap' the y error bars.  (defaults to zero)%% xCapLength determines the length of the little lines% which 'cap' the x error bars.  (defaults to zero)%% For log-scaled axes, you might want to pass a vector for% the cap length so that the caps are all the same length.% e.g:%   x = [1 2 4 8 16]; %   y = [2.3 2.5 2.4 2.9 2.6];%   ey = y.*randn(1,length(y))*.2;%   loglog(x,y,'k');%   addErrorBars(x,y,ey,0,[],x*.1);%% 99.03.17 RFD: wrote it.% 99.08.12 RFD: added a few lines to ignore nansif ~exist('lineStyle', 'var')   lineStyle = [];endif isempty(lineStyle)   lineStyle = 'k-';endif ~exist('yCapLength', 'var')   yCapLength = 0;endif ~exist('xCapLength', 'var')   xCapLength = 0;endif ~iscell(ey)	ey = {ey,ey};endif length(ey)==1	ey = {ey{1},ey{1}};endif ~exist('ex', 'var')   ex = {0,0};endif isempty(ex)   ex = {0,0};endif ~iscell(ex)	ex = {ex,ex};endif length(ex)==1	ex = {ex{1},ex{1}};endkeepers = find(~isnan(x) & ~isnan(y));if isempty(keepers)   disp('addErrorBars: non non-nan (x,y) pairs!');   return;endx = x(keepers);y = y(keepers);hld = get(gca,'NextPlot');hold on;xb = zeros(1,length(x)*3);yb = zeros(1,length(y)*3);% add Y error barsxb(1:3:end) = x;xb(2:3:end) = x;xb(3:3:end) = nan;yb(1:3:end) = y + ey{2};yb(2:3:end) = y - ey{1};yb(3:3:end) = nan;plot(xb,yb,lineStyle);% add Y error bar capsif yCapLength > 0   xb(1:3:end) = x - yCapLength;   xb(2:3:end) = x + yCapLength;   xb(3:3:end) = nan;   yb(1:3:end) = y - ey{1};   yb(2:3:end) = y - ey{1};   yb(3:3:end) = nan;   plot(xb,yb,lineStyle);   xb(1:3:end) = x - yCapLength;   xb(2:3:end) = x + yCapLength;   xb(3:3:end) = nan;   yb(1:3:end) = y + ey{2};   yb(2:3:end) = y + ey{2};   yb(3:3:end) = nan;   plot(xb,yb,lineStyle);end% add X error barsxb(1:3:end) = x + ex{2};xb(2:3:end) = x - ex{1};xb(3:3:end) = nan;yb(1:3:end) = y;yb(2:3:end) = y;yb(3:3:end) = nan;plot(xb,yb,lineStyle);% add X error bar capsif xCapLength > 0   xb(1:3:end) = x - ex{1};   xb(2:3:end) = x - ex{1};   xb(3:3:end) = nan;   yb(1:3:end) = y - xCapLength;   yb(2:3:end) = y + xCapLength;   yb(3:3:end) = nan;   plot(xb,yb,lineStyle);      xb(1:3:end) = x + ex{2};   xb(2:3:end) = x + ex{2};   xb(3:3:end) = nan;   yb(1:3:end) = y - xCapLength;   yb(2:3:end) = y + xCapLength;   yb(3:3:end) = nan;   plot(xb,yb,lineStyle);endif(hld(1)=='r')	hold off;end