% code to save all the images with the appropriate circular mask
% K. Garner, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get all files and folders in the target directory
all_tgt_files = dir('tgts');
main_col = [160 160 160]; % colour of background in experiment

% Filter out hidden files (those starting with a dot)
all_tgt_files = all_tgt_files(arrayfun(@(x) x.name(1) ~= '.',...
    all_tgt_files));

for idir = 1:length(all_tgt_files)
    
    tgt_cat_dir = all_tgt_files(idir); % get the category for this
    % trial
    % get list of images from that directory
    these_ims = dir(fullfile(tgt_cat_dir.folder, ...
        tgt_cat_dir.name));
    % again, remove hidden files
    these_ims = these_ims(arrayfun(@(x) x.name(1) ~= '.', ...
        these_ims));

    % now for all images, load, define and apply the circular mask,
    % and save
    for iim = 1:length(these_ims)

        im_fname = fullfile(these_ims(iim).folder, ...
            these_ims(iim).name);
        im = imread(im_fname);

        % now create a circular mask
        [imrows, imcols] = size(im(:,:,1));
        im_x_cent = imcols/2;
        im_y_cent = imrows/2;
        im_rad = min(imrows, imcols)/2;
        [X, Y] = meshgrid(1:imrows, 1:imcols);
        msk = (X - im_x_cent).^2 + (Y - im_y_cent).^2 <= im_rad^2;

        % now mask out each colour channel with the circle
        mskd_im = im; % Copy the original image
        for ichan = 1:3
            channel_data = mskd_im(:, :, ichan);
            channel_data(~msk) = main_col(ichan); % Set pixels outside the circle to 0 % CAN CHANGE FOR ANY VALUE
            mskd_im(:, :, ichan) = channel_data;
        end

        % now save the image
        msk_stm = regexprep(these_ims(iim).name, '\..*', '');
        msk_fn = fullfile(these_ims(iim).folder, ...
             sprintf('%s_mskd.jpg', msk_stm));
        imwrite(mskd_im, msk_fn);

    end

end




