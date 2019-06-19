function didx = do_doors_for_no_button_press(trial_start, doorRects, x, y, trial_num, cond, tgt_flag, sub, sess, fid)
    % this function checks whether the mouse cursor is hovering over a door
    % without selecting it
    % if the mouse is hovering over a door, then it writes which door to
    % file
    % selects samples every 10 ms
    WaitSecs(.01); % limit samples to every 10 msec
    idxs = check_doors(doorRects, x, y);
    if sum(idxs > 0)
        didx = find(idxs);
        timer = GetSecs - trial_start;
        
        % here will print sub, trial num, cond num, timestamp (ms) + a 0 for
        % no button, the p loc, and the tgt loc (0 or loc)
        %'sub','t','cond','onset','button','door','tgt_door','door_sel','depress_duration');
        fprintf(fid, '%d\t%d\t%d\t%d\t%.3f\t%d\t%d\t%d\t%d\n', sub, sess, trial_num, cond, timer, 0, find(idxs), tgt_flag, 0); 
    else didx = 0;
    end              
end