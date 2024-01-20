function [TachoSpeed1, TachoSpeed2, Prop1, Prop2] = TachoFeatures(signal1, signal2)
% Remove potential peak
signal1(1) = signal1(2);
signal2(1) = signal2(2);

Fs = 5000;
dir_signal = sign(signal2 + 3);   % constant offset present

upper_tresh = 3;
lower_thresh = -3;

% Create a binary signal based on the conditions
binarySignal = zeros(size(signal1));
% Above zero and below upper threshold set to zero
binarySignal(signal1 > 0 & signal1 <= upper_tresh) = 0;

% Above zero and above upper threshold set to one
binarySignal(signal1 > 0 & signal1 > upper_tresh) = 1;

% Below zero and above lower threshold set to zero
binarySignal(signal1 < 0 & signal1 >= lower_thresh) = 0;

% Below zero and below lower threshold set to minus one
binarySignal(signal1 < 0 & signal1 < lower_thresh) = -1;

TachoSpeed1 = sum(diff(binarySignal > 0) ~= 0) / (sum(dir_signal > 0)/Fs);
TachoSpeed2 = sum(diff(binarySignal < 0) ~= 0) / (sum(dir_signal < 0)/Fs);

if isnan(TachoSpeed1)
    TachoSpeed1 = 0;
end

if isnan(TachoSpeed2)
    TachoSpeed2 = 0;
end

Prop1 = sum(binarySignal == 1) / sum(dir_signal == 1);
Prop2 = sum(binarySignal == -1) / sum(dir_signal == -1);
end