function [emr_cal, window, windowRect, screenXpixels, screenYpixels, xCenter, yCenter] = emergency_calibration(REDm_info, mon_ID, xPix, yPix, cal_scale, screenNumber, black, eye)
%%%%%% run emergency calibration
% REDm_info    = trial structure 
% mon_ID       = monitor id (single number)
% xPix         = x pixels, defined in the main script
% yPix         = y, as above
% cal_scale    = scale to pull in geometry to. defined in main script
% screenNumber = number to project to, defined in main script
% black        = black index, defined in main script
% eye          = data structure defined in iforage
      
    %%%%%%%% close down screen and run emergency eye-tracking calibration
    Screen('CloseAll');
    
    
    happy = 0; % happy will be = 1 when get a good calibration/validation
    
    while happy == 0
        
        cal_scale = 1;
        % calibrate eyetracker
        SMI_Redm_CalibrateEyetracker(REDm_info,mon_ID,xPix,yPix,cal_scale); % monitor 2 = test room
        
        validationcount = 0; % number of attempts at having a happy validation
        
        while happy == 0 && validationcount <= eye.numvalspercal
            
            validationcount  = validationcount  + 1;
            
            % validate eyetracker for use
            [REDm_info, accdata] = SMI_Redm_ValidateEyetracker(REDm_info);
            
            if max([accdata.deviationLX accdata.deviationRX accdata.deviationLY accdata.deviationRY]) < eye.validationaccuracy % in degrees (smaller the more accurate)
                happy = 1;
                disp('good validation')
                accdata % print to screen just for kicks
                
            else
                disp('bad validation')
            end
        end
    end
    
    %%%%%%% re-set up screen stuff to continue
    GetSecs;
    AssertOpenGL
    Screen('Preference', 'SkipSyncTests', 0);
    back_grey = 200;
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, back_grey);
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(windowRect);
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    topPriorityLevel = MaxPriority(window);
    Priority(topPriorityLevel);

    % turn off emergency calibration flag
    emr_cal = 0;
                
end