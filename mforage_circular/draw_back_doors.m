function [] = draw_back_doors(window, ...
    e_cent, edge_col, ...
    d_cent, main_col, ...
    door_xys, door_size, door_cols)

% draw the context colour, the main circle, and the doors
    Screen('FillOval', window, edge_col, e_cent);
    Screen('FillOval', window, main_col, d_cent);
    Screen('DrawDots', window, door_xys, door_size, door_cols, [], 2);
end



