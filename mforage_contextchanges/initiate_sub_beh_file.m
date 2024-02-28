function [beh_form, beh_fid] = initiate_sub_beh_file(sub, sess_n, sub_dir, version)

if sub < 10
    fname   = sprintf('sub-0%d_ses-%d_task-iforage-v%d_beh.tsv', sub, sess_n, version);
else 
    fname   = sprintf('sub-%d_ses-%d_task-iforage-v%d_beh.tsv', sub, sess_n, version);  
end
beh_fid = fopen( [sub_dir, sprintf('/ses-%d', sess_n), '/beh/' fname], 'w');
        % here will print sub, trial num, cond num, timestamp (ms) + a 0 for
        % no button, the p loc, and the tgt loc (0 or 


fprintf(beh_fid, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', 'sub','sess','t','cond','onset','open_d','door','door_p','tgt_door','tgt_on','tgt_found','depress_dur','x','y');
beh_form = '%d\t%d\t%d\t%d\t%.3f\t%d\t%d\t%.3f\t%d\t%d\t%d\t%.3f\t%.3f\t%.3f\n';

end