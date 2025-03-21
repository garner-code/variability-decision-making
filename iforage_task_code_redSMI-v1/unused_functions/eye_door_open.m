function [tgt_found, didx, threshold, startTime, door_on_flag] = eye_door_open(trial_start, startTime, sub, sess, ...
                                                                               trial_num, cond, tgt_flag, window, ...
                                                                               backRect, xCenter, yCenter, backCol, ...
                                                                               doorRects, doorClosedCol, doorOpenCol,...
                                                                               didx, fid, eye_used, el, ifi, waitframes)

       % this function flashes a door for as long as the gaze remains on it
       % writes to participant log every 10 ms
       % if the door is the same as the tgt then will set tgt_found to 1,
       % which will move the programme onto the tgt display    
       door_on_flag = 1;
       
       if didx == tgt_flag
           tgt_found = 1;
       else
           tgt_found = 0;
       end
       
       frames_on = .2/ifi; % ~ 200 ms           

       % flicker with door closed colours
       vbl = Screen('Flip', window);
       for frame = 1:frames_on
           draw_background(window, backRect, xCenter, yCenter, backCol);
           draw_doors(window, doorRects, doorClosedCol);
           Screen('DrawingFinished', window);               
           [x,y] = check_eyegaze_location(eye_used, el); % get the current coordinates
           idxs = check_doors(doorRects, x, y);
           if sum(idxs) > 0 % still on a door?
              if find(idxs) == didx
                 timer = GetSecs - trial_start;
                 dur = GetSecs - startTime;
                 threshold = 1;
                 fprintf(fid, '%d\t%d\t%d\t%d\t%.3f\t%d\t%d\t%d\t%d\n', sub, sess, trial_num, cond, timer, 1, find(idxs), tgt_flag, dur); 

              elseif find(idxs) ~= didx % another door has been selected, restart timer
                 
                 startTime = GetSecs;
                 didx = find(idxs); % set new door index flag
                 threshold = 0;
              end
           else
              % the eye is not on any doors - reset 'doors on' flags 
              door_on_flag = 0;
              threshold = 0;
              didx = 0;
              startTime = NaN;
           end
           vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
       end

        % flicker with door open colour                
       for frame = 1:frames_on
           tmp_door_cols = doorClosedCol;
           tmp_door_cols(:, didx) = doorOpenCol;
           draw_background(window, backRect, xCenter, yCenter, backCol);
           draw_doors(window, doorRects, tmp_door_cols);
           Screen('DrawingFinished', window); 
                    
            [x,y] = check_eyegaze_location(eye_used, el); % get the current coordinates
            idxs = check_doors(doorRects, x, y);       
            if sum(idxs) > 0 % still on a door?
               if find(idxs) == didx % still on the same door? 
                  timer = GetSecs - trial_start;
                  dur = GetSecs - startTime;
                  threshold = 1;
                  fprintf(fid, '%d\t%d\t%d\t%d\t%.3f\t%d\t%d\t%d\t%d\n', sub, sess, trial_num, cond, timer, 1, find(idxs), tgt_flag, dur); 
               elseif find(idxs) ~= didx % another door has been selected, restart timer
                  startTime = GetSecs;
                  didx = find(idxs); % set new door index flag
                  threshold = 0;
               end
           else
              % the eye is not on any doors - reset 'doors on' flags 
              door_on_flag = 0;
              threshold = 0;
              didx = 0;
              startTime = NaN;
           end   
           vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
       end             
end