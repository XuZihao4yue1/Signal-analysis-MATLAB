% 文件路径
filename = 'points_displacement_nonredundant_35-45.txt';

% 读取数据
data = readmatrix(filename);

% 分别提取时间数据和位移数据
time_microseconds = data(:,1);  % 假设时间数据在第一列
displacement_mm = data(:,2);    % 假设位移数据在第二列

% 将时间转换为秒
time_seconds = time_microseconds * 1e-6;



% 假设已经有了time_seconds和displacement_mm数据
% 以下是对这些数据进行筛选并绘制图形的优化代码

% 筛选指定时间段内的数据
start_time = 40; % 开始时间（秒）
end_time = 45; % 结束时间（秒）
indices = (time_seconds >= start_time) & (time_seconds <= end_time);
time_filtered = time_seconds(indices);
displacement_filtered = displacement_mm(indices);

% 创建高分辨率的图形
figure('Units', 'pixels', 'Position', [100, 100, 800, 600]);

% 绘制波形图，使用 '.' 可以显示数据点
plot(time_filtered, displacement_filtered, '.', 'MarkerSize', 10);

% 图形美化
xlabel('时间 (秒)', 'FontSize', 12);
ylabel('位移 (毫米)', 'FontSize', 12);
title('40至45秒位移随时间的波形图', 'FontSize', 14);
grid on; % 添加网格

% 设置坐标轴的范围和刻度
xlim([start_time end_time]);
ylim([min(displacement_filtered) max(displacement_filtered)]);
xticks(start_time:1:end_time); % 每秒一个刻度
yticks(min(displacement_filtered):1:max(displacement_filtered)); % 根据位移范围设置刻度

% 提升图形质量
set(gca, 'FontSize', 12); % 改变坐标轴的字体大小
box on; % 给图形加上边框

% 导出高质量图形
set(gcf, 'PaperPositionMode', 'auto');
print('-dpng', '-r300', 'optimized_plot.png'); % 保存为PNG格式，300 dpi分辨率
