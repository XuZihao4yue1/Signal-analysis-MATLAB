% 文件路径
filename = 'points_displacement_nonredundant.txt'; % 替换成你的文件名

% 读取数据
data = readmatrix(filename);

% 第一列是时间，单位微秒，转换为秒
time_seconds = data(:,1) * 1e-6;

% 筛选35秒到45秒之间的数据
indices = time_seconds >= 35 & time_seconds <= 45;
filtered_data = data(indices, :);

% 创建新的文件名
new_filename = 'points_displacement_nonredundant_35-45.txt'; % 你可以修改这个新文件的名字

% 将筛选后的数据写入新的txt文件
writematrix(filtered_data, new_filename);
%% 



