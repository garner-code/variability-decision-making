function sub_dir = make_sub_folders(sub)

if sub < 10
    %sub_dir = sprintf('sub-0%d/ses-%d ', sub, sess_n);
    sub_dir = sprintf('sub-0%d', sub);
else
    %sub_dir = sprintf('sub-%d/ses-%d', sub, sess_n);
    sub_dir = sprintf('sub-%d', sub);
end
mkdir([sub_dir, '/beh']);
mkdir([sub_dir, '/eyetrack']);
mkdir([sub_dir, '/eeg']);
end