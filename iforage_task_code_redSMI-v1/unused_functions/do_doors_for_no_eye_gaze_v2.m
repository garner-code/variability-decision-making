function [didx, startTime, door_on_flag] = do_doors_for_no_eye_gaze_v2(doorRects, eye_used, el)
        
        % this code will check (every 10ms) whether the eyegaze is on a given door
        % if so, return the idx of the door and the time that the gaze
        % landed on the door, turn off the loop that invokes this function
        WaitSecs(.01); % limit samples to every 10 msec
        [x,y] = check_eyegaze_location(eye_used, el); % get the current coordinates
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

end

  