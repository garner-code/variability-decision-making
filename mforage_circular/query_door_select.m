function [didx, door_on_flag, x, y] = query_door_select(door_on_flag, ...
    window, ...
    e_cent, edge_col, ...
    d_cent, main_col, ...
    door_xys, door_size, doors_closed_cols, ...
    fid, fform, sub, sess, ...
    trial_n, cond, tgt_flag, ...
    r, door_probs, trial_start, ...
    button_idx)

% DESC: this code will continuously check whether a participant
% has selected a door by clicking the left mouse button
% within the door area
% if so, return the idx of the door and the time that the door was
% selected
% then turn off this function to move to the door open stage
start_test   = 0; % this means that a door has not yet been selected, the remainder of the function will run until this test has been passed
% get refrsh rate
ifi = Screen('GetFlipInterval', window);
waitframes = 1;

% draw the unopened doors
tmp_door_cols = doors_closed_cols;
% change door colour
draw_back_doors(window, e_cent, edge_col, ...
    d_cent, main_col, door_xys, door_size, doors_closed_cols);
Screen('DrawingFinished', window);
vbl = Screen('Flip', window);

% now poll for a click of a door
while ~any(start_test)

    tmp_flag = 0;
    draw_back_doors(window, e_cent, edge_col, ...
        d_cent, main_col, door_xys, door_size, doors_closed_cols);
    Screen('DrawingFinished', window);
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi); % limit samples to flip rate

    [x,y,buttons] = GetMouse(window); % has the mouse been clicked
    timer = GetSecs - trial_start;
    % logic of this is that for as long as there has been no button press,
    % then just record the x and the y
    % if there has been a mouse click then, was it within a door, and if
    % so, end the while loop

    % has a button been pressed?
    if buttons(button_idx)
        
        door_check = doorSample(door_xys(1,:), door_xys(2,:), x, y); % returns distance of
        % mouse coordinates from all door centres
        didx = find(door_check < r); % which door has been selected
        curr_door_prob = door_probs(didx); % for data collection, this will tell us whether
        % this is a target, whether its a random error, or whether its a
        % 'different context' error
        %%%%%%%%%%% need to assign if didx is a thing
        if isempty(didx)
            didx = 0;
            curr_door_prob = 0;
        else
            tmp_flag = 1;
        end
    else % if a button hasn't been pressed then check if hovering on a door
        door_check = doorSample(door_xys(1,:), door_xys(2,:), x, y); % returns distance of
        % mouse coordinates from all door centres
        didx = find(door_check < r); % which door has been selected
        if ~any(didx)
            didx = 0;
            tmp_flag = 0;
            curr_door_prob = 0;
        else
            tmp_flag = 9;
            curr_door_prob = door_probs(didx);
        end
    end
   
    % collect the data from this sample
    fprintf(fid, fform, sub, sess, trial_n, cond, timer, tmp_flag, didx, curr_door_prob, tgt_flag, 0, x, y); % KG: MFORAGE: I HAVE ADJUSTED THIS FORMAT (BEH_FORM), NEED TO MATCH AGAINSTS SPECS
    if tmp_flag == 1
        door_on_flag = 1;
    end
    if door_on_flag % the participant has selected a door, so we can leave
        start_test   = 1;
    end
end
end

    




  