function [feedback] = get_performance_feedback(door_off_ts, door_on_ts,...
    door_idx_trialn, ...
    moves_record, ...
    trialn, breaks, stage)
    %%% get performance feedback for the end of block info
if stage < 3

    feedback.acc = NaN;
    feedback.rt = NaN;
else

    % now I want to get the rts from their data from trialn-breaks+1:trialn
    moves_goal = 4;
    feedback.acc = mean(moves_record((trialn-breaks+1):trialn-1) <= moves_goal);
    
    feedback_rts = door_on_ts(ismember(door_idx_trialn, ...
                             (trialn-breaks+1):trialn)) - ...
                   door_off_ts(ismember(door_idx_trialn, ...
                              (trialn-breaks+1):trialn));
    feedback.rt = median(feedback_rts);
end