function [beh_form, beh_fid] = initiate_sub_beh_mt_file(sub, sub_dir, ...
                                                      exp_code)
% generate a file that will collect the trial event info for the
% multitasking task
ses_str = 'test';
if sub < 10
    fname   = sprintf('sub-0%d_ses-%s_task-mt_beh.tsv', ...
        sub, ses_str);
else
    fname   = sprintf('sub-%d_ses-%s_task-mt_beh.tsv', ...
        sub, ses_str);
end

beh_fid = fopen( [sprintf('exp_%s', exp_code) '/' sub_dir, sprintf('/ses-%s', ses_str), '/beh/' fname], 'w');
        % here will print sub, trial num, cond num, timestamp (ms) + a 0 for
        % no button, the p loc, and the tgt loc (0 or 

%fprintf(sub, sess, trial_n, cond, timer, door_on_flag, didx, d_p_idx, tgt_flag, tgt_found, x, y);
fprintf(beh_fid, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', ...
    'sub',ses_str,'t','cond','mt_bait','mt_tgt_loc','mt_tgt_id','mt_tgt_on','resp_on','rt','cresp','resp');
beh_form = '%d\t%d\t%d\t%d\t%d\t%d\t%d\t%.3f\t%.3f\t%.3f\t%d\t%d\n';

end