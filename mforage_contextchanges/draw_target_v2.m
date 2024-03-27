function [points, tgt_on] = draw_target_v2(window, edgeRect, backRect, edgeCol, backCol, ...
    doorRects, doorCol,...
    didx, image_num, xCenter, yCenter, context_on, trial_start,...
    door_select_count, feedback_on, screenYpixels, ...
    coin_handles)
% this function draws the target to the selected door
% backRect/backCol = features of background
% doorRects/doorCol = door features
% didx = id of the door where the tgt is
% image_num - a string of either '01'-'09' or '10'+ for the specific target
% found
% door_select_count = how many doors did they have to pick?
% feedback_on = do you want to give points feedback?
% ScreenYPixels - number of pixels along Y
% coin_handle - handle to audio feedback sound

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now compute performance relative to target
if feedback_on
    goal = 5; % KG: MFORAGE: This is hardcoded!
    if door_select_count >= goal
        points = 0;
    else
        points = goal - door_select_count;
    end

    %     Screen('TextStyle', window, 1);
    %     Screen('TextSize', window, 60);
    %     feedback = sprintf(['You got it in %d moves\n\n'...
    %                             '%d points\n\n'], door_select_count, points);
    %     DrawFormattedText(window, feedback,'Center', screenYpixels*.15, [255, 215, 0]);
else
    points = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% draw doors with target
draw_edge(window, edgeRect, xCenter, yCenter, edgeCol, trial_start, context_on);
draw_background(window, backRect, xCenter, yCenter, backCol);
draw_doors(window, doorRects, doorCol);
im_rect = doorRects(:, didx);
Screen('DrawTexture', window, tex, [], im_rect);
% start sound and draw the target
if points > 0
    PsychPortAudio('Start', coin_handles{points}, 1, 0, 0);
end
tgt.vbl = Screen('Flip', window);
tgt_on = tgt.vbl;

end