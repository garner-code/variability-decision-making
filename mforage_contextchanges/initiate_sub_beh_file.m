function [beh_form, beh_fid] = initiate_sub_beh_file(sub, sess_n, sub_dir, ...
    stage)

if sub < 10
    fname   = sprintf('sub-0%d_ses-%d_task-mforage_stage-%d_beh.tsv', ...
        sub, sess_n, stage);
else 
    fname   = sprintf('sub-%d_ses-%d_task-mforage_stage%d_beh.tsv', ...
        sub, sess_n, stage);  
end
beh_fid = fopen( [sub_dir, sprintf('/ses-%d', sess_n), '/beh/' fname], 'w');
        % here will print sub, trial num, cond num, timestamp (ms) + a 0 for
        % no button, the p loc, and the tgt loc (0 or 

%fprintf(sub, sess, trial_n, cond, timer, door_on_flag, didx, d_p_idx, tgt_flag, tgt_found, x, y);
fprintf(beh_fid, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', ...
    'sub','sess','t','cond','onset','open_d','door','door_p','tgt_door','tgt_found','x','y');
beh_form = '%d\t%d\t%d\t%d\t%.3f\t%d\t%d\t%.3f\t%d\t%d\t%d\t%.3f\n';

end