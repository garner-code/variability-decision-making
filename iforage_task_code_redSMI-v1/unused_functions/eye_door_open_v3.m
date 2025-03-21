function [tgt_found, didx, threshold, startTime, door_on_flag] = eye_door_open_v3(trial_start, startTime, sub, sess, ...
                                                                               trial_num, cond, tgt_flag, window, ...
                                                                               backRect, xCenter, yCenter, backCol, ...
                                                                               doorRects, doorClosedCol, doorOpenCol,...
                                                                               didx, fid, eye_used, el)

       % this function changes the door colour for as long as the gaze remains on it
       % writes to participant log and checks eyegaze every 10 ms
       % if the door is the same as the tgt then will set tgt_found to 1,
       % which will move the programme onto the tgt display    
       
       if didx == tgt_flag
           tgt_found = 1;
           threshold = 0;
           door_on_flag = 0;
       else
           tgt_found = 0;
           threshold = 1;
           door_on_flag = 1;
       end
       
       if ~any(tgt_found)
           %       frames_on = .02/ifi; % ~20 ms
           tmp_door_cols = doorClosedCol;
           tmp_door_cols(:, didx) = doorOpenCol;
           % change door colour
           
           draw_background(window, backRect, xCenter, yCenter, backCol);
           draw_doors(window, doorRects, tmp_door_cols);
           Screen('DrawingFinished', window);
           vbl = Screen('Flip', window);
           
           keep_door_open = 1;
           while any(keep_door_open)
               WaitSecs(.01);
               [x,y] = check_eyegaze_location(eye_used, el); % get the current coordinates
               idxs = check_doors(doorRects, x, y);
               if sum(idxs) > 0 % still on a door?
                   if find(idxs) == didx
                       timer = GetSecs - trial_start;
                       dur   = GetSecs - startTime;
                       threshold = 1;
                       fprintf(fid, '%d\t%d\t%d\t%d\t%.3f\t%d\t%d\t%d\t%d\n', sub, sess, trial_num, cond, timer, 1, find(idxs), tgt_flag, dur);
                       
                   elseif find(idxs) ~= didx % another door has been selected, restart timer
                       startTime = GetSecs;
                       didx = find(idxs); % set new door index flag
                       threshold = 0;
                       keep_door_open = 0;
                   end
               else
                   % the eye is not on any doors - reset 'doors on' flags
                   door_on_flag = 0;
                   threshold = 0;
                   didx = 0;
                   startTime = NaN;
                   keep_door_open = 0;
               end
           end
       end
end