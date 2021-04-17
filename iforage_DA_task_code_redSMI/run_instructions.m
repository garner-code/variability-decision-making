function [] = run_instructions(window, screenYpixels)


Screen('TextStyle', window, 1);
Screen('TextSize', window, 20);
instructions = ...
    sprintf(['Your job is to look for the animals that are hiding behind the doors\n\n'...
    'You will use your eyes to open doors\n\n'...
    'To open a door, stare at it until it opens\n\n'...
    'Press any key to see the doors and have a practice.\n']);
DrawFormattedText(window, instructions,'Center', screenYpixels*.3, [0 0 255]);
Screen('Flip', window);

end