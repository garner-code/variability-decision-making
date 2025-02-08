function [] = query_mouse_resp(window,button_idx,xPos,yPos,r,door_probs,...
    fid,fform,sub,sess,trial_n,cond,...
    trialStart, tgt_flag)

% poll for mouse position and write to the behavioural log file
tmp_flag = 0; % assuming no button info but will change in function if
% a press or a hover over a door is detected
[x,y,buttons] = GetMouse(window); % has the mouse been clicked
timer = GetSecs - trialStart;
% ignoring button pre
% logic of this is that for as long as there has been no button press,
% then just record the x and the y
% if there has been a mouse click then, was it within a door, and if
% so, end the while loop

% has a button been pressed?
if buttons(button_idx)
    door_check = doorSample(xPos, yPos, x, y); % returns distance of
    % mouse coordinates from all door centres
    didx = find(door_check < r); % which door has been selected
    curr_door_prob = door_probs(didx); % for data collection, this will tell us whether
    % this is a target, whether its a random error, or whether its a
    % 'different context' error
    if isempty(didx)
        didx = 0;
        curr_door_prob = 0;
    else
        tmp_flag = 1;
    end
else % if a button hasn't been pressed then check if hovering on a door
    door_check = doorSample(xPos, yPos, x, y); % returns distance of
    % mouse coordinates from all door centres
    didx = find(door_check < r); % which door has been selected
    if ~any(didx)
        didx = 0;
        tmp_flag = 0;
    else
        tmp_flag = 9; % a 9 tells us they are hovering on the door
    end
    curr_door_prob = 0;
end

% collect the data from this sample
fprintf(fid, fform, sub, sess, trial_n, cond, timer, tmp_flag, didx, ...
    curr_door_prob, tgt_flag, 0, x, y);