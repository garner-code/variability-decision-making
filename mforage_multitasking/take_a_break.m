function [unlocked] = take_a_break(window, count_trials, ntrials, breaks, backRect, xCenter, yCenter, screenYpixels, tpoints, ...
    stage, points_structure, badge_rects, badge_tex)

% window = window
% count_trials = current trial number
% ntrials = total trials if stage 1, or 2, vector of n trials per block if
% stage 3
% breaks = ntrials between each break
% backRect = Rect for image


Screen('TextStyle', window, 1);
Screen('TextSize', window, 30);
if stage == 2 % only actually want points feedback in the second stage
    
    main_instructions = sprintf('%d/%d blocks complete!\n\n', (count_trials/breaks),...
                                (ntrials/breaks));

    badge_break = sum(tpoints >= points_structure);

    if ~badge_break

        badge_instructions = sprintf(...
            ['You have scored %d points so far\n'...
            'You need %d points to unlock Bronze!\n\n'],...
             tpoints, points_structure(1));

    elseif badge_break == 1
        badge_instructions = sprintf(...
            ['%d points!\n...' ...
            'You won the Bronze badge for your performance!\n'...
            'You`ve got the doors on lock!...Or unlocked?\n'...
            'You need %d points to unlock Silver!\n\n'],...
            tpoints, points_structure(2));

    elseif badge_break == 2
        badge_instructions = sprintf(...
            ['%d points!\n...'...
            'You won the Silver badge!\n'...
            'The hunt intensifies...can you smell gold?\n'...
            'You need %d points to unlock Gold!\n\n'],...
            tpoints, points_structure(3));

    elseif badge_break == 3
        badge_instructions = sprintf(...
            ['%d points!\n...'...
            'You won the Gold badge!\n'...
            'Not even the forest can hide from you now...\n'...
            'You need %d points to unlock the Champion badge!\n\n'],...
            tpoints, points_structure(4)); 

    elseif badge_break == 4

        badge_instructions = sprintf(...
            ['%d points!\n...'...
            'You won the Champion badge!\n'...
            'You`ve out-hide-and-seeked them all!\n'...
            'The animals whisper your name now...\n'...
            'You live on in their legends.'], tpoints);
     end

    final_instructions = sprintf(...
            ['Also, take a break...you earned it.\n\n'...
            'Press any key to continue.\n']);

    draw_badges(window, tpoints >= points_structure, badge_rects, badge_tex);
    DrawFormattedText(window, main_instructions, 'Center', screenYpixels*.5, [0 0 255]);
    DrawFormattedText(window, badge_instructions, 'Center', screenYpixels*.6, [0 0 255]);
    DrawFormattedText(window, final_instructions, 'Center', screenYpixels*.8, [0 0 255]);

else

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
    centeredRect = CenterRectOnPointd(backRect*.8, xCenter, yCenter*.45);
    Screen('DrawTexture', window, tex, [], centeredRect);

    load('punny');
    this_pun = punny{randperm(length(punny), 1)};
    
    if stage == 3 % if its stage 3, then 
        
        this_block = breaks-1;
        total_blocks = length(ntrials);
    else
        this_block = count_trials/breaks;
        total_blocks = ntrials/breaks;

    end

    instructions = ...
        sprintf([this_pun '\n\n'...
        '%d/%d blocks complete\n'...
        '\n'...
        'Take a break...you earned it\n\n'...
        'Press any key to continue.\n'], this_block, total_blocks); 
        DrawFormattedText(window, instructions,'Center', screenYpixels*.6, [0 0 255]);
end
Screen('Flip', window);

end