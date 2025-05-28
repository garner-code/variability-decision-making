function [points, tgt_on] = draw_target_v2(window, ...
    xCenter, yCenter, ...
    d_edge, edge_col, ...
    d_main, main_col, ...
    door_xys, door_size, door_closed_cols, ...
    didx, srch_tex, ...
    trial_start, ...
    door_select_count, feedback_goal, feedback_on, ...
    coin_handles)
% this function draws the target to the selected door
% and if appropriate, plays feedback

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now compute performance relative to target
if feedback_on

    if door_select_count >= feedback_goal
        points = 0;
    else
        points = goal - door_select_count;
    end
else
    points = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% draw doors with target
draw_back_doors(window, xCenter, yCenter, ...
    d_edge, edge_col, ...
    d_main, main_col, ...
    door_xys, door_size, door_closed_cols);

tgt_xys = door_xys(:, didx);
% make a rect that is slightly larger than the square diameter (sizing will
% have to be fiddled with to get the target the same size as the circular
% doors.
% after that, draw the texture into the new rect which is centred on the x
% and y of the target location
im_rect
Screen('DrawTexture', window, srchtex, [], im_rect);
% how to put a round border on top?

% start sound and draw the target
if points > 0
    PsychPortAudio('Start', coin_handles{points}, 1, 0, 0);
end
tgt.vbl = Screen('Flip', window);
tgt_on = tgt.vbl;

end