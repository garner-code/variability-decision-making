function [] = draw_target_v2(window, backRect, backCol, doorRects, doorCol, doorOpenCol, didx, image_num, xCenter, yCenter, cycle_time)
% this function draws the target to the selected door
% backRect/backCol = features of background
% doorRects/doorCol = door features
% didx = id of the door where the tgt is
% image_num - a string of either '01'-'09' or '10'+ for the specific target
% found
% time_on = duration of time for which the target should be left on
if image_num < 10
    if exist(sprintf('tgt0-100/tgt0%d.jpeg', image_num))
        im_fname = sprintf('tgt0-100/tgt0%d.jpeg', image_num);
    else
        im_fname = sprintf('tgt0-100/tgt0%d.jpg', image_num);
    end
else
    if exist(sprintf('tgt0-100/tgt%d.jpeg', image_num))
        im_fname = sprintf('tgt0-100/tgt%d.jpeg', image_num);
    else
        im_fname = sprintf('tgt0-100/tgt%d.jpg', image_num);
    end   
end

im = imread(im_fname);
tex = Screen('MakeTexture', window, im);

% slight pause before the target is revealed
start_pres = GetSecs;
last_door  = .05;
tmp_door_cols = doorCol;
tmp_door_cols(:, didx) = doorOpenCol;
draw_background(window, backRect, xCenter, yCenter, backCol);
draw_doors(window, doorRects, tmp_door_cols);
op.vbl = Screen('Flip', window, start_pres + last_door);

draw_background(window, backRect, xCenter, yCenter, backCol);
draw_doors(window, doorRects, doorCol);
im_rect = doorRects(:, didx);
Screen('DrawTexture', window, tex, [], im_rect);
Screen('Flip', window, op.vbl + cycle_time);
SMI_Redm_SendMessage(sprintf('Tgt_onset'));

end