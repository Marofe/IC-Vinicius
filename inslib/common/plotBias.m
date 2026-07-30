function plotBias(est,varargin)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
figure
    subplot(2,1,1)
    plot(est.time,est.bias(:,1),'linewidth',2)
    hold on
    plot(est.time,est.bias(:,2),'linewidth',2)
    plot(est.time,est.bias(:,3),'linewidth',2)
if nargin==2
    bias=varargin{1};
        plot(est.time,ones(1,size(est.bias,1))*bias(1),'--k','linewidth',2)
        plot(est.time,ones(1,size(est.bias,1))*bias(2),'--k','linewidth',2)
        plot(est.time,ones(1,size(est.bias,1))*bias(3),'--k','linewidth',2)
end

    title('Accelerometer bias (FRD)')
    legend('bax','bay','baz')
    grid on
    xlabel('GPST')
    ylabel('$m/s^2$','Interpreter','latex')
    if isfield(est,'takeoff')
        line([est.takeoff est.takeoff],[max(max(est.bias(1:3,:))) min(min(est.bias(1:3,:)))],'Color','black')
    end
    if isfield(est,'landing')
        line([est.landing est.landing],[max(max(est.bias(1:3,:))) min(min(est.bias(1:3,:)))],'Color','black')
    end
    subplot(2,1,2)
    est.bias(:,4:6)=rad2deg(est.bias(:,4:6))*3600;
    plot(est.time,est.bias(:,4:6),'linewidth',2)
    hold on
    if nargin==2
        bias=varargin{1};
        plot(est.time,ones(1,size(est.bias,1))*rad2deg(bias(4))*3600,'--k','linewidth',2)
        plot(est.time,ones(1,size(est.bias,1))*rad2deg(bias(5))*3600,'--k','linewidth',2)
        plot(est.time,ones(1,size(est.bias,1))*rad2deg(bias(6))*3600,'--k','linewidth',2)
    end
    legend('bgx','bgy','bgz')
    title('Gyroscope bias')
    grid on
    xlabel('GPST')
    ylabel('deg/h')
end

