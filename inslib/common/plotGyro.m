function plotGyro(imu)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
figure
plot(imu(:,1),imu(:,5:7))
grid on
legend('gx','gy','gz')
end

