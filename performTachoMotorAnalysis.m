function [] = performTachoMotorAnalysis(MotorSpeed1, MotorSpeed2, TachoSpeed1, TachoSpeed2)
    if ~isnan(MotorSpeed1) && ~isnan(TachoSpeed1) && TachoSpeed1 > 0  % Motor runs in direction 1, so should Tacho
        % Define linguistic variables and membership functions for tacho speed
        LowTacho1 = trimf(TachoSpeed1, [0, 0, 5,5]);
        MediumTacho1 = trimf(TachoSpeed1, [5, 6, 7.5]);
        HighTacho1 = trimf(TachoSpeed1, [7, 25, 100000]);

        % Define linguistic variables and membership functions for motor speed
        LowMotorSpeed1 = trapmf(MotorSpeed1, [0, 0, 38, 41]);
        MediumMotorSpeed1 = trapmf(MotorSpeed1, [40, 42, 44, 46]);
        HighMotorSpeed1 = trapmf(MotorSpeed1, [45, 47, 200, 200]);

        % Determine the dominant class for each reading
        [Tacho1Certainty, Tacho1Class] = max([LowTacho1, MediumTacho1, HighTacho1]);
        [Speed1Certainty, Speed1Class] = max([LowMotorSpeed1, MediumMotorSpeed1, HighMotorSpeed1]);

        % Fuzzy rules
        Rule1 = (Tacho1Class == 2 && Speed1Class == 2);     % Both speeds 1 ok
        Rule2 = (Tacho1Class == 3 && Speed1Class == 3);    % Speed 1 abnormally high 
        Rule3 = (Tacho1Class == 1 && Speed1Class == 1);;  % Speed 1 is abnormally low

        if ~(Rule1 || Rule2 || Rule3)   % readings in dir 1 don't match
            disp('Measurements in dir 1 dont match. Check that Motor and Tacho are connected properly.');
            OverallCertainty = Tacho1Certainty * Speed1Certainty;
            disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
        else
            OverallCertainty = Tacho1Certainty * Speed1Certainty;
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
    end

    if ~isnan(MotorSpeed2) && ~isnan(TachoSpeed2) && TachoSpeed2 > 0    % If motor runs so should Tacho
        % Define linguistic variables and membership functions for tacho speed
        LowTacho2 = trimf(TachoSpeed2, [0, 0, 5,5]);
        MediumTacho2 = trimf(TachoSpeed2, [5, 6, 7.5]);
        HighTacho2 = trimf(TachoSpeed2, [7, 25, 100000]);
    
        % Define linguistic variables and membership functions for motor speed
        LowMotorSpeed2 = trapmf(MotorSpeed2, [0, 0, 38, 41]);
        MediumMotorSpeed2 = trapmf(MotorSpeed2, [40, 42, 44, 46]);
        HighMotorSpeed2 = trapmf(MotorSpeed2,  [45, 47, 200, 200]);

        % Determine the dominant class for each reading
        [Tacho2Certainty, Tacho2Class] = max([LowTacho2, MediumTacho2, HighTacho2]);
        [Speed2Certainty, Speed2Class] = max([LowMotorSpeed2, MediumMotorSpeed2, HighMotorSpeed2]);
    
        Rule4 = (Tacho2Class == 2 && Speed2Class == 2); % Both speeds 2 ok
        Rule5 = (Tacho2Class == 3 && Speed2Class == 3);    % Speed 2 abnormally high 
        Rule6 = (Tacho2Class == 1 && Speed2Class == 1);  % Speed 2 is abnormally low

        if ~(Rule4 || Rule5 || Rule6)   % readings in dir 2 don't match
            disp('Measurements in dir 2 dont match. Check that Motor and Tacho are connected properly.');
            OverallCertainty = Tacho2Certainty * Speed2Certainty;
            disp(['Certainty: ' num2str(round(OverallCertainty * 100)) '%']);
        else
            OverallCertainty = Tacho2Certainty * Speed2Certainty;
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
       
end