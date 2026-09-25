function Plot_Euler_Angles(euler, ref, time)
% PLOT_EULER_ANGLES Plots estimated Euler angles vs ground-truth reference in NED frame.
ref_euler = Euler_ENU_To_NED(ref.euler);
figure;
for i = 1:3
    subplot(3, 1, i);
    plot(time, euler(i, :), 'DisplayName', 'Solution');
    hold on;
    plot(ref.time, ref_euler(:, i), 'DisplayName', 'ground-truth');
    legend;
end
subtitle('Euler angles (NED frame)');
end
