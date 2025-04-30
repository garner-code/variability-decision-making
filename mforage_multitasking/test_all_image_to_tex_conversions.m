function [] = test_all_image_to_tex_conversions(window, pix_per_mm)
% a function to test whether all images are ok

base_pix = 80*pix_per_mm;
image_rect = [0 0 base_pix base_pix];

% Get all files and folders in the current directory
all_tgt_files = dir('tgts');

% Filter out hidden files (those starting with a dot)
all_tgt_files = all_tgt_files(arrayfun(@(x) x.name(1) ~= '.',...
    all_tgt_files));



for i_cat = 1:length(all_tgt_files)

    % first get a list of files from the key directory
    these_ims = dir(fullfile(all_tgt_files(i_cat).folder, ...
        all_tgt_files(i_cat).name));
    these_ims = these_ims(arrayfun(@(x) x.name(1) ~= '.', ...
        these_ims));

    for i_ims = 1:length(these_ims)
        
        start = GetSecs;
        im_fname = fullfile(these_ims(i_ims).folder, ...
            these_ims(i_ims).name);
        im = imread(im_fname);
        tex = Screen('MakeTexture', window, im);

        Screen('DrawTexture', window, tex, [], image_rect);
        done = Screen('Flip', window);
        time_taken = done - start;
        
        sprintf('image %s from category %d took %.3f to draw and display', ...
            im_fname, i_cat, time_taken)
        WaitSecs(0.5);

    end
end
end
