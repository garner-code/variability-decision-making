function [] = send_trigger(trg_id, sub, sess, trial_num, condition, onset_time, ioObj, port_address, trg_fid, trg_frm)
% this function sends the trigger 'id', and writes the event to the trigger
% log file (defined in run_forage_task.m)

% trg_id     = a single trigger value (integer)
% trial_num  = self explanatory
% condition  = single value to denote condition of that trial
% onset time = enter the timestamp from the just previous flip
% ioObj      = trigger function 
% port_address = port address for triggers
% trg_fid    = fid for trigger log
% trg_frm    = form of trigger log data 

% send the trigger
io32(ioObj, port_address, trg_id);
WaitSecs(.003); % wait 3 msec
io32(ioObj, port_address, 0); % set to low again

% get event
if (trg_id == 1 || trg_id == 2 || trg_id == 3)
    event = 't_start';
elseif (trg_id == 4)
    event = 'd_open';
elseif (trg_id == 5)
    event = 'd_clsd';
elseif (trg_id == 6)
    event = 'em_cal';
elseif (trg_id == 7 || trg_id == 8 || trg_id == 20 )
     event = 'pre_tgt';
elseif (trg_id == 9 || trg_id == 10 || trg_id == 21 )
    event = 'tgt_on';
elseif trg_id == 11
    event = 'all_drs_on';
end

% write to the trigger log
fprintf(trg_fid, trg_frm, sub, sess, trial_num, condition, trg_id, event, onset_time);
end