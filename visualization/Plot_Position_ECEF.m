function Plot_Position_ECEF(pe, gnss, ref)
% PLOT_POSITION_ECEF Plots 3D trajectory, GNSS measurements, and ground truth in ECEF frame.
figure;
plot3(ref.pe(:, 1), ref.pe(:, 2), ref.pe(:, 3), '.', 'LineWidth', 2, 'DisplayName', 'Ground Truth');
hold on;
plot3(pe(1, :), pe(2, :), pe(3, :), '.', 'LineWidth', 2, 'DisplayName', 'Solution');
plot3(gnss(1, :), gnss(2, :), gnss(3, :), 'or', 'LineWidth', 2, 'DisplayName', 'GNSS');
grid on;
title('Position in ECEF frame');
legend;
xlabel('x');
ylabel('y');
zlabel('z');
end
