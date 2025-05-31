% minimal code required to test the display setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sca
clear all
clear mex

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% SET UP PSYCHTOOLBOX THINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up screens and mex
KbCheck;
KbName('UnifyKeyNames');
GetSecs;
AssertOpenGL
Screen('Preference', 'SkipSyncTests', 1);
PsychDebugWindowConfiguration;
monitorXdim = 530; % in mm % KG: MFORAGE: GET FOR UNSW MATTHEWS MONITORS
monitorYdim = 300; % in mm
screens = Screen('Screens');
screenNumber = max(screens);
% screenNumber = 0;
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
back_col = 0;
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, back_col);
ifi = Screen('GetFlipInterval', window);
waitframes = 1;
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);


% compute pixels for background rect
pix_per_mm = screenYpixels/monitorYdim;
% scaling to change stim displays proportionally
display_scale = 1; % VARIABLE TO SCALE the display size
%%%%%%%%%%%%
% define circles that will be used in the display
% will use Screen(‘DrawDots’, windowPtr, xy [,size] [,color]);
% xy = two-row vector containing the x and y coordinates of the dot centers, relative to "center”
% size = diameter of the circle, in pixels, can be a vector
% colour = you can provide a 3 or 4 row vector,which specifies an individual RGB or RGBA color
% for each corresponding point
% first, I define the main circle that everything will be drawn on
r_main = 100*pix_per_mm*display_scale; % 100 mm
r_edge = 104*pix_per_mm*display_scale; % for the coloured edge
% setting up a rect for the main for using filloval instead
d_base = [0, 0, r_main*2, r_main*2];
d_cent = CenterRectOnPointd(d_base, xCenter, yCenter);
d_edge = [0, 0, r_edge*2, r_edge*2];
e_cent = CenterRectOnPointd(d_edge, xCenter, yCenter);

main_col = [160 160 160]; % set up the colours of the doors
%%%%%%%%%%% set up doors
inner_r_mm = 40; 
n_inner = 8; % 8 doors on the inner ring
outer_r_mm = 80;
n_outer = 16; % 16 doors on the outer ring
ndoors = n_inner + n_outer;
[door_xys, door_size] = door_setup(pix_per_mm, display_scale, ...
    n_inner, inner_r_mm, n_outer, outer_r_mm, ...
    xCenter, yCenter);

%%% door colours
hole = [20, 20, 20];
doors_closed_cols = repmat([96, 96, 96]', 1, ndoors); 
door_open_col = hole;

%door_cols = rep
% note that door_xys will be used later for comparison to the position of
% the mouse cursor
r = door_size/2; % radius is the distance from center to the edge of the door

% and finally, the details for the fixation point
fix_r_mm = 5*pix_per_mm*display_scale;
d_fix = fix_r_mm*2;
fix_col = [0, 0, 0];

% timing 
time.ifi = Screen('GetFlipInterval', window);
time.frames_per_sec = round(1/time.ifi);
time.context_cue_on = round(1000/time.ifi); % made arbitrarily long so it won't turn off
time.wait_after_fix = round(0.4/time.ifi);


draw_fix(window, xCenter, yCenter, d_cent, main_col, d_fix, fix_col)
vbl = Screen('Flip', window);
KbWait();
draw_back_doors(window, e_cent, [184 237 132], ...
    d_cent, main_col, door_xys, door_size, doors_closed_cols);
WaitSecs(0.5);
Screen('Flip', window);
KbWait();

% now randomly select a target to draw
[tex, imfname] = make_search_texture(1:4, window, main_col);
% and now make a rect to show at one of the doors
tgt_door_xy = door_xys(:,1);
im_rect = [0, 0, door_size, door_size];
im_cent = CenterRectOnPointd(im_rect, tgt_door_xy(1), tgt_door_xy(2));
draw_back_doors(window, e_cent, [184 237 132], ...
    d_cent, main_col, door_xys, door_size, doors_closed_cols);
Screen('DrawTexture', window, tex, [], im_cent);
WaitSecs(0.5);
Screen('Flip', window);
KbWait();
Wait(0.5);

Screen('CloseAll');
