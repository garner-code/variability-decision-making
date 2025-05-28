function [] = draw_back_doors(window, ...
    xCenter, yCenter, ...
    d_edge, edge_col, ...
    d_main, main_col, ...
    door_xys, door_size, door_cols)

% draw the context colour, the main circle, and the doors
    Screen('DrawDots', window, [xCenter; yCenter], d_edge, edge_col);
    Screen('DrawDots', window, [xCenter; yCenter], d_main, main_col);
    Screen('DrawDots', window, door_xys, door_size, door_cols);
end



