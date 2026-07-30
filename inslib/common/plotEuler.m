function plotEuler(euler,ref,time)
ref_euler=eulerENU2NED(ref.euler);
figure
for i=1:3
subplot(3,1,i)
plot(time,euler(i,:),DisplayName='Solution')
hold on
plot(ref.time,ref_euler(:,i),DisplayName='ground-truth')
legend
end
subtitle('Euler angles (NED frame)')
end

