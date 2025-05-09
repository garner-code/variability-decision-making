function sub_dir = make_sub_folders(sub, sess, exp_code)

exp_fol = sprintf('exp_%s', exp_code);

if sess == 1
    ses_str = 'learn';
elseif sess == 10
    ses_str = 'learn2';
elseif sess == 2
    ses_str = 'train';
elseif sess == 3
    ses_str = 'test';
elseif sess == 4
    ses_str = 'learn-check';
end

if sub < 10
    %sub_dir = sprintf('sub-0%d/ses-%d ', sub, sess_n);
    sub_dir = sprintf('sub-0%d', sub);
else
    %sub_dir = sprintf('sub-%d/ses-%d', sub, sess_n);
    sub_dir = sprintf('sub-%d', sub);
end
mkdir([exp_fol '/' sub_dir, sprintf('/ses-%s', ses_str), '/beh']);

end