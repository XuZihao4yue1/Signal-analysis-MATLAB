% 文件路径
filename = 'points_displacement_nonredundant_35-45.txt';

% 读取数据
data = readmatrix(filename);
time_microseconds = data(:,1); % 时间数据（微秒）
signal = data(:,2);            % 振动信号数据

% 将时间从微秒转换为秒
time_seconds = time_microseconds * 1e-6;

% 计算采样频率
Fs = 1 / mean(diff(time_seconds)); % 采样频率 (Hz)

% 设计低通滤波器去噪
fc = 100;  % 截止频率100 Hz
[b, a] = butter(3, fc/(Fs/2), 'low'); % 3阶巴特沃斯低通滤波器
filtered_signal = filter(b, a, signal); % 应用滤波器

% 计算FFT
Y = fft(filtered_signal);
L = length(filtered_signal); % 信号长度
P2 = abs(Y/L);
P1 = P2(1:floor(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1);

% 创建频率向量
frequencies = Fs*(0:(L/2))/L;

% 寻找最大振幅和主频率
[maxAmplitude, idx] = max(P1);
mainFrequency = frequencies(idx);

% 显示结果
disp(['Sampling Frequency: ', num2str(Fs), ' Hz']);
disp(['Maximum Amplitude: ', num2str(maxAmplitude)]);
disp(['Main Frequency: ', num2str(mainFrequency), ' Hz']);

% 绘图
figure;
subplot(2,1,1);
plot(time_seconds, filtered_signal);
title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(frequencies, P1);
title('Amplitude Spectrum');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
