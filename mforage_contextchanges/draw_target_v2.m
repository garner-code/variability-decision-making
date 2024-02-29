function [] = draw_target_v2(window, edgeRect, backRect, edgeCol, backCol, ...
    doorRects, doorCol,...
    didx, image_num, xCenter, yCenter, context_on, trial_start)
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

% draw doors with target
draw_edge(window, edgeRect, xCenter, yCenter, edgeCol, trial_start, context_on);
draw_background(window, backRect, xCenter, yCenter, backCol);
draw_doors(window, doorRects, doorCol);
im_rect = doorRects(:, didx);
Screen('DrawTexture', window, tex, [], im_rect);
tgt.vbl = Screen('Flip', window);

end