function [beh_form, beh_fid, mem_tgts] = initiate_sub_beh_mts_file(sub, sub_dir, ...
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

if stage == 4
    % also, assign target categories to each task, and save the outcome
    n_categ = 4; % number of target categories
    tgt_alloc = randperm(n_categ);
    tgts.memory = tgt_alloc(1:2);
    tgts.search = tgt_alloc(3:4);

    if sub < 10
        save([sprintf('exp_%s', exp_code) '/' sub_dir '/' sprintf('sub-0%d_tgt_alloc.mat', sub)], 'tgts');

    else
        save([sprintf('exp_%s', exp_code) '/' sub_dir '/' sprintf('sub-%d_tgt_alloc.mat', sub)], 'tgts');
    end

    mem_tgts = tgts.memory;
end
end