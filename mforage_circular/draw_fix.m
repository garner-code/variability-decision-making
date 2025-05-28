function [] = draw_fix(window, xCenter, yCenter, ...
    d_main, main_col, ...
    d_fix, fix_col)

    % draw fixation dot
    Screen('DrawDots', window, [xCenter; yCenter],  d_main, main_col);
    Screen('DrawDots', window, [xCenter; yCenter],  d_fix, fix_col);
end