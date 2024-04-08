function [] = run_instructions_4_learn_check(window, screenYpixels)


    instructions = ...
        sprintf(['Good job! \n\n'...
                 'Let’s see how familiar you are with the animals’ hiding places. \n\n'...
                 'For each house, click on the doors you think animals like to hide behind.\n\n'...
                 'Press any key to start.\n']);

Screen('TextStyle', window, 1);
Screen('TextSize', window, 20);

DrawFormattedText(window, instructions,'Center', screenYpixels*.3, [0 0 255]);
Screen('Flip', window);

end