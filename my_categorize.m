clear all;
clc;
warning off


% List of folder names
folderNames = {'belt_holding', 'correct', 'light_disconnected', 'motor', 'object', 'tacho', 'sensors', 'speed_diff'};
filePath = 'correct/correct_1';

Fs = 5000;
load(filePath);

gate1 = MyfiltBin(data(:, 1));
gate2 = MyfiltBin(data(:, 2));
motor1 = MyfiltBin(data(:, 3));
tacho = MyfiltBin(data(:, 4));
motor2 = MyfiltBin(data(:, 5));
reference = MyfiltBin(data(:, 6));

[GateMean1, GateMean2, GateStd1, GateStd2, Gatepeak_count1, Gatepeak_count2]  = GateFeatures(gate1, gate2, timestamps, Fs);
[Power1, Power2, MotorSpeed1, MotorSpeed2, DutyDiff, NumTransitions, indicesMismatch] = MotorFeatures(motor1, motor2);
[TachoSpeed1, TachoSpeed2, Prop1, Prop2] = TachoFeatures(tacho, reference);

Gate1Available = 1;
Gate2Available = 1;
if isnan(GateMean1)
    disp('Features from gate 1 unavailable, check that all components are connected, in place and that there is enough speed.')
    Gate1Available = 0;
end

if isnan(GateMean2)
    disp('Features from gate 2 unavailable, check that all components are connected, in place and that there is enough speed..')
    Gate2Available = 0;
end

MotorAvailable = 1;
MotorSpeed1Available = 0;
MotorSpeed2Available = 0;
if indicesMismatch >= 1000
    disp('Motor signals dont match, check if its connected properly.')
    MotorAvailable = 0;
else
    MotorSpeed1Available = 1;
    MotorSpeed2Available = 1;
    if isnan(MotorSpeed1)
        disp('Speed feature in direction 1 could not be calculated, check that everything is connected correctly.')
        MotorSpeed1Available = 0;
    end
    
    if isnan(MotorSpeed2)
        disp('Speed feature in direction 2 could not be calculated, check that everything is connected correctly.')
        MotorSpeed2Available = 0;
    end
end

TachoAvailable = 1;
TachoSpeed1Available = 0;
TachoSpeed2Available = 0;
std_thresh1 = 0.1;
if (std(tacho - reference) < std_thresh1)
    disp('Tacho sensor or motor are most likely disconnected.')
    TachoAvailable = 0;
else
    TachoSpeed1Available = 1;
    TachoSpeed2Available = 1;
    if isnan(TachoSpeed1) || TachoSpeed1 == 0
        disp('Tacho Speed feature in direction 1 could not be calculated, check that everything is connected correctly.')
        TachoSpeed1Available = 0;
    end
    
    if isnan(TachoSpeed2) || TachoSpeed2 == 0
        disp('Tacho Speed feature in direction 2 could not be calculated, check that everything is connected correctly.')
        TachoSpeed2Available = 0;
    end
end

if MotorAvailable
    if Gate1Available && Gate2Available
        if TachoAvailable
            disp('Performing FullAnalysis')
            performFullAnalysis(MotorSpeed1, MotorSpeed2, NumTransitions, TachoSpeed1, TachoSpeed2, GateMean1, GateMean2, Gatepeak_count1, Gatepeak_count2);
        else
            disp('Performing GateMotorAnalysis')
            performGateMotorAnalysis(MotorSpeed1, MotorSpeed2, NumTransitions, GateMean1, GateMean2, Gatepeak_count1, Gatepeak_count2);
            disp('System is in a FAULTY state.')
        end
    elseif TachoAvailable
        disp('Performing TachoMotorAnalysis')
        performTachoMotorAnalysis(MotorSpeed1, MotorSpeed2, TachoSpeed1, TachoSpeed2);
        disp('System is in a FAULTY state.')
    else
        disp('Motor is disconnected mechanically or Gates are not working. Check both components')
        disp('System is in a FAULTY state.')
    end
else
    disp('Motor features unavailable. Make sure it is connected well for thorough fault analysis.')
    disp('System is in a FAULTY state.')
end


warning on