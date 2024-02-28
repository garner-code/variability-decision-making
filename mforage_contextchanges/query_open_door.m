function [tgt_found, didx, door_on_flag] = query_open_door(trial_start, sub, sess, ...
    trial_n, cond, door_p, tgt_flag, window, ...
    backRect, xCenter, yCenter, backCol, ...
    doorRects, doorClosedCol, doorOpenCol,...
    didx, fid, fform, x, y)

% QUERY_OPEN_DOOR: this function queries whether the selected door is the
% target door or not.
% if the target, the tgt_found flag is set and we move to the next stage of
% the trial (presenting the target)
% if not, then a darker door is presented for 200 ms and then returned to
% its original colour. % KG: MFORAGE: this number is variable

tgt_found    = 0;
% get refrsh rate
ifi = Screen('GetFlipInterval', window);
waitframes = 1;

% check if the selected door is a target door
if didx == tgt_flag
    % record the door numbber into the results file
    door_on_flag = 0;
    d_p_idx = door_p(didx);
    tgt_found = 1;
    fprintf(fid, fform, sub, sess, trial_n, cond, 999, 1, didx, d_p_idx, tgt_flag, tgt_found, x, y); % KG: MFORAGE: Check this matches up with other function and BEH_FORM, ALSO what is 1?
else
    
    d_p_idx = 0;
    tgt_found = 0;
    % draw the open door
    %       frames_on = .02/ifi; % ~20 ms
    tmp_door_cols          = doorClosedCol;
    tmp_door_cols(:, didx) = doorOpenCol;

    %%%%% KEEP DOOR OPEN IF BUTTON STILL DEPRESSED
    button_idx = 1; % KG: MFORAGE: if I am good I will ultimately set this in the 'run...' script
    [~,~,buttons] = GetMouse(window);
    % the below is going to have to include some code that detects when the
    % mouse x and y has moved outside of the region of the selected door, 
    % if so, will manually break the loop and exit this function
        while buttons(button_idx)
            % poll the mouse to learn when the door has been no longer pressed
            [x,y,buttons] = GetMouse(window);

            draw_background(window, backRect, xCenter, yCenter, backCol);
            draw_doors(window, doorRects, tmp_door_cols);
            Screen('DrawingFinished', window);
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi); % limit samples to flip rate
            fprintf(fid, fform, sub, sess, trial_n, cond, 999, 1, didx, d_p_idx, tgt_flag, tgt_found, x, y); % KG: MFORAGE: Check this matches up with other function and BEH_FORM

        end
    end
end



