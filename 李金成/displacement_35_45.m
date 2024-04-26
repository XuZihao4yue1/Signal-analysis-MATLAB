%% 
% 文件路径
filename = 'points_displacement_nonredundant_35-45.txt';

% 读取数据
data = readmatrix(filename);

% 分别提取时间数据和位移数据
time_microseconds = data(:,1);  % 假设时间数据在第一列
displacement_mm = data(:,2);    % 假设位移数据在第二列

% 将时间转换为秒
time_seconds = time_microseconds * 1e-6;

% 筛选40秒到45秒之间的数据
indices = time_seconds >= 35 & time_seconds <= 45;
time_filtered = time_seconds(indices);
displacement_filtered = displacement_mm(indices);

% 绘制波形图
figure;
plot(time_filtered, displacement_filtered);
xlabel('时间 (秒)');
ylabel('位移 (毫米)');
title('35秒到45秒位移随时间的波形图');
grid on;
%% 
[frequency, amplitude] = estimate_frequency(time_microseconds, displacement_mm);


%% 


