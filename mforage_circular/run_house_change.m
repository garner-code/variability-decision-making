function [] = run_house_change(window, screenYpixels)


    instructions = ...
        sprintf(['Nice work!\n\n'...
                 'The animals have moved to another new house.\n\n'...
                 'Press any key to continue.\n']);

Screen('TextStyle', window, 1);
Screen('TextSize', window, 20);
instruct_col = [255, 255, 255];
DrawFormattedText(window, instructions,'Center', screenYpixels*.3, ...
    instruct_col);
Screen('Flip', window);

end