function plotLeverarm(est,l0)
figure
    plot(est.time,est.leverarm,'linewidth',2)
    hold on
    line([est.time(1) est.time(end)],[l0(1) l0(1)],'linewidth',2,'Color','black','lineStyle','--')
    line([est.time(1) est.time(end)],[l0(2) l0(2)],'linewidth',2,'Color','black','lineStyle','--')
    line([est.time(1) est.time(end)],[l0(3) l0(3)],'linewidth',2,'Color','black','lineStyle','--')
    xlabel('GPST')
    ylabel('m')
    grid on
    title('Lever-arm')
    legend('x','y','z')
end

