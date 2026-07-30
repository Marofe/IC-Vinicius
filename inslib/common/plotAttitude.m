function plotAttitude(varargin)
figure
colors=[0, 0.4470, 0.7410;
    0.8500, 0.3250, 0.0980;
    0, 1, 0;
    0.9290, 0.6940, 0.1250;
    0.4940, 0.1840, 0.5560;
    0.3010, 0.7450, 0.9330;
    0.6350, 0.0780, 0.1840];
subplot(3,1,1)
hold on
for j=1:nargin
semilogx(varargin{j}.time,varargin{j}.yaw,'.','color',colors(j,:));
leg{j}=varargin{j}.name;
end
title('Yaw')
legend(leg{:})
grid on
subplot(3,1,2)
hold on
for j=1:nargin
semilogx(varargin{j}.time,varargin{j}.pitch,'.','color',colors(j,:));
end
title('Pitch')
legend(leg{:})
grid on
subplot(3,1,3)
hold on
for j=1:nargin
semilogx(varargin{j}.time,varargin{j}.roll,'.','color',colors(j,:));
end
title('Roll')
grid on
suptitle('Attitude')
legend(leg{:})
end

