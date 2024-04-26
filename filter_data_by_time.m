function filter_data_by_time(input_filename, output_filename, time_lower_bound, time_upper_bound)
    % 读取数据
    data = readmatrix(input_filename);
    
    % 第一列是时间，单位微秒，转换为秒
    time_seconds = data(:,1) * 1e-6;

    % 筛选指定时间范围内的数据
    indices = time_seconds >= time_lower_bound & time_seconds <= time_upper_bound;
    filtered_data = data(indices, :);

    % 将筛选后的数据写入新的txt文件
    writematrix(filtered_data, output_filename);
end
