function [tex, im_fnames] = draw_memory_textures_for_trial(window, mts_tgts, ...
    n_tgts_per_cat_per_trial)
    % draw some target textures that we'll use for the memory target/probe
    % stages of the trial

    % Get all files and folders in the current directory
    all_tgt_files = dir('tgts');
    
    % Filter out hidden files (those starting with a dot)
    all_tgt_files = all_tgt_files(arrayfun(@(x) x.name(1) ~= '.',...
             all_tgt_files));
    tgt_cat_dirs = all_tgt_files(mts_tgts); % get categories for memory
    % trials

    % now, for each category, draw the selected target images
    im_idx = 0;
    im_fnames = {}; % to collect and save just in case we 
    % want to look at it in future
    for i_cat = 1:length(tgt_cat_dirs)

        % first get a list of files from the key directory
        these_ims = dir(fullfile(tgt_cat_dirs(i_cat).folder, ...
            tgt_cat_dirs(i_cat).name));
        these_ims = these_ims(arrayfun(@(x) x.name(1) ~= '.', ...
            these_ims));

        tgt_ids = randperm(length(these_ims), n_tgts_per_cat_per_trial);

        for i_ims = 1:length(tgt_ids)
            im_idx = im_idx + 1;
            im_fname = fullfile(these_ims(tgt_ids(i_ims)).folder, ...
                             these_ims(tgt_ids(i_ims)).name);
            im = imread(im_fname);
            im_fnames{im_idx} = im_fname;
            tex(im_idx) = Screen('MakeTexture', window, im);
        end
    end
end