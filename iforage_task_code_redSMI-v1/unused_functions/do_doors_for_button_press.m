function [didx, buttons] = do_doors_for_button_press(window, doorRects, backRect, xCenter, yCenter, backCol, doorClosedCol, doorOpenCol, cycle_time, x, y, tgt_flag, start_time_poll, buttons)
        
% need to add bit about tgt_flag

        pressTime = GetSecs;   
        idxs = check_doors(doorRects, x, y);
        
        if sum(idxs) > 0
            didx = find(idxs);

            if pressTime - start_time_poll > 1 % have they "selected" a door
                
                tStamp = GetSecs;
                draw_background(window, backRect, xCenter, yCenter, backCol);
                draw_doors(window, doorRects, doorClosedCol);
                Screen('DrawingFinished', window);                
                cl.vbl = Screen('Flip', window, tStamp + cycle_time);
                % continue to collect trial num, x's, y's, timestamp, and a 1
                % make door flash
                tmp_door_cols = doorClosedCol;
                tmp_door_cols(:, didx) = doorOpenCol;
                draw_background(window, backRect, xCenter, yCenter, backCol);
                draw_doors(window, doorRects, tmp_door_cols);
                op.vbl = Screen('Flip', window, cl.vbl + cycle_time);
                
            end
            
            if didx == tgt_flag % put here so at least one flash before tgt reveal
                buttons = 0;
            else buttons = buttons;
            end
            
        else
            didx = 0;
        end
end