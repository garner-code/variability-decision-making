function [] = take_a_break(window, count_trials, ntrials, breaks, backRect, xCenter, yCenter, screenYpixels, tpoints, ...
    stage)

% window = window
% count_trials = current trial number
% ntrials = total trials
% breaks = ntrials between each break
% backRect = Rect for image

load('punny');

this_pun = punny{randperm(length(punny), 1)};

Screen('TextStyle', window, 1);
Screen('TextSize', window, 30);
if stage == 2 % only actually want points feedback in the second stage
    instructions = ...
        sprintf([this_pun '\n\n'...
        '%d/%d blocks complete\n'...
        'you have earned %d points so far\n'...
        'Take a break...you earned it\n\n'...
        'Press any key to continue.\n'], (count_trials/breaks), (ntrials/breaks), ...
        tpoints);
else
    instructions = ...
        sprintf([this_pun '\n\n'...
        '%d/%d blocks complete\n'...
        '\n'...
        'Take a break...you earned it\n\n'...
        'Press any key to continue.\n'], (count_trials/breaks), (ntrials/breaks));
end
DrawFormattedText(window, instructions,'Center', screenYpixels*.1, [0 0 255]);

%%%% read in the break image files and randomly select one
pics = dir('breakphotos');
hidden_idx = [];
for ipic = 1:length(pics) % remove any pesky hidden files
    if length(pics(ipic).name) < 5
        hidden_idx = [hidden_idx, ipic];
    end
end
pics(hidden_idx) = [];
this_pic = randperm(length(pics), 1);
this_pic_full_file = fullfile(pics(this_pic).folder, pics(this_pic).name);
im = imread(this_pic_full_file);
tex = Screen('MakeTexture', window, im);
centeredRect = CenterRectOnPointd(backRect, xCenter, yCenter);
Screen('DrawTexture', window, tex, [], centeredRect);
Screen('Flip', window);
end