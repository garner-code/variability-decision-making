function [beh_form, beh_fid] = initiate_sub_beh_file_v2(sub, sub_dir)

if sub < 10
    fname   = sprintf('sub-0%d_task-iforage-v1_beh.tsv', sub );
else 
    fname   = sprintf('sub-%d_task-iforage-v1_beh.tsv', sub);  
end
beh_fid = fopen( [sub_dir, '/beh/' fname], 'w');
        % here will print sub, trial num, cond num, timestamp (ms) + a 0 for
        % no button, the p loc, and the tgt loc (0 or 


fprintf(beh_fid, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', 'sub','sess','t','cond','onset','open_d','door','door_p','tgt_door','depress_dur','x','y');
beh_form = '%d\t%d\t%d\t%d\t%.3f\t%d\t%d\t%.3f\t%d\t%.3f\t%.3f\t%.3f\n';

end