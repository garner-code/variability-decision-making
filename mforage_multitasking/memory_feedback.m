function [] = memory_feedback(window, sub_resp, cresp, screenYpixels)
    % draw feedback for memory task

    if (cresp == sub_resp)
        
        feedback = 'Correct :)';

    else
        feedback = 'Incorrect :(';

    end
Screen('TextStyle', window, 1);
Screen('TextSize', window, 30);
DrawFormattedText(window, feedback, 'Center', screenYpixels*.1, [0 0 255]);