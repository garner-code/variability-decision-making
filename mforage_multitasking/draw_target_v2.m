function [points, tgt_on, srch_fname] = draw_target_v2(window, edgeRect, backRect, edgeCol, backCol, ...
    doorRects, doorCol,...
    didx, srch_tgts, xCenter, yCenter, context_on, trial_start,...
    door_select_count, feedback_on,...
    coin_handles, where)
% this function draws the target to the selected door
% backRect/backCol = features of background
% doorRects/doorCol = door features
% didx = id of the door where the tgt is
% image_num - a string of either '01'-'09' or '10'+ for the specific target
% found
% door_select_count = how many doors did they have to pick?
% feedback_on = do you want to give points feedback?
% ScreenYPixels - number of pixels along Y
% coin_handle - handle to audio feedback sound

% first, select a target image category
this_srch_categ = srch_tgts(randperm(length(srch_tgts), 1));
% Get all files and folders in the current directory
all_tgt_files = dir('tgts');
% Filter out hidden files (those starting with a dot)
all_tgt_files = all_tgt_files(arrayfun(@(x) x.name(1) ~= '.',...
    all_tgt_files));
tgt_cat_dir = all_tgt_files(this_srch_categ); % get the category for this
% trial
% get list of images from that directory
these_ims = dir(fullfile(tgt_cat_dir.folder, ...
    tgt_cat_dir.name));
% again, remove hidden files
these_ims = these_ims(arrayfun(@(x) x.name(1) ~= '.', ...
    these_ims));
% randomly select one
im_idx = randperm(length(these_ims), 1);
im_fname = fullfile(these_ims(im_idx).folder, ...
    these_ims(im_idx).name);
im = imread(im_fname);
srch_fname = im_fname;
tex = Screen('MakeTexture', window, im);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now compute performance relative to target
if feedback_on
    goal = 5; % KG: MFORAGE: This is hardcoded!
    if door_select_count >= goal
        points = 0;
    else
        points = goal - door_select_count;
    end

    %     Screen('TextStyle', window, 1);
    %     Screen('TextSize', window, 60);
    %     feedback = sprintf(['You got it in %d moves\n\n'...
    %                             '%d points\n\n'], door_select_count, points);
    %     DrawFormattedText(window, feedback,'Center', screenYpixels*.15, [255, 215, 0]);
else
    points = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% draw doors with target
draw_edge(window, edgeRect, xCenter, yCenter, edgeCol, trial_start, context_on);
draw_background(window, backRect, xCenter, yCenter, backCol);
draw_doors(window, doorRects, doorCol);
im_rect = doorRects(:, didx);
Screen('DrawTexture', window, tex, [], im_rect);
% start sound and draw the target
if ~where || where == 2
    if points > 0
        PsychPortAudio('Start', coin_handles{points}, 1, 0, 0);
    end
end
tgt.vbl = Screen('Flip', window);
tgt_on = tgt.vbl;

end