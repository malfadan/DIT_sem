function [GateMean1, GateMean2, GateStd1, GateStd2, Gatepeak_count1, Gatepeak_count2] = GateFeatures(signal1, signal2, timestamps, Fs)
% Remove potential peak
signal1(1) = signal1(2);
signal2(1) = signal2(2);

signal_diff = signal2 - signal1;
% Centering
signal_diff = signal_diff - mean(signal_diff);

% Find peaks in the signal, NUMBER OF PEAKS COULD INDICATE ERROR
[peaks1, peak_locations1] = findpeaks(signal_diff,'MinPeakHeight', 2.5, 'MinPeakDistance', Fs/3);    % should be tweaked using the max speed of the belt
[peaks2, peak_locations2] = findpeaks(-signal_diff,'MinPeakHeight', 2.5, 'MinPeakDistance', Fs/3);    % should be tweaked using the max speed of the belt
[peaks3, peak_locations3] = findpeaks(abs(signal_diff),'MinPeakHeight', 2.5, 'MinPeakDistance', Fs/2);


peak_time_diff = diff(timestamps(peak_locations3));
peak_time_diff_1 = diff(timestamps(peak_locations1));
peak_time_diff_2 = diff(timestamps(peak_locations2));

% Create logical indices for odd and even indices
odd_indices = mod(1:length(peak_time_diff), 2) == 1;
even_indices = mod(1:length(peak_time_diff), 2) == 0;

% Separate time differences based on odd and even indices
odd_time_diff = peak_time_diff(odd_indices);
even_time_diff = peak_time_diff(even_indices);

% Calculate averages for odd and even indices
average_speed_odd = mean(odd_time_diff);
average_speed_even = mean(even_time_diff);

% Calculate the standard deviation for odd and even indices
std_deviation_odd = std(peak_time_diff_1);
std_deviation_even = std(peak_time_diff_2);

if length(peak_locations2) > 0 && length(peak_locations1) > 0
    if timestamps(peak_locations1(1)) < timestamps(peak_locations2(1))
        average_speed_Plus = average_speed_even;
        std_deviation_Plus = std_deviation_even;
        average_speed_Minus = average_speed_odd;
        std_deviation_Minus = std_deviation_odd;
    elseif timestamps(peak_locations1(1)) > timestamps(peak_locations2(1))
        average_speed_Plus = average_speed_odd;
        std_deviation_Plus = std_deviation_odd;
        average_speed_Minus = average_speed_even;
        std_deviation_Minus = std_deviation_even;
    else
        average_speed_Plus = NaN;
        average_speed_Minus = NaN;
        std_deviation_Plus = NaN;
        std_deviation_Minus = NaN;
    end
else
    average_speed_Plus = NaN;
    average_speed_Minus = NaN;
    std_deviation_Plus = NaN;
    std_deviation_Minus = NaN;
end

% Calculate averages for odd and even indices
GateMean1 = average_speed_Plus;
GateMean2 = average_speed_Minus;

% Calculate the standard deviation for odd and even indices
GateStd1 = std_deviation_Plus;
GateStd2 = std_deviation_Minus;
Gatepeak_count1 = length(peaks1);
Gatepeak_count2 = length(peaks2);

end