function [] = run_instructions(window, screenYpixels, stage, house, ...
    badge_rects, badge_tex, points_structure)

Screen('TextStyle', window, 1);
Screen('TextSize', window, 20);
instruct_col = [255 255 255];

if stage == 1
    if house == 1
        instructions = ...
            sprintf(['Breaking news! (˶ ° O °)!!\n\n\n' ...
            'Animals are playing hide and seek in a square house with lots of tiny square doors...\n\n'...
            'Your task is to find the animal hiding behind a door!\n\n\n'...
            'To look for the animal, just click on any door. \n\n'...
            'Now, let’s have a lil practice round :)\n\n\n\n'...
            'Press any key to explore a house.']);
    elseif house == 2
        instructions = ...
            sprintf(['Time to learn the next house!\n\n\n'...
            'Let’s try and find the animal in 4 moves.\n\n\n\n'...
            'Press any key to start.\n']);
    % elseif house == 9
    %     instructions = ...
    %         sprintf(['We’re going to go through that one more time\n'...
    %         'Remember to try and find the animals in 4 moves\n']);
    end

elseif stage == 10
    instructions = ...
        sprintf(['We’re going to go through that one more time\n'...
        'Remember to try and find the animals in 4 moves\n']);
elseif stage == 2
    instructions = ...
        sprintf(['Nice work!\n\n\n' ...
        'Now, it’s time to play for a bit longer... and guess what?… \n\n' ...
        'Keep an eye on the colour of the house, \n' ...
        'because it will change from time to time. \n\n'...
        'You have a chance of winning ˖⁺‧₊˚✦ points! ✦˖⁺‧₊˚ \n' ...
        'Buuuut ONLY if you find the animal within 4 moves.\n\n'...
        'No fooling around anymore, young participant...\n\n\n' ...
        'Everytime you hear a tone, that means you won 100 points!\n\n\n'...,
        'Note that points will not be available on every trial. If you get the animal\n'...
        'in less than 4 moves and you don`t hear a sound, then there were no points.\n\n\n\n'...
        'Now, press any key to learn what these points will earn you!']);
    DrawFormattedText(window, instructions,'Center', screenYpixels*.3, instruct_col);
    Screen('Flip', window);
    KbWait();
    WaitSecs(0.5);

    instructions = ...
        sprintf(['If you win enough points, you can unlock some coveted badges!\n\n\n'...
        '%d points = Bronze Badge achieved\n'...
        '%d = Silver Badge attained\n'...
        '%d = Gold Badge unlocked\n'...
        '%d points = The rare Champion Badge will have your name written all over it!\n\n\n'...
        'You think you can reach Champion status, young participant?\n\n'...
        'Many pass through these Mathews building doors, yet not many can call themselves Champions...\n\n\n\n'...
        'Press any key to continue.'], points_structure(1), points_structure(2),...
        points_structure(3), points_structure(4));
    draw_badges(window, [1, 1, 1, 1], badge_rects, badge_tex);

elseif stage == 3
    instructions = ...
        sprintf(['Ooooh, you’re really getting the hang of it now!\n\n\n' ...
        'Let’s do a final run. All that hide and seek playing should surely pay off ;)...\n\n\n\n' ...
        'Press any key to start the finale. Good luck!']);
end

if stage == 2
    shift_txt = .5;
else
    shift_txt = .3;
end
DrawFormattedText(window, instructions,'Center', screenYpixels*shift_txt, instruct_col);
Screen('Flip', window);

end


