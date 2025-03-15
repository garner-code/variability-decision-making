function [trlg_fid] = write_trials_and_params_MTS(sub, stage, exp_code, ...
    sub_dir, trials)

% write a record of the trials and various params for the MTS trials for the subject
if stage == 4
    ses_str = 'mts';
elseif stage == 3
    ses_str = 'test';
end

if sub < 10
    trlfname   = sprintf('sub-0%d_ses-%s_task-mts_trls.tsv', sub, ses_str);
else
    trlfname   = sprintf('sub-%d_ses-%s_task-mts_trls.tsv', sub, ses_str);
end

% define trial log file
ncol2save = 9; % in all cases, we want to save 5 columns of trials to the trial log
trlg_fid = fopen([sprintf('exp_%s', exp_code), '/', sub_dir, sprintf('/ses-%s', ses_str), '/beh/' trlfname], 'w');
fprintf(trlg_fid, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', ...
    'sub','sess','t','context','cres',...
    'loca','locb','locc','locd',...
    'probea','probeb','probec','probed');
fprintf(trlg_fid, '%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n', ...
    [repmat(sub, 1, length(trials(:,1)))', ...
    repmat(stage, 1, length(trials(:,1)))', ...
    trials(:,1:ncol2save)]');
fclose(trlg_fid);
end