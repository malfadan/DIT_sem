function [Power1, Power2, Speed1, Speed2, DutyDiff, NumTransitions, indicesMismatch] = MotorFeatures(signal1, signal2)
% Remove potential peak
signal1(1) = signal1(2);
signal2(1) = signal2(2);

dir_signal1 = sign(signal1);
dir_signal2 = sign(signal2);
indicesMismatch = sum(dir_signal2 ~= -dir_signal1);

% Use the 'diff' function to find differences between consecutive elements
differences = diff((dir_signal2 + 1)/2);
% Count the number of transitions (edges)
NumTransitions = sum(abs(differences));

% Get the number of indices where signals don't coincide
indicesWherePlus = find(dir_signal2 == 1);
indicesWhereMinus = find(dir_signal2 == -1);

Power1 = sum(abs(signal2(indicesWherePlus)).^2);
Power2 = sum(abs(signal2(indicesWhereMinus)).^2);

Speed1 = Power1 / length(indicesWherePlus);
Speed2 = Power2 / length(indicesWhereMinus);

DutyCycle1 = sum(dir_signal2 == 1) / numel(dir_signal2);
DutyCycle2 = sum(dir_signal2 == -1) / numel(dir_signal2);
DutyDiff = abs(DutyCycle2 - DutyCycle1);
end