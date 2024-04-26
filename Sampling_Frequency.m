% 文件路径
filename = 'points_displacement_nonredundant_35-45.txt';



% 读取数据文件的第一列（假设时间戳在第一列）
time_microseconds = readmatrix(filename, 'Range', 'A:A');

% 将时间从微秒转换为秒
time_seconds = time_microseconds * 1e-6;

% 计算相邻时间戳之间的差异
time_differences = diff(time_seconds);

% 计算平均采样间隔（秒）
mean_sampling_interval = mean(time_differences);

% 计算采样频率（Hz）
sampling_frequency = 1 / mean_sampling_interval;

% 显示采样频率
disp(['Sampling Frequency: ', num2str(sampling_frequency), ' Hz']);

% 示例信号参数
Fs = sampling_frequency;           % 采样频率 (Hz)
T = 1/Fs;            % 采样周期 (s)
L = 25832;            % 信号长度
t = (0:L-1)*T;       % 时间向量


% 计算FFT
Y = fft(signal);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
frequencies = Fs*(0:(L/2))/L;

% 找到最大振幅和对应的频率
[maxAmplitude, idx] = max(P1);
mainFrequency = frequencies(idx);

% 显示结果
disp(['Maximum Amplitude: ', num2str(maxAmplitude)]);
disp(['Main Frequency: ', num2str(mainFrequency), ' Hz']);

% 可选：绘制信号和其频谱
figure;
subplot(2,1,1);
plot(t, signal);
title('Time Domain Signal');
xlabel('Time (seconds)');
ylabel('Amplitude');

subplot(2,1,2);
plot(frequencies, P1);
title('Single-Sided Amplitude Spectrum of Signal');
xlabel('Frequency (Hz)');
ylabel('|P1(f)|');
