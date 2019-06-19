function [didx, startTime, door_on_flag] = do_doors_for_no_eye_gaze(window, ifi, waitframes, doorRects, backRect, xCenter, yCenter, backCol, doorClosedCol)
        
        % this code will check whether the eyegaze is on a given door
        % if so, return the idx of the door and the time that the gaze
        % landed on the door
        
        frames_on = round(.1/ifi); % = ~100 ms, arbitrary value as we are in a while loop
        vbl = Screen('Flip', window);
        for frame = 1:frames_on
            draw_background(window, backRect, xCenter, yCenter, backCol);
            draw_doors(window, doorRects, doorClosedCol);
            Screen('DrawingFinished', window);
            
            [x,y] = check_eyegaze_location; % get the current coordinates
            idxs = check_doors(doorRects, x, y);
            if sum(idxs) > 0
                didx = find(idxs);
                startTime = GetSecs;
                door_on_flag = 1;
            else
                didx = 0;
                door_on_flag = 0;
                startTime = NaN;
            end
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        end
end

  