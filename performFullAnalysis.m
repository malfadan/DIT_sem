function [] = performFullAnalysis(MotorSpeed1, MotorSpeed2, NumTransitions, TachoSpeed1, TachoSpeed2, GateMean1, GateMean2, Gatepeak_count1, Gatepeak_count2)

    healthy1 = 0;
    healthy2 = 0;
    % Define linguistic variables and membership functions for gate features
    LowGateMean1 = trimf(GateMean1, [0, 0, 3.5]);
    MediumGateMean1 = trapmf(GateMean1, [3.4, 3.5, 4.4, 4.5]);
    HighGateMean1 = trapmf(GateMean1, [4.4, 4.7, 100, 1000]);

    % Define linguistic variables and membership functions for motor speed
    LowMotorSpeed1 = trapmf(MotorSpeed1, [0, 0, 38, 41]);
    MediumMotorSpeed1 = trapmf(MotorSpeed1, [40, 42, 44, 46]);
    HighMotorSpeed1 = trapmf(MotorSpeed1, [45, 47, 200, 200]);

    % Define linguistic variables and membership functions for tacho speed
    LowTacho1 = trimf(TachoSpeed1, [0, 0, 5,5]);
    MediumTacho1 = trimf(TachoSpeed1, [5, 6, 7.5]);
    HighTacho1 = trimf(TachoSpeed1, [7, 25, 100000]);

    % Define linguistic variables and membership functions for gate features
    LowGateMean2 = trimf(GateMean2, [0, 0, 3.5]);
    MediumGateMean2 = trapmf(GateMean2, [3.4, 3.5, 4.4, 4.5]);
    HighGateMean2 = trapmf(GateMean2, [4.4, 4.7, 100, 1000]);

    % Define linguistic variables and membership functions for motor speed
    LowMotorSpeed2 = trapmf(MotorSpeed2, [0, 0, 38, 41]);
    MediumMotorSpeed2 = trapmf(MotorSpeed2, [40, 42, 44, 46]);
    HighMotorSpeed2 = trapmf(MotorSpeed2,  [45, 47, 200, 200]);

     % Define linguistic variables and membership functions for tacho speed
    LowTacho2 = trimf(TachoSpeed2, [0, 0, 5,5]);
    MediumTacho2 = trimf(TachoSpeed2, [5, 6, 7.5]);
    HighTacho2 = trimf(TachoSpeed2, [7, 25, 100000]);

    % Determine the dominant class for each reading
    [Mean1Certainty, Mean1Class] = max([LowGateMean1, MediumGateMean1, HighGateMean1]);
    [Speed1Certainty, Speed1Class] = max([LowMotorSpeed1, MediumMotorSpeed1, HighMotorSpeed1]);
    [Tacho1Certainty, Tacho1Class] = max([LowTacho1, MediumTacho1, HighTacho1]);
    [Mean2Certainty, Mean2Class] = max([LowGateMean2, MediumGateMean2, HighGateMean2]);
    [Speed2Certainty, Speed2Class] = max([LowMotorSpeed2, MediumMotorSpeed2, HighMotorSpeed2]);
    [Tacho2Certainty, Tacho2Class] = max([LowTacho2, MediumTacho2, HighTacho2]);

    % TRIPLET CONSENSUS
    Speed1ConsensusRule1 = (Mean1Class == 2 && Speed1Class == 2 && Tacho1Class == 2);     % all OK for speed 1
    Speed1ConsensusRule2 = (Mean1Class == 1 && Speed1Class == 3 && Tacho1Class == 3);     % all high for speed 1
    Speed1ConsensusRule3 = (Mean1Class == 3 && Speed1Class == 1 && Tacho1Class == 1);     % all low for speed 1

    if ~(Speed1ConsensusRule1 || Speed1ConsensusRule2 || Speed1ConsensusRule3)  % speed readings for dir 1 don't match
        % Pair rules
        Speed1Rule1 = (Mean1Class == 2 && Speed1Class == 2); % Both speeds ok
        Speed1Rule2 = (Mean1Class == 1 && Speed1Class == 3); % Both speeds 1 high
        Speed1Rule3 = (Mean1Class == 3 && Speed1Class == 1); % Both speeds 1 low

        Speed1Rule4 = (Tacho1Class == 2 && Speed1Class == 2);     % Both speeds ok
        Speed1Rule5 = (Tacho1Class == 3 && Speed1Class == 3);    % Speed 1 abnormally high 
        Speed1Rule6 = (Tacho1Class == 1 && Speed1Class == 1);;  % Speed 1 is abnormally low

        Speed1Rule7 = (Tacho1Class == 2 && Mean1Class == 2);     % Both speeds ok
        Speed1Rule8 = (Tacho1Class == 3 && Mean1Class == 1);    % Speed 1 abnormally high 
        Speed1Rule9 = (Tacho1Class == 1 && Mean1Class == 3);;  % Speed 1 is abnormally low
        
        if ~(Speed1Rule1 || Speed1Rule2 || Speed1Rule3 || Speed1Rule4 || Speed1Rule5 || Speed1Rule6 || Speed1Rule7 || Speed1Rule8 || Speed1Rule9)
            disp('None of the sensors are in consensus for direciton 1. Perform maintanance on all of them.')
        else
            % Combine all rules into an array
            allRules = [Speed1Rule1, Speed1Rule2, Speed1Rule3, Speed1Rule4, Speed1Rule5, Speed1Rule6, Speed1Rule7, Speed1Rule8, Speed1Rule9];
        
            % Find the first true condition
            trueConditionIndex = find(allRules, 1);
            switch trueConditionIndex
                case 1
                    disp('Speed in direction 1 is OK. Tacho reading is wrong.');
                    OverallCertainty = Mean1Certainty * Speed1Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 2
                    disp('Speed in direction 1 is HIGH. Tacho reading is wrong.');
                    OverallCertainty = Mean1Certainty * Speed1Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 3
                    disp('Speed in direction 1 is Low. Tacho reading is wrong.');
                    OverallCertainty = Mean1Certainty * Speed1Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 4
                    disp('Speed in direction 1 is OK. Gate reading is wrong.');
                    OverallCertainty = Tacho1Certainty * Speed1Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 5
                    disp('Speed in direction 1 is HIGH. Gate reading is wrong.');
                    OverallCertainty = Tacho1Certainty * Speed1Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 6
                    disp('Speed in direction 1 is LOW. Gate reading is wrong.');
                    OverallCertainty = Tacho1Certainty * Speed1Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 7
                    disp('Speed in direction 1 is OK. Motor reading is wrong. Check motor connection.');
                    OverallCertainty = Mean1Certainty * Tacho1Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 8
                    disp('Speed in direction 1 is HIGH. Motor reading is wrong. Check motor connection.');
                    OverallCertainty = Mean1Certainty * Tacho1Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 9
                    disp('Speed in direction 1 is LOW. Motor reading is wrong. Check motor connection.');
                    OverallCertainty = Mean1Certainty * Tacho1Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
            end
        end

    else
        OverallCertainty = Tacho1Certainty * Speed1Certainty * Mean1Certainty;
        switch Speed1Class
            case 1
                disp('Speed in direction 1 is LOW.');
                disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
            case 2
                healthy1 = 1;
                disp('Speed in direction 1 is OK.');
                disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
            case 3
                disp('Speed in direction 1 is HIGH.');
                disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
        end
    end
    
    % TRIPLET CONSENSUS
    Speed2ConsensusRule1 = (Mean2Class == 2 && Speed2Class == 2 && Tacho2Class == 2);     % all OK for speed 2
    Speed2ConsensusRule2 = (Mean2Class == 1 && Speed2Class == 3 && Tacho2Class == 3);     % all high for speed 2
    Speed2ConsensusRule3 = (Mean2Class == 3 && Speed2Class == 1 && Tacho2Class == 1);     % all low for speed 2

    if ~(Speed2ConsensusRule1 || Speed2ConsensusRule2 || Speed2ConsensusRule3)  % speed readings for dir 2 don't match
        Speed2Rule1 = (Mean2Class == 2 && Speed2Class == 2); % Both speeds 2  ok
        Speed2Rule2 = (Mean2Class == 1 && Speed2Class == 3); % Both speeds 2 high
        Speed2Rule3 = (Mean2Class == 3 && Speed2Class == 1); % Both speeds 2 low 
    
        Speed2Rule4 = (Tacho2Class == 2 && Speed2Class == 2); % Both speeds 2 ok
        Speed2Rule5 = (Tacho2Class == 3 && Speed2Class == 3); % Speed 2 abnormally high 
        Speed2Rule6 = (Tacho2Class == 1 && Speed2Class == 1); % Speed 2 is abnormally low
    
        Speed2Rule7 = (Tacho2Class == 2 && Mean2Class == 2);  % Both speeds ok
        Speed2Rule8 = (Tacho2Class == 3 && Mean2Class == 1);  % Speed 2 abnormally high 
        Speed2Rule9 = (Tacho2Class == 1 && Mean2Class == 3);  % Speed 2 is abnormally low

        if ~(Speed2Rule1 || Speed2Rule2 || Speed2Rule3 || Speed2Rule4 || Speed2Rule5 || Speed2Rule6 || Speed2Rule7 || Speed2Rule8 || Speed2Rule9)
            disp('None of the sensors are in consensus for direciton 2. Perform maintanance on all of them.')
        else
            % Combine all rules into an array
            allRules = [Speed2Rule1, Speed2Rule2, Speed2Rule3, Speed2Rule4, Speed2Rule5, Speed2Rule6, Speed2Rule7, Speed2Rule8, Speed2Rule9];
        
            % Find the first true condition
            trueConditionIndex = find(allRules, 1);
            switch trueConditionIndex
                case 1
                    disp('Speed in direction 2 is OK. Tacho reading is wrong.');
                    OverallCertainty = Mean2Certainty * Speed2Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 2
                    disp('Speed in direction 2 is HIGH. Tacho reading is wrong.');
                    OverallCertainty = Mean2Certainty * Speed2Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 3
                    disp('Speed in direction 2 is Low. Tacho reading is wrong.');
                    OverallCertainty = Mean2Certainty * Speed2Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 4
                    disp('Speed in direction 2 is OK. Gate reading is wrong.');
                    OverallCertainty = Tacho2Certainty * Speed2Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 5
                    disp('Speed in direction 2 is HIGH. Gate reading is wrong.');
                    OverallCertainty = Tacho2Certainty * Speed2Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 6
                    disp('Speed in direction 2 is LOW. Gate reading is wrong.');
                    OverallCertainty = Tacho2Certainty * Speed2Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 7
                    disp('Speed in direction 2 is OK. Motor reading is wrong. Check motor connection.');
                    OverallCertainty = Mean2Certainty * Tacho2Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 8
                    disp('Speed in direction 2 is HIGH. Motor reading is wrong. Check motor connection.');
                    OverallCertainty = Mean2Certainty * Tacho2Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
                case 9
                    disp('Speed in direction 2 is LOW. Motor reading is wrong. Check motor connection.');
                    OverallCertainty = Mean2Certainty * Tacho2Certainty;
                    disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
            end
        end
        
    else
        OverallCertainty = Tacho2Certainty * Speed2Certainty * Mean2Certainty;
        switch Speed2Class
            case 1
                disp('Speed in direction 2 is LOW.');
                disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
            case 2
                healthy2 = 1;
                disp('Speed in direction 2 is OK.');
                disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
            case 3
                disp('Speed in direction 2 is HIGH.');
                disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
        end
    end

    if healthy1 && healthy2
        disp('System is in a HEALTHY state.')
    else
        disp('System is in a FAULTY state.')
    end

end