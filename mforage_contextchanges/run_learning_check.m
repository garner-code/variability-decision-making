% Variability and learning: visual foraging task
% K. Garner 2018/2023
% NOTES:
%
% Dimensions calibrated for 530 mm x 300 mm ASUS VG248 monitor (with viewing distance
% of 570 mm) and refresh rate of 100 Hz
%
% If running on a different monitor, remember to set the monitor
% dimensions, eye to monitor distances, and refresh rate (lines 169-178)!!!!
%
% Psychtoolbox XXXX - Flavor: 
% Matlab XXXX
%
% Task is a visual search/foraging task. Participants seek the target which
% is randomly placed behind 1 of 16 doors. There are two contexts to learn
% within each session (2 sessions in total) - 
% with 4 doors in each display being allocated p=.25
% Rate of switches between contexts depends on stage and condition 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear all the things
sca
clear all
clear mex

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make .json files functions to be written
%%%%%% across participants
% http://bids.neuroimaging.io/bids_spec.pdf
% 2. metadata file for the experiment - to go in the highest level, include
% task, pc, matlab and psychtoolbox version, eeg system (amplifier, hardware filter, cap, placement scheme, sample
% rate), red smi system, description of file structure
%%%%%% manual things
sub.num = input('sub number? ');
sub.stage = input('stage? 1 for learning, 2 for training, 3 for test, 4 for check ');
%sub.tpoints = input('points? '); % enter points scored so far
sub.experiment = input('experiment? 1 for ts, 2 for lt ');

experiment = sub.experiment;
if experiment == 1
    exp_code = 'ts';
elseif experiment == 2
    exp_code = 'lt';
end
sub_dir = make_sub_folders(sub.num, sub.stage, exp_code);
% sub.hand = input('left or right hand? (1 or 2)?');
% sub.sex = input('sub sex (note: not gender)? (1=male,2=female,3=inter)');
% sub.age = input('sub age?');

version   = 1; % change to update output files with new versions
stage = sub.stage;
% set randomisation seed based on sub/sess number
r_num = [num2str(sub.num) num2str(sub.stage)];
r_num = str2double(r_num);
rand('state',r_num);
randstate = rand('state');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% generate trial structure for participants and setup log files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('sub_infos.mat'); % matrix of counterbalancing info
% KG: MFORAGE: PUT NOTES HERE RE DEFINITION
% see generate_sub_info_mat for details
sub_config = sub_infos(sub.num, :);

[beh_form, beh_fid] = initiate_sub_beh_file(sub.num, sub.stage, sub_dir, exp_code); % this is the behaviour and the events log

% probabilities of target location and number of doors
load('probs_cert_world_v2.mat'); % this specifies that there are 4 doors with p=0.25 each 
door_probs   = probs_cert_world;
clear probs_cert_world 

ntrials = 2;
[~, ca_ps, cb_ps] = generate_trial_structure_learn(ntrials, sub_config, door_probs);

door_ps = [ca_ps; cb_ps; repmat(1/16, 1, 16)]; % create a tt x door matrix for display referencing later
ndoors = length(ca_ps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% define colour settings for worlds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Notes - changes = defining one set of greys for all door displays
% Context cue goes around the edge and will need something defined

% first put the colours in order of the counterbalancing
green = [27, 158, 119]; % context X
orange = [217, 95, 2]; % context Y
purple = [117, 112, 179]; % transfer A
pink = [189, 41, 138]; % transfer B
colour_options = {green, orange, purple, pink};

base_context_learn = [colour_options{sub_config(19)}; ... % KG: CHANGE THIS IF CHANGING SUB_CONFIG STRUCTURE
                      colour_options{sub_config(20)}];
transfer_context_learn = [colour_options{sub_config(21)}; ... % KG: CHANGE THIS IF CHANGING SUB_CONFIG STRUCTURE
                          colour_options{sub_config(22)}];

hole = [20, 20, 20];
col   = [160 160 160]; % set up the colours of the doors
doors_closed_cols = repmat([96, 96, 96]', 1, ndoors); 
door_open_col = hole;

context_cols =  [base_context_learn(1, :); ... % locations have been randomly assigned so no need to counterbalance colour
    base_context_learn(2, :)]; %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% other considerations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
button_idx = 1; % which mouse button do you wish to poll? 1 = left mouse button

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
back_grey = 200;
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, back_grey);
ifi = Screen('GetFlipInterval', window);
waitframes = 1;
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% compute pixels for background rect
pix_per_mm = screenYpixels/monitorYdim;
display_scale = .65; % VARIABLE TO SCALE the display size
display_scale_edge = .75; % scale the context indicator
base_pix   = 180*pix_per_mm*display_scale; 
backRect   = [0 0 base_pix base_pix];
edge_pix   = 180*pix_per_mm*display_scale_edge;
edgeRect   = [0 0 edge_pix edge_pix];

% and door pixels for door rects (which are defined in draw_doors.m
nDoors     = 16;
doorPix    = 26.4*pix_per_mm*display_scale; % KG: MFORAGE: May want to change now not eyetracking
[doorRects, xPos, yPos]  = define_door_rects_v2(backRect, xCenter, yCenter, doorPix);
% define arrays for later comparison
xPos = repmat(xPos, 4, 1);
yPos = repmat(yPos', 1, 4);
r = doorPix/2; % radius is the distance from center to the edge of the door

% timing % KG: MFORAGE: timing is largely governed by participant's button
% presses, not much needs to be defined here
time.ifi = Screen('GetFlipInterval', window);
time.frames_per_sec = round(1/time.ifi);
time.context_cue_on = round(1000/time.ifi); % made arbitrarily long so it won't turn off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% now we're ready to run through the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetMouse(xCenter, yCenter, window);
ntgts = sum(door_ps(1,:) > 0);
for count_trials = 1:2

 
    if count_trials == 1
        run_instructions_4_learn_check(window, screenYpixels);
        KbWait;
        WaitSecs(1); 
    end

    %%%%%%% trial start settings
    idxs = 0; % refresh 'door selected' idx
    door_select_count = 0; % track how many they got it in
    tgts = find(door_ps(count_trials, :) > 0);
    % set context colours according to condition
    edge_col = context_cols(count_trials, :); % KG: select whether it is context 1 or 2  


    tgt_images = randperm(99, ntgts);
    textures = cell(1, length(tgt_images));
    for itgts = 1:length(tgt_images)
        image_num = tgt_images(itgts);
        if image_num < 10
            if exist(sprintf('tgt0-100/tgt0%d.jpeg', image_num))
                im_fname = sprintf('tgt0-100/tgt0%d.jpeg', image_num);
            else
                im_fname = sprintf('tgt0-100/tgt0%d.jpg', image_num);
            end
        else
            if exist(sprintf('tgt0-100/tgt%d.jpeg', image_num))
                im_fname = sprintf('tgt0-100/tgt%d.jpeg', image_num);
            else
                im_fname = sprintf('tgt0-100/tgt%d.jpg', image_num);
            end
        end
        im = imread(im_fname);
        textures{itgts} = Screen('MakeTexture', window, im);
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% run trial
    tgt_found = 0;
    tgt_collection = [];
    % draw doors and start
    draw_edge(window, edgeRect, xCenter, yCenter, edge_col, 0, time.context_cue_on); 
    draw_background(window, backRect, xCenter, yCenter, col);
    draw_doors(window, doorRects, doors_closed_cols);
    Screen('Flip', window); 
    
    while ~(tgt_found < 4)
        
        door_on_flag = 0; % poll until a door has been selected
        while ~any(door_on_flag) 
            


        end

        
        % door has been selected, so open it
        while any(door_on_flag) 


        end
    end % end of trial
    

    
end


sca;
Priority(0);
Screen('CloseAll');
sprintf('total points = %d', points)
