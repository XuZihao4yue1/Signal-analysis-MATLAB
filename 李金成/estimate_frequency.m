function [frequency, amplitude] = estimate_frequency(time_seconds, signal)
    % 计算采样间隔
    dt = mean(diff(time_seconds));
    
    % 计算采样频率
    Fs = 1/dt;
    
    % 对信号进行FFT
    Y = fft(signal);
    
    % 计算双侧频谱
    P2 = abs(Y/length(signal));
    
    % 计算单侧频谱
    P1 = P2(1:floor(length(signal)/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
    % 创建频率向量
    f = Fs*(0:(length(signal)/2))/length(signal);
    
    % 找到对应于最大振幅的频率
    [amplitude, idx] = max(P1);
    frequency = f(idx);
end
