function [tflag, time_flag, emr_cal] = check_fix_to_start_trial(REDm_info, xCenter, yCenter, r, trial_n, sample_n, thresh_n, tflag, emr_cal)
% sample and threshold = period to sample and threshold (*10 to get ms)
collect_distances  = [];
% sample_n           = 150; % units (* 10 to get ms): 
% thresh_n           = 150*.9;

while ~any(tflag)
    
    WaitSecs(.01); % limit samples to every 10 msec
    [x,y,t] = SMI_Redm_GetGazeCoords(REDm_info); % where is fixation?
    
    if ~isempty(x)
    
        fix_check = sqrt((xCenter - x)^2 + (yCenter - y)^2);
        if isempty(collect_distances)
            collect_distances = fix_check;
        else
            collect_distances = [fix_check, collect_distances];
        end
        
        if length(collect_distances) > sample_n
            
            test = collect_distances(1:sample_n);
            test = test < r;
            test = sum(test);
            
            if test > thresh_n
                time_flag = GetSecs;
                SMI_Redm_SendMessage(sprintf('%.3f_Trial_%d_init', t, trial_n));
                tflag = 1;
            end
        end
    else
    end
        % need to run an emergency eyetrack?
    [key_down, ~, key_code] = KbCheck;
    if any(KbName(KbName(find(key_code))) == KbName('x'))
        emr_cal = 1;
        tflag = 0;
        time_flag = 999;
        break
    end
    

end

end
