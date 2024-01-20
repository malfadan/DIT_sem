function [] = performGateMotorAnalysis(MotorSpeed1, MotorSpeed2, NumTransitions, GateMean1, GateMean2, Gatepeak_count1, Gatepeak_count2)

    % Define linguistic variables and membership functions for gate features
    LowGateMean1 = trimf(GateMean1, [0, 0, 3.5]);
    MediumGateMean1 = trapmf(GateMean1, [3.4, 3.5, 4.4, 4.5]);
    HighGateMean1 = trapmf(GateMean1, [4.4, 4.7, 100, 1000]);

    % Define linguistic variables and membership functions for motor speed
    LowMotorSpeed1 = trapmf(MotorSpeed1, [0, 0, 38, 41]);
    MediumMotorSpeed1 = trapmf(MotorSpeed1, [40, 42, 44, 46]);
    HighMotorSpeed1 = trapmf(MotorSpeed1, [45, 47, 200, 200]);
    
    % Define linguistic variables and membership functions for gate features
    LowGateMean2 = trimf(GateMean2, [0, 0, 3.5]);
    MediumGateMean2 = trapmf(GateMean2, [3.4, 3.5, 4.4, 4.5]);
    HighGateMean2 = trapmf(GateMean2, [4.4, 4.7, 100, 1000]);

    % Define linguistic variables and membership functions for motor speed
    LowMotorSpeed2 = trapmf(MotorSpeed2, [0, 0, 38, 41]);
    MediumMotorSpeed2 = trapmf(MotorSpeed2, [40, 42, 44, 46]);
    HighMotorSpeed2 = trapmf(MotorSpeed2,  [45, 47, 200, 200]);

    % Determine the dominant class for each reading
    [Mean1Certainty, Mean1Class] = max([LowGateMean1, MediumGateMean1, HighGateMean1]);
    [Speed1Certainty, Speed1Class] = max([LowMotorSpeed1, MediumMotorSpeed1, HighMotorSpeed1]);
    [Mean2Certainty, Mean2Class] = max([LowGateMean2, MediumGateMean2, HighGateMean2]);
    [Speed2Certainty, Speed2Class] = max([LowMotorSpeed2, MediumMotorSpeed2, HighMotorSpeed2]);


    % Fuzzy rules
    Rule1 = (Mean1Class == 2 && Speed1Class == 2); % Both speeds 1 ok
    Rule2 = (Mean1Class == 1 && Speed1Class == 3); % Both speeds 1 high
    Rule3 = (Mean1Class == 3 && Speed1Class == 1); % Both speeds 1 low

    Rule4 = (Mean2Class == 2 && Speed2Class == 2); % Both speeds 2 ok
    Rule5 = (Mean2Class == 1 && Speed2Class == 3); % Both speeds 2 high
    Rule6 = (Mean2Class == 3 && Speed2Class == 1); % Both speeds 2 low
    
    if ~(Rule1 || Rule2 || Rule3)   % readings in dir 1 don't match
        disp('Measurements in dir 1 dont match . Check that object on belt is regular.');
        OverallCertainty = Mean1Certainty * Speed1Certainty;
        disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
    else
        OverallCertainty = Mean1Certainty * Speed1Certainty;
        switch Speed1Class
            case 1
                disp('Speed in direction 1 is LOW.');
                disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
            case 2
                disp('Speed in direction 1 is OK.');
                disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
            case 3
                disp('Speed in direction 1 is HIGH.');
                disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
        end

    end

    if ~(Rule4 || Rule5 || Rule6)   % readings in dir 2 don't match
        disp('Measurements in dir 2 dont match . Check that object on belt is regular.');
        OverallCertainty = Mean2Certainty * Speed2Certainty;
        disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
    else
        OverallCertainty = Mean2Certainty * Speed2Certainty;
        switch Speed2Class
            case 1
                disp('Speed in direction 2 is LOW.');
                disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
            case 2
                disp('Speed in direction 2 is OK.');
                disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
            case 3
                disp('Speed in direction 2 is HIGH.');
                disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
        end
    end

end