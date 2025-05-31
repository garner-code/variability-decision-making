function [points, tgt_on] = draw_target_v2(window, ...
    e_cent, edge_col,...
    d_cent, main_col, ...
    door_xys, door_size, doors_closed_cols, ...
    didx, srch_tex, ...
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
        points = (feedback_goal+1) - door_select_count;
    end
else
    points = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% draw doors with target
draw_back_doors(window, e_cent, edge_col, ...
    d_cent, main_col, door_xys, door_size, doors_closed_cols);

tgt_xys = door_xys(:, didx);
% now I know where the target should go, I draw a rect for the target image
im_rect = [0, 0, door_size, door_size];
im_cent = CenterRectOnPointd(im_rect, tgt_xys(1), tgt_xys(2));

draw_back_doors(window, e_cent, edge_col, ...
    d_cent, main_col, door_xys, door_size, doors_closed_cols);
Screen('DrawTexture', window, srch_tex, [], im_cent);

% start sound and draw the target
if points > 0
    PsychPortAudio('Start', coin_handles{points}, 1, 0, 0);
end
tgt.vbl = Screen('Flip', window);
tgt_on = tgt.vbl;

end