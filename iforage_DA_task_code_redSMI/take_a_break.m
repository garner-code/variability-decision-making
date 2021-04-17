function [] = take_a_break(window, count_trials, ntrials, breaks, backRect, xCenter, yCenter, screenYpixels)

% window = window
% count_trials = current trial number
% ntrials = total trials
% breaks = ntrials between each break
% backRect = Rect for image

Screen('TextStyle', window, 1);
Screen('TextSize', window, 30); 
instructions = ...
   sprintf(['Great work! \n'...
                 '%d/%d blocks complete\n'...
                 'Take a break...you earned it\n\n'...
                 'Press any key to continue.\n'], (count_trials/breaks), (ntrials/breaks));
DrawFormattedText(window, instructions,'Center', screenYpixels*.1, [0 0 255]);
im = imread(sprintf('break.jpeg'));
tex = Screen('MakeTexture', window, im);
centeredRect = CenterRectOnPointd(backRect, xCenter, yCenter);
Screen('DrawTexture', window, tex, [], centeredRect);
Screen('Flip', window);
end