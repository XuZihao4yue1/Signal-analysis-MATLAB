function [peak_amplitude, main_frequency] = analyze_vibration(time_seconds, signal_data, fc)



    % 计算采样频率
    Fs = 1/mean(diff(time_seconds));

    % 设计低通滤波器
    [b, a] = butter(3, fc/(Fs/2), 'low');

    % 应用滤波器
    filtered_signal = filter(b, a, signal_data);

    % 计算振幅
    peak_amplitude = max(abs(filtered_signal));

    % FFT
    Y = fft(filtered_signal);
    L = length(filtered_signal);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    % 频率轴
    f = Fs*(0:(L/2))/L;

    % 寻找主频率
    [~, loc] = max(P1);
    main_frequency = f(loc);

    % 返回结果
    return
end
