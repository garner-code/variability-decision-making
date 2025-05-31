function [] = draw_fix(window, xCenter, yCenter, ...
    d_cent, main_col, ...
    d_fix, fix_col)

    % draw background and then fixation dot
    Screen('FillOval', window, main_col, d_cent);
    Screen('DrawDots', window, [xCenter; yCenter],  d_fix, fix_col, [], 2);
end