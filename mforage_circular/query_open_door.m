function [tgt_found, didx, door_on_flag] = query_open_door(trial_start, ...
    sub, sess, ...
    trial_n, cond, door_p, tgt_flag, ...
    window, ...
    e_cent, edge_col, ...
    d_cent, main_col, ...
    door_xys, door_size, door_closed_cols, ...
    door_open_col, didx, ...
    x, y, button_idx, ...
    fid, fform)

% QUERY_OPEN_DOOR: this function queries whether the selected door is the
% target door or not.
% if the target, the tgt_found flag is set and we move to the next stage of
% the trial (presenting the target)
% if not, then a darker door is presented for 200 ms and then returned to
% its original colour. % KG: MFORAGE: this number is variable

door_on_flag = 1;
% get refrsh rate
ifi = Screen('GetFlipInterval', window);
waitframes = 1;

% draw the open door
tmp_door_cols = door_closed_cols;
% change door colour
draw_back_doors(window, e_cent, edge_col, ...
    d_cent, main_col, door_xys, door_size, tmp_door_cols);
Screen('DrawingFinished', window);
vbl = Screen('Flip', window);

timer = GetSecs - trial_start;
% check if the selected door is a target door
if didx == tgt_flag
    % record the door numbber into the results file
    d_p_idx = door_p(didx);
    tgt_found = 1;
    fprintf(fid, fform, sub, sess, trial_n, cond, timer,...
             door_on_flag, didx, d_p_idx, ...
             tgt_flag, tgt_found, ...
             x, y); % KG: MFORAGE: Check this matches up with other function and BEH_FORM, 
else
    
    d_p_idx = door_p(didx);
    tgt_found = 0;
    % draw the open door
    tmp_door_cols          = door_closed_cols;
    tmp_door_cols(:, didx) = door_open_col;

    %%%%% KEEP DOOR OPEN IF BUTTON STILL DEPRESSED
    [~,~,buttons] = GetMouse(window);
    % detect when the
    % mouse x and y has moved outside of the region of the selected door, 
    % if so, manually break the loop and exit this function
        while buttons(button_idx)

            timer = GetSecs - trial_start; % keep timing info
            % poll the mouse to learn when the door has been no longer pressed
            [x,y,buttons] = GetMouse(window);
            draw_back_doors(window, e_cent, edge_col, ...
                d_cent, main_col, door_xys, door_size, tmp_door_cols);
            Screen('DrawingFinished', window);
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi); % limit samples to flip rate
            fprintf(fid, fform, sub, sess, trial_n, cond, timer, ...
                door_on_flag, didx, d_p_idx, ...
                tgt_flag, tgt_found, x, y); % KG: MFORAGE: Check this matches up with other function and BEH_FORM
        end   
end

door_on_flag = 0;

end



