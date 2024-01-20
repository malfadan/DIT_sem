% Create a session
s = daq.createSession('ni');

% Add analog input channels (adjust the device ID, channel numbers, and settings)
deviceID = 'Dev1'; % Adjust based on your specific setup
channelsOfInterest = [0:15]; % Specify the channels you're interested in

addAnalogInputChannel(s, deviceID, channelsOfInterest, 'Voltage');

% Set acquisition parameters (duration, sample rate, etc.)
s.Rate = 5000; % Adjust based on your specific requirements, but change it for classification code too
s.DurationInSeconds = 30;

% Start the acquisition
[data, timestamps] = startForeground(s);

%{
% Plot the acquired data for each channel
figure;
for i = 1:length(channelsOfInterest/3)
    subplot(length(channelsOfInterest), 1, i);
    plot(timestamps, data(:, i));
    title(['Channel ', num2str(channelsOfInterest(i)), ', Sample Rate: ', num2str(s.Rate), ' Hz']);
    xlabel('Time (s)');
    ylabel('Voltage');
end
%}


% Save the data to a file
save('correct_after_motor.mat', 'data', 'timestamps', 'channelsOfInterest', 's');