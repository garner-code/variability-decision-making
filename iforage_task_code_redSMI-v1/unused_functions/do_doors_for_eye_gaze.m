function [didx] = do_doors_for_eye_gaze(window, ifi, waitframes, doorRects, backRect, xCenter, yCenter, backCol, doorClosedCol, doorOpenCol, cycle_time, tgt_flag, start_time_poll, fid)
        
        % this code will check whether the eyegaze is on a given door
        % if so, start to record how long for 
        % if > 1 second, start to flash the door
        % keep reading until eyegaze passes the threshold
        
        door_on_flag = 0;
        frames_on = round(.1/ifi); % = ~100 ms, arbitrary value as we are in a while loop
        while ~any(door_on_flag)
            
            vbl = Screen('Flip', window);
            for frame = 1:frames_on
                draw_background(window, backRect, xCenter, yCenter, backCol);
                draw_doors(window, doorRects, doorClosedCol);
                Screen('DrawingFinished', window);   
            
                [x,y] = check_eyegaze_location; % get the current coordinates
                 idxs = check_doors(doorRects, x, y);
                if sum(idxs) > 0
                    startTime = GetSecs;
                    door_on_flag = 1;
                end
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            end
        end

        while any(door_on_flag)
            
            didx = find(idxs);
            
            % has the fixation been on the door for > 1 sec
            threshold_test = 0;
            while ~any(threshold_test)
               
                vbl = Screen('Flip', window);
                for frame = 1:frames_on
                    draw_background(window, backRect, xCenter, yCenter, backCol);
                    draw_doors(window, doorRects, doorClosedCol);
                    Screen('DrawingFinished', window);               
                    [x,y] = check_eyegaze_location; % get the current coordinates
                    idxs = check_doors(doorRects, x, y);
                    if sum(idxs) > 0 % still on a door?
                        if find(idxs) == didx
                            timer = GetSecs - startTime;
                            if timer > 1
                                threshold_test = 1; % the door has been chosen, move on
                            else
                                fprintf(fid, '%d\t%d\t%d\t%d\t%.3f\t%d\t%d\t%d\t%d\n', sub, sess, trial_num, cond, timer, 0, find(idxs), tgt_flag, 0); 
                            end
                        elseif find(idxs) ~= didx % another door has been selected, restart timer
                            startTime = GetSecs;
                            didx = find(idxs); % set new door index flag
                        end
                    else
                        door_on_flag = 0;
                    end
                    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                end
            end
            
            % flicker for as long as the door is selected
            frames_on = round(.2/ifi); % ~around 200 ms
            door_selected_flag = 1;
            
            while any(door_selected_flag)
                
                for frame = 1:frames_on
                    draw_background(window, backRect, xCenter, yCenter, backCol);
                    draw_doors(window, doorRects, doorClosedCol);
                    Screen('DrawingFinished', window); 
                    
                    [x,y] = check_eyegaze_location; % get the current coordinates
                    idxs = check_doors(doorRects, x, y);
                    
                    if sum(idxs) > 0 % still on a door?
                         if find(idxs) == didx % still on the same door? 
                            timer = GetSecs - startTime;  
                            
                        
                    else
                        door_selected_flag = 0;
                        door_on_flag = 0;
                    end
                    
                    
                cl.vbl = Screen('Flip', window, tStamp + cycle_time);
                end
                % continue to collect trial num, x's, y's, timestamp, and a 1
                % make door flash
                for frame = 1:frames_on
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
               
            end
            

            
        else
            didx = 0;
        end
        end
end