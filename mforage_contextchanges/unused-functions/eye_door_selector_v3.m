function [didx, door_on_flag, threshold, new_startTime] = eye_door_selector_v3(startTime, door, doorRects, tgt_flag, fid, fform, sub, sess, trial_n, cond, door_p, trialStart, REDm_info)
% this function tests whether the gaze has been on a single door for over 500 ms, given samples collected every 10 ms
% also updates participant file every 10 ms

start_test   = 0;
collect_idxs = [];
total_samples = 50; % number of samples required to pass threshold

while ~any(start_test)
    
        WaitSecs(.01); % limit samples to every 10 msec
        [x,y,t] = SMI_Redm_GetGazeCoords(REDm_info); % where is fixation?
        threshold = 0; % this will be passed back to programme when it turns to 1, to instantiate next stage of programme
        
        if ~isempty(x)
           idxs = check_doors(doorRects, x, y);
           dur = GetSecs - startTime;
           timer = GetSecs - trialStart;
           if sum(idxs) > 0
               didx = find(idxs);
               d_p_idx = door_p(didx);
               
           else
               didx = 0;
           end
           fprintf(fid, fform, sub, sess, trial_n, cond, timer, 0, didx, d_p_idx, tgt_flag, dur, x, y);
           
           collect_idxs = [didx, collect_idxs];
           
           if length(collect_idxs) > total_samples
               test = collect_idxs(1:total_samples);
               
               if sum(test) > 0 
                   
                 
            
        end
        

        
            

            door_on_flag = 1;
            if didx == door % is it the same door?

                
                
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
end