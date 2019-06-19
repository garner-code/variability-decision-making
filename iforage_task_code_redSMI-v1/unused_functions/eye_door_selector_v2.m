function [didx, door_on_flag, threshold, new_startTime] = eye_door_selector_v2(startTime, door, doorRects, tgt_flag, fid, sub, sess, trial_n, cond, door_p, trialStart, REDm_info)
% this function tests whether the gaze has been on a single door for over 500 ms, given samples collected every 10 ms
% also updates participant file every 10 ms
        WaitSecs(.01); % limit samples to every 10 msec
        [x,y] = check_eyegaze_location(eye_used, el); % get the current coordinates
        idxs = check_doors(doorRects, x, y);
        threshold = 0;
        if sum(idxs) > 0
            
            didx = find(idxs);
            d_p_idx = door_p(didx);
            door_on_flag = 1;
            if didx == door % is it the same door?
                dur = GetSecs - startTime;
                timer = GetSecs - trialStart;
                fprintf(fid, '%d\t%d\t%d\t%d\t%.3f\t%d\t%d\t%.3f\t%d\t%.3f\n', sub, sess, trial_n, cond, timer, 0, didx, d_p_idx, tgt_flag, dur);
                
                if dur > .5
                    threshold = 1;
                end
                new_startTime = startTime;
                
            else % eyes have moved to a new door and need to start a new poll 
                
                threshold = 0;
                new_startTime = GetSecs;
            end  
        else
            
            door_on_flag = 0;
            threshold = 0;
            didx = 0;
            new_startTime = 0;
        end
end