function plotAccel(imu)
figure
plot(imu(:,1),imu(:,2:4),'linewidth',2)
legend('accx','accy','accz')
grid on
title('Accelerometers')
xlabel('GPST(s)')
ylabel('g')
end

