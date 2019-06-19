function [emr_cal, tgt_found, didx, startTime, door_on_flag] = eye_door_open_v4(REDm_info, trial_start, startTime, sub, sess, ...
    trial_n, cond, door_p, tgt_flag, window, ...
    backRect, xCenter, yCenter, backCol, ...
    doorRects, doorClosedCol, doorOpenCol,...
    didx, fid, fform, xPos, yPos, r, fixCol, fixRect, maxFixDiam, emr_cal, ...
    trg_id, ioObj, port_address, trglg_fid, trg_form)

% this function changes the door colour for as long as the gaze remains on it
% writes to participant log and checks eyegaze every 10 ms
% if the door is the same as the tgt then will set tgt_found to 1,
% which will move the programme onto the tgt display
% if a door is not selected for 80/100 msec then the function is
% turned off
collect_idxs = [];
sample_n     = 50;
thresh_n     = 45; % this number or less
tgt_found    = 0;
% get refrsh rate
ifi = Screen('GetFlipInterval', window);
waitframes = 1;

if ~any(tgt_found)
    
    % draw the open door
    %       frames_on = .02/ifi; % ~20 ms
    tmp_door_cols          = doorClosedCol;
    tmp_door_cols(:, didx) = doorOpenCol;
    % change door colour
    
    draw_background(window, backRect, xCenter, yCenter, backCol);
    draw_doors(window, doorRects, tmp_door_cols);
    Screen('FillOval', window, fixCol, fixRect, maxFixDiam);
    Screen('DrawingFinished', window);
    vbl = Screen('Flip', window);
    send_trigger(trg_id, sub, sess, trial_n, cond, vbl, ioObj, port_address, trglg_fid, trg_form);
    
    % check if the door is the tgt door
    
            
    % check if the target has been found
    if didx == tgt_flag
        % record the door numbber into the results file
        door_on_flag = 0;
        d_p_idx = door_p(didx);
        fprintf(fid, fform, sub, sess, trial_n, cond, 999, 1, didx, d_p_idx, tgt_flag, .2, 9, 9);
        keep_door_open = 0;
        tgt_found = 1;
    else
        tgt_found = 0;
        door_on_flag = 1;
        keep_door_open = 1;
    end
  
    while any(keep_door_open)
        
        draw_background(window, backRect, xCenter, yCenter, backCol);
        draw_doors(window, doorRects, tmp_door_cols);
        Screen('FillOval', window, fixCol, fixRect, maxFixDiam);
        Screen('DrawingFinished', window);  
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi); % limit samples to flip rate
        [x,y,t] = SMI_Redm_GetGazeCoords(REDm_info); % where is fixation?

        if ~isempty(x)
            dur   = GetSecs - startTime;
            timer = GetSecs - trial_start;
            door_check = doorSample(xPos, yPos, x, y); % returns distance of coordinates from all door centres
            if isempty(collect_idxs)
                collect_idxs = door_check;
            else
                collect_idxs = cat(3, door_check, collect_idxs);
            end
            
            didx = find(door_check < r);
            d_p_idx = door_p(didx);
            d_pressed = 1; % 1 because door is open, 0 if not
            if isempty(didx)
                didx      = 0;
                d_p_idx   = 0;
                d_pressed = 0;
            end
            % send current info to output file
            fprintf(fid, fform, sub, sess, trial_n, cond, timer, d_pressed, didx, d_p_idx, tgt_flag, dur, x, y);
            
            if size(collect_idxs,3) > sample_n % check that all the collected door indexes are the same value and that it has been the same for 50 ms worth of samples
                test = collect_idxs(:,:,1:sample_n);
                % does the time spent away from the radius of the open door centre meet
                % criteria?
                test = test < r; % get a logical array
                test = sum(test,3); % sum over array
                
                if didx == 0 || test(didx) <= thresh_n   % if the door that was opened just prior to this loop is below threshold for fixation samples, then close it 
                    door_on_flag = 0;
                    startTime = NaN;
                    SMI_Redm_SendMessage(sprintf('%.3f_Door_%d_closed', t, didx));
                    keep_door_open = 0;
                end
                
            end
        else
        end

        % need to run an emergency eyetrack?
        [key_down, ~, key_code] = KbCheck;
        if KbName(KbName(find(key_code))) == KbName('x')
            emr_cal      = 1;
            tgt_found    = NaN; 
            didx         = NaN; 
            startTime    = NaN; 
            door_on_flag = 0;
            break
        end     
    end
end
end