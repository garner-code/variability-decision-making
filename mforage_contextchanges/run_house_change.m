function [] = run_house_change(window, screenYpixels)


    instructions = ...
        sprintf(['Nice work!\n\n'...
                 'That was one house.\n\n'...
                 'Now time to learn the hiding places in the next house.\n\n'...
                 'Press any key to continue.\n']);

Screen('TextStyle', window, 1);
Screen('TextSize', window, 20);

DrawFormattedText(window, instructions,'Center', screenYpixels*.3, [0 0 255]);
Screen('Flip', window);

end