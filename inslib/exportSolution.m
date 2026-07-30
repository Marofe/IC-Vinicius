function exportSolution(fileName,time,hx)
fid = fopen(fileName,'wt');
data = [time hx(:,16) hx(:,17) hx(:,18) hx(:,7:9) hx(:,1:3)];
format='%.3f\t %.10f\t\t %.10f\t\t %.3f\t %.5f\t %.5f\t %.5f\t %.5f\t %.5f\t %.5f\n';
fprintf(fid,'%% GPST (s)\t lat (deg)\t\t lon (deg)\t\t alt (m)\t vn (m/s)\t ve (m/s)\t vu (m/s)\t roll (deg)\t pitch (deg)\t heading (deg)\n');
fprintf(fid,format,data');
fclose(fid);
end