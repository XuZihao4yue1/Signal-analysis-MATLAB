% 假设变量displacement_mm包含位移数据
% 假设变量time_seconds包含时间数据，用于确定采样频率

% 计算采样频率
Fs = 1 / mean(diff(time_seconds));  % 假设时间数据是均匀采样的

% 计算FFT
N = length(displacement_mm);        % 位移数据点的数量
fft_result = fft(displacement_mm);  % 对位移数据进行FFT

% 计算双边幅值频谱，并转换为单边
fft_amplitude = abs(fft_result / N);
single_side_amplitude = fft_amplitude(1:N/2+1);
single_side_amplitude(2:end-1) = 2*single_side_amplitude(2:end-1);

% 计算平均幅值
average_amplitude = mean(single_side_amplitude);

% 频率向量
f = Fs*(0:(N/2))/N;

% 寻找主频率
[max_amplitude, index] = max(single_side_amplitude);
main_frequency = f(index);

% 输出结果
fprintf('平均幅值: %f\n', average_amplitude);
fprintf('主频率: %f Hz\n', main_frequency);
