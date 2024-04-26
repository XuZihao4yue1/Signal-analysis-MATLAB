% 文件路径
filename = 'points_displacement_nonredundant_35-45.txt';

% 读取数据
data = readmatrix(filename);
time_microseconds = data(:,1); % 时间数据（微秒）
displacement = data(:,2);            % 振动信号数据

% 将时间从微秒转换为秒
time_seconds = time_microseconds * 1e-6;

% 计算采样频率
Fs = 1 / mean(diff(time_seconds)); % 采样频率 (Hz)

% 去除直流偏置
displacement = displacement - mean(displacement);

% 设计低通滤波器去噪
fc = 100;  % 截止频率100 Hz
[b, a] = butter(3, fc/(Fs/2), 'low'); % 3阶巴特沃斯低通滤波器
filtered_displacement = filter(b, a, displacement); % 应用滤波器

% 计算FFT
Y = fft(filtered_displacement);
L = length(filtered_displacement); % 信号长度
P2 = abs(Y/L);
P1 = P2(1:floor(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1);

% 创建频率向量
frequencies = Fs*(0:(L/2))/L;

% 寻找最大振幅和主频率，忽略0 Hz
[maxAmplitude, idx] = max(P1(2:end));
mainFrequency = frequencies(idx+1); % +1 修正因忽略0 Hz而导致的索引偏移

% 显示结果
disp(['Sampling Frequency: ', num2str(Fs), ' Hz']);
disp(['Maximum Amplitude: ', num2str(maxAmplitude)]);
disp(['Main Frequency: ', num2str(mainFrequency), ' Hz']);


% 绘图前询问用户纵坐标范围
y_min = -2.00;
y_max = 2.00;

% 绘图

figure;
subplot(3,1,1);
plot(filtered_displacement);
title('oringin displacement');
xlabel('s');
ylabel('Amplitude');

ylim([y_min, y_max]); % 设置用户指定的纵坐标范围

subplot(3,1,2);
plot(filtered_displacement(1:2586));
title('Filtered displacement');
xlabel('Hz');
ylabel('Amplitude');

ylim([y_min, y_max]); % 设置用户指定的纵坐标范围
grid on;



subplot(3,1,3);
plot(frequencies, P1);
title('Amplitude Spectrum');
xlabel('Frequency (Hz)');
ylabel('Amplitude');


%% 

% 使用findpeaks寻找峰值
[peakValues, peakLocs] = findpeaks(filtered_displacement, 'MinPeakDistance', 0.01);
% 使用findpeaks找到谷值，信号取负
[troughValues, troughLocs] = findpeaks(-filtered_displacement, 'MinPeakDistance', 0.01);
troughValues = -troughValues; % 转换回原来的谷值

% 初始化数组以存储位移和时间差
peakToTroughDisplacements = [];
troughToPeakDisplacements = [];
peakToTroughTimes = [];
troughToPeakTimes = [];

% 确保开始的第一个是峰值
if peakLocs(1) > troughLocs(1)
    troughLocs(1) = [];
    troughValues(1) = [];
end
if peakLocs(end) < troughLocs(end)
    troughLocs(end) = [];
    troughValues(end) = [];
end

% 循环计算每一个谷值到下一个峰值的时间和位移差
for i = 1:min(length(peakLocs), length(troughLocs))
    if troughLocs(i) < peakLocs(i)
        troughToPeakDisplacements(end+1) = abs(peakValues(i) - troughValues(i));
        troughToPeakTimes(end+1) = time_seconds(peakLocs(i)) - time_seconds(troughLocs(i));
    end
end

% 循环计算每一个峰值到下一个谷值的时间和位移差
for i = 1:min(length(peakLocs) - 1, length(troughLocs))
    peakToTroughDisplacements(end+1) = abs(troughValues(i) - peakValues(i));
    peakToTroughTimes(end+1) = time_seconds(troughLocs(i)) - time_seconds(peakLocs(i));
end

% 计算平均位移和时间
avgDisplacementPeakToTrough = mean(peakToTroughDisplacements);
avgTimePeakToTrough = mean(peakToTroughTimes);
avgDisplacementTroughToPeak = mean(troughToPeakDisplacements);
avgTimeTroughToPeak = mean(troughToPeakTimes);

% 计算速度
avgSpeedPeakToTrough = avgDisplacementPeakToTrough / avgTimePeakToTrough;
avgSpeedTroughToPeak = avgDisplacementTroughToPeak / avgTimeTroughToPeak;

% 输出结果
fprintf('Average displacement from peaks to troughs: %.4f mm\n', avgDisplacementPeakToTrough);
fprintf('Average time from peaks to troughs: %.4f seconds\n', avgTimePeakToTrough);
fprintf('Average speed from peaks to troughs: %.4f mm/s\n', avgSpeedPeakToTrough);
fprintf('Average displacement from troughs to peaks: %.4f mm\n', avgDisplacementTroughToPeak);
fprintf('Average time from troughs to peaks: %.4f seconds\n', avgTimeTroughToPeak);
fprintf('Average speed from troughs to peaks: %.4f mm/s\n', avgSpeedTroughToPeak);
%% 这个是我修改好的程序，可以比较准确的完成对速度的求解，需要改的参数为
%findpeaks 0.08*Fs是限制相邻两个峰之间的时间 
% 寻找峰值和谷值
[peakValues, peakLocs] = findpeaks(filtered_displacement(1:2586), 'MinPeakDistance', 0.08*Fs);
[troughValues, troughLocs] = findpeaks(-filtered_displacement(1:2586), 'MinPeakDistance', 0.08*Fs);
troughValues = -troughValues; % 转换谷值为正值

% 初始化速度，位移和时间数组
peakToTroughSpeeds = [];
troughToPeakSpeeds = [];
peakToTroughDisplacements = [];
troughToPeakDisplacements = [];
peakToTroughTimes = [];
troughToPeakTimes = [];

% 确保以一个峰值开始和结束
if peakLocs(1) > troughLocs(1)
    troughLocs(1) = [];
    troughValues(1) = [];
end
if peakLocs(end) < troughLocs(end)
    troughLocs(end) = [];
    troughValues(end) = [];
end

% 计算峰到谷和谷到峰的位移，时间和速度
for i = 1:length(troughLocs)
    if i < length(peakLocs)
        peakToTroughDisplacements(end+1) = abs(peakValues(i) - troughValues(i));
        peakToTroughTimes(end+1) = (troughLocs(i) - peakLocs(i))/Fs;
        peakToTroughSpeeds(end+1) = peakToTroughDisplacements(end) / peakToTroughTimes(end);
    end
    if i > 1
        troughToPeakDisplacements(end+1) = abs(troughValues(i-1) - peakValues(i));
        troughToPeakTimes(end+1) = ((peakLocs(i)) - (troughLocs(i-1)))/Fs;
        troughToPeakSpeeds(end+1) = troughToPeakDisplacements(end) / troughToPeakTimes(end);
    end
end

% 计算平均位移和时间
avgDisplacementPeakToTrough = mean(peakToTroughDisplacements);
avgDisplacementTroughToPeak = mean(troughToPeakDisplacements);
avgTimePeakToTrough = mean(peakToTroughTimes);
avgTimeTroughToPeak = mean(troughToPeakTimes);

% 计算平均速度
avgSpeedPeakToTrough = mean(peakToTroughSpeeds);
avgSpeedTroughToPeak = mean(troughToPeakSpeeds);

% 输出结果
fprintf('Average displacement from peaks to troughs: %.4f mm\n', avgDisplacementPeakToTrough);
fprintf('Average time from peaks to troughs: %.4f seconds\n', avgTimePeakToTrough);
fprintf('Average speed from peaks to troughs: %.4f mm/s\n', avgSpeedPeakToTrough);
fprintf('Average displacement from troughs to peaks: %.4f mm\n', avgDisplacementTroughToPeak);
fprintf('Average time from troughs to peaks: %.4f seconds\n', avgTimeTroughToPeak);
fprintf('Average speed from troughs to peaks: %.4f mm/s\n', avgSpeedTroughToPeak);