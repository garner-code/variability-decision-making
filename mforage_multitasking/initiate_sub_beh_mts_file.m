function [beh_form, beh_fid] = initiate_sub_beh_mts_file(sub, sub_dir, ...
                                                           stage, exp_code)
% generate a file that will collect the trial event info for the
% multitasking task
if stage == 4
    ses_str = 'mts';
elseif stage == 3
    ses_str = 'test';
end
if sub < 10
    fname   = sprintf('sub-0%d_ses-%s_task-mts_beh.tsv', ...
        sub, ses_str);
else
    fname   = sprintf('sub-%d_ses-%s_task-mts_beh.tsv', ...
        sub, ses_str);
end

beh_fid = fopen( [sprintf('exp_%s', exp_code) '/' sub_dir, sprintf('/ses-%s', ses_str), '/beh/' fname], 'w');
        % here will print sub, trial num, cond num, timestamp (ms) + a 0 for
        % no button, the p loc, and the tgt loc (0 or 

fprintf(beh_fid, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', ...
    'sub','stage','t','context','tgts_on','prbs_on','resp','cresp','rt');
beh_form = '%d\t%d\t%d\t%d\t%f\t%f\t%d\t%d\t%.3f\n';

end