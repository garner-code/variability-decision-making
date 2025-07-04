function [] = run_instructions(window, screenYpixels, stage, house, ...
    badge_rects, badge_tex, points_structure)

Screen('TextStyle', window, 1);
Screen('TextSize', window, 20);

if stage == 1 
    if house == 1
    instructions = ...
        sprintf(['Nice work remembering the creatures!\n\n'...
                 'But now, some new animals have decided to play hide and seek...\n'...
                 'And guess what? You`re "it"!\n\n'...
                 'They`re hiding in the rooms of the house, and your job\n' ...
                 'is to find them.\n\n'...
                 'To look inside a room, just click on a door.\n\n'...
                 'Press any key to explore a house']);
    elseif house == 2
      instructions = ...
        sprintf(['Time to explore the next house!\n\n'...
                 'Let`s try to find the animals in 4 moves or less.\n\n'...
                 'Press any key to continue!\n']);
    end
elseif stage == 10
    instructions = ...
        sprintf(['We`re going to go through that one more time\n'...
        'Remember to try and find the animals in 4 moves\n']);
elseif stage == 2 
    instructions = ...
        sprintf(['Nice work so far!\n\n' ...
        'Now, it`s time to play for a bit longer...\n\n'...
        'Keep an eye on the colour of the house, \n\n' ...
        'because it will change from time to time. \n\n'...
        'And guess what?\n\n' ...
        'You can start winning points\n' ...
        'And with points you unlock badges!\n\n'...,
        'Keep trying to find the animals within 4 moves\n\n'...
        'Now, press any key to find out the exciting part\n']); 
    DrawFormattedText(window, instructions,'Center', screenYpixels*.3, [0 0 255]);
    Screen('Flip', window);
    KbWait();
    WaitSecs(0.5);

   instructions = ...
        sprintf(['Every time you hear the tone, that means you`ve earned 100 points!\n\n'...
        'But here is something to keep in mind -\n'...
        'Points won`t be available on every trial, just the bonus trials!\n'...
        'If you find the animal in 4 moves or less but don`t hear a tone\n'...
        'that just means there were no points up for grabs that time. No worries-\n'...
        'you`ll have plenty of chances to score!\n\n'...
        'Press any key to find out what points get you.\n\n']);
   DrawFormattedText(window, instructions,'Center', screenYpixels*.3, [0 0 255]);
   Screen('Flip', window);
   KbWait();
   WaitSecs(0.5);

   instructions = ...
        sprintf(['If you get enough points, you unlock badges!\n\n'...
        '%d points = Bronze Badge Achieved\n'...
        '%d = Silver Badge Attained\n'...
        '%d = Gold Badge Unlocked\n'...
        '%d points = You get the rare Champion Badge!\n\n'...
        'Ready to unlock badges?\n\n'...
        'Press any key to continue!'], points_structure(1), points_structure(2),...
        points_structure(3), points_structure(4));

elseif stage == 3 
    instructions = ...
        sprintf(['You`ve done such a great job so far - well done!\n\n' ...
        'Now it`s time for your final challenge, where things get a little trickier\n' ...
        '(but also more fun ;))\n\n'...
        'Press any key to find out what`s going to happen:)']);        
    DrawFormattedText(window, instructions,'Center', screenYpixels*.3, [0 0 255]);
    Screen('Flip', window);
    KbWait();
    WaitSecs(0.5);

  instructions = ...
        sprintf(['When you see the words `Memory + Search`,\n'...
        'you`ll soon see the creatures peeking out from their rooms,\n'...
        'like they did in your very first task.\n\n'...
        'Try to remember which ones you see and where they are.\n\n'...
        'Press any key to find out what happens next.']);
  DrawFormattedText(window, instructions,'Center', screenYpixels*.3, [0 0 255]);
  Screen('Flip', window);
  KbWait();
  WaitSecs(0.5);

  instructions = ...
      sprintf(['Instead of waiting for the creatures to reappear,\n' ...
      'you`ll now play hide and seek by clicking on the doors - \n'...
      'just like you did in the long task.\n\n'...
      'After a few rounds of searching, the creatures will peek from\n'...
      'their rooms again.\n\n'...
      'Now comes the big question:\n\n'...
      'If you think they`re in the same room as before - press `S` for SAME\n\n' ...
      'If you think they have changed rooms - press `D` for DIFFERENT.\n\n'...
      ]);
  DrawFormattedText(window, instructions,'Center', screenYpixels*.3, [0 0 255]);
  Screen('Flip', window);
  KbWait();
  WaitSecs(0.5);

  instructions = ...
      sprintf(['If you see the words `Just search`\n' ...
      'then there are no animals to remember this time\n'...
      'Go straight to playing hide and seek\n\n'...
      ]);
  DrawFormattedText(window, instructions,'Center', screenYpixels*.3, [0 0 255]);
  Screen('Flip', window);
  KbWait();
  WaitSecs(0.5);

  instructions = ...
      sprintf(['Please do your best - You`re so close to the finish line!\n\n'...
      'Press any key to begin the final round. Good luck!']);
end

if stage == 2
    draw_badges(window, [1, 1, 1, 1], badge_rects, badge_tex);
    DrawFormattedText(window, instructions,'Center', screenYpixels*.5, [0 0 255]);
else
    DrawFormattedText(window, instructions,'Center', screenYpixels*.3, [0 0 255]);
end

Screen('Flip', window);

end