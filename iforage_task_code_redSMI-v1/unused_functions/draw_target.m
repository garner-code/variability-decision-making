function [] = draw_target(window, backRect, backCol, doorRects, doorCol, doorOpenCol, didx, image_num,  xCenter, yCenter, cycle_time)
% this function draws the target to the selected door
% backRect/backCol = features of background
% doorRects/doorCol = door features
% didx = id of the door where the tgt is
% image_num - a string of either '01'-'09' or '10'+ for the specific target
% found
% time_on = duration of time for which the target should be left on

im = imread(sprintf('tgt%s.jpeg', image_num));
tex = Screen('MakeTexture', window, im);

% do two cycles of flash before tgt revealed
for count = 1:2
    tStamp = GetSecs;
    draw_background(window, backRect, xCenter, yCenter, backCol);
    draw_doors(window, doorRects, doorCol);
    Screen('DrawingFinished', window);
    cl.vbl = Screen('Flip', window, tStamp + cycle_time);
    % continue to collect trial num, x's, y's, timestamp, and a 1
    % make door flash
    tmp_door_cols = doorCol;
    tmp_door_cols(:, didx) = doorOpenCol;
    draw_background(window, backRect, xCenter, yCenter, backCol);
    draw_doors(window, doorRects, tmp_door_cols);
    op.vbl = Screen('Flip', window, cl.vbl + cycle_time);
end

draw_background(window, backRect, xCenter, yCenter, backCol);
draw_doors(window, doorRects, doorCol);
im_rect = doorRects(:, didx);
Screen('DrawTexture', window, tex, [], im_rect);
Screen('Flip', window, op.vbl + cycle_time);

end