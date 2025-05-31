function [beh_form, beh_fid] = initiate_sub_beh_file(sub, sess_n, transfer_n, ...
                                                      sub_dir, ...
                                                      exp_code, house)

% settings
if sess_n == 1
    ses_str = 'learn';
elseif sess_n == 2
    ses_str = 'train';
elseif sess_n == 3
    ses_str = 'test';
end

if sess_n == 1
    if sub < 10
        fname   = sprintf('sub-0%d_ses-%s_transfer-%d_house-%d_task-mforage_beh.tsv', ...
            sub, ses_str, transfer_n, house);
    else
        fname   = sprintf('sub-%d_ses-%s_transfer-%d_house-%d_task-mforage_beh.tsv', ...
            sub, ses_str, transfer_n, house);
    end
else
    if sub < 10
        fname   = sprintf('sub-0%d_ses-%s_transfer-%d_task-mforage_beh.tsv', ...
            sub, ses_str, transfer_n);
    else
        fname   = sprintf('sub-%d_ses-%s_transfer-%d_task-mforage_beh.tsv', ...
            sub, ses_str, transfer_n);
    end
end
beh_fid = fopen( [sprintf('exp_%s', exp_code) '/' sub_dir, sprintf('/ses-%s', ses_str), '/beh/' fname], 'w');
        % here will print sub, trial num, cond num, timestamp (ms) + a 0 for
        % no button, the p loc, and the tgt loc (0 or 

%fprintf(sub, sess, trial_n, cond, timer, door_on_flag, didx, d_p_idx, tgt_flag, tgt_found, x, y);
fprintf(beh_fid, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', ...
    'sub',ses_str,'t','cond','onset','open_d','door','door_p','tgt_door','tgt_found','x','y');
beh_form = '%d\t%d\t%d\t%d\t%.3f\t%d\t%d\t%.3f\t%d\t%d\t%d\t%.3f\n';

end