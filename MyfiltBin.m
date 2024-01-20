function [OutSignal] = MyfiltBin(Signal)

% Design a low-pass filter
cutoff_frequency = 500; % Adjust based on your signal characteristics
filter_order = 15; % Adjust based on your requirements
low_pass_filter = designfilt('lowpassfir', 'FilterOrder', filter_order, 'CutoffFrequency', cutoff_frequency, 'SampleRate', 5000);

% Specify the window size for the median filter
window_size = 200;  % Adjust based on your signal characteristics

filtered1 = filtfilt(low_pass_filter, Signal);

filtered2 = medfilt1(filtered1, window_size);

OutSignal = filtered2;
end