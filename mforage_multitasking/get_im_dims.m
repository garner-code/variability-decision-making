function [out] = get_im_dims()

all_tgt_files = dir('tgts');
% Filter out hidden files (those starting with a dot)
all_tgt_files = all_tgt_files(arrayfun(@(x) x.name(1) ~= '.',...
    all_tgt_files));

names = {};
wxh = [];

for i = 1:length(all_tgt_files)


    % trial
    % get list of images from that directory
    these_ims = dir(fullfile(all_tgt_files(i).folder, ...
        all_tgt_files(i).name));
    these_ims = these_ims(arrayfun(@(x) x.name(1) ~= '.',...
        these_ims));

    for j = 1:length(these_ims)

        % Read the image file
        im = fullfile(these_ims(j).folder, ...
            these_ims(j).name);

        image = imread(im);
        [width, height, ~] = size(image);

        % % Get image information
        % info = imfinfo(im);
        % 
        % % Extract resolution
        % width = info.Width;
        % height = info.Height;
        % xRes = info.XResolution;
        % yRes = info.YResolution;

        wxh = [wxh; [width, height]];
        ln = length(names);
        names{ln+1} = im;
    end

end

out.dims = wxh;
out.names = names;

end