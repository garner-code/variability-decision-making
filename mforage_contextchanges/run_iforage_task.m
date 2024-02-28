% Variability and learning: visual foraging task
% K. Garner 2018
% NOTES:
%
% Dimensions calibrated for 530 mm x 300 mm ASUS VG248 monitor (with viewing distance
% of 570 mm) and refresh rate of 100 Hz
%
% If running on a different monitor, remember to set the monitor
% dimensions, eye to monitor distances, and refresh rate (lines 169-178)!!!!
% RUN ON SINGLE MONITOR DISPLAY ONLY
%
% Psychtoolbox 3.0.14 - Flavor: beta - Corresponds to SVN Revision 8301
% Matlab R2015a|R2017a|R2013a|R2012a
% Also run on Psychtoolbox 3.0.11
%
% SMI eyetracker functionality requires use of 32-bit Matlab
%
% Task is a visual search/foraging task. Participants seek the target which
% is randomly placed behind 1 of 16 doors. There are two contexts to learn
% within each session (2 sessions in total) - with 4 doors in each display being allocated p=.25
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear all the things
sca
clear all
clear mex
% make it work on linux
%setenv('WAYLAND_DISPLAY'); 
%<Screen('Preference','ConserveVRAM', 2^19);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up outputs

% make .json files functions to be written
%%%%%% across participants
% http://bids.neuroimaging.io/bids_spec.pdf
% 2. metadata file for the experiment - to go in the highest level, include
% task, pc, matlab and psychtoolbox version, eeg system (amplifier, hardware filter, cap, placement scheme, sample
% rate), red smi system, description of file structure
%%%%%% manual things
sub.num = input('sub number? ');
sub.sess = input('session? '); % 1 or 2
sub_dir = make_sub_folders(sub.num, sub.sess);

% sub.head = input('head circumference? in mm ');
% generate_channel_loc_json(sub.head, sub.num, sub_dir); % generate eeg cap metadata
% start_trial_num = input('trial number init?, 0 or last trial run ');
% sub.hand = input('left or right hand? (1 or 2)?');
% sub.sex = input('sub sex (note: not gender)? (1=male,2=female,3=inter)');
% sub.age = input('sub age?');
sub.stage = input('pilot, exp, ... ');
version   = 1; % change to update output files with new versions

% set randomisation seed based on sub/sess number
r_num = [num2str(sub.num) num2str(sub.sess)];
r_num = str2double(r_num);
rand('state',r_num);
randstate = rand('state');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% generate trial structure for participants
[beh_form, beh_fid] = initiate_sub_beh_file(sub.num, sub.sess, sub_dir, version); % this is the behaviour and the events log
% probabilities of target location
ntrials = 80; % per condition - must be a multiple of 20
load('probs_cert_world_v2.mat') % KG: MFORAGE: keep for now, will change
cert_probs   = probs_cert_world;
clear probs_cert_world

% get display configuration % KG: MFORAGE: Keep for now - will change
load('loc_configs.mat')
sub_loc_config = disp_configs(sub.num,:); % get the subject displays for the 2 sessions
if sub.sess == 1
     sub_loc_config = sub_loc_config(1:2);
else
     sub_loc_config = sub_loc_config(3:4);
end

% KG: MFORAGE: will change the below
[trials, cert_p_order, uncert_p_order] = generate_trial_structure_v3(ntrials, sub_loc_config, cert_probs);
door_ps = [cert_p_order; uncert_p_order; repmat(1/16, 1, 16)]; % create a tt x door matrix for display referencing later

% KG: MFORAGE: keep the below but the details may change
% add the 5 practice trials to the start of the matrix
n_practice_trials = 5;
practice = [ repmat(999, n_practice_trials, 1), ...
    repmat(3, n_practice_trials, 1), ...
    datasample(1:16, n_practice_trials)', ...
    repmat(999, n_practice_trials, 1), ...
    datasample(1:100, n_practice_trials)'];
trials   = [practice; trials];
    
if sub.num < 10
    trlfname   = sprintf('sub-0%d_ses-%d_task-mforage-v%d_trls.tsv', sub.num, sub.sess, version);
else
    trlfname   = sprintf('sub-%d_ses-%d_task-mforage-v%d_trls.tsv', sub.num, sub.sess, version);
end
% define trial log file % KG: MFORAGE: the below format may change -
% CAUTION
trlg_fid = fopen([sub_dir, sprintf('/ses-%d', sub.sess), '/beh/' trlfname], 'w');
fprintf(trlg_fid, '%s\t%s\t%s\t%s\t%s\t%s\t%s\n', 'sub','sess','t','cond','loc','prob','tgt');
fprintf(trlg_fid, '%d\t%d\t%d\t%d\t%d\t%d\t%d\n', [repmat(sub.num, 1, length(trials(:,1)))', repmat(sub.sess, 1, length(trials(:,1)))', trials]');
fclose(trlg_fid);

% save the subject parameters for this session    
if sub.num < 10
    sess_params_mat_name = [sub_dir, sprintf('/ses-%d', sub.sess), '/beh/', sprintf('sub-%0d-ses-%d_task-iforage-v%d_sess-params', sub.num, sub.sess, version)];
else
    sess_params_mat_name = [sub_dir, sprintf('/ses-%d', sub.sess), '/beh/', sprintf('sub-%d-ses-%d_task-iforage-v%d_sess-params', sub.num, sub.sess, version)];
end

save(sess_params_mat_name, 'sub', 'trials', 'beh_form', 'ntrials', 'cert_probs', ...
    'sub_loc_config', 'door_ps');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% randonly define colours allotted to each condition
% KG: MFORAGE: the way colours are used will change
green = [27, 158, 119];
orange = [217, 95, 2];
purple = [117, 112, 179];
pink = [189, 41, 138];
lightener = 50;
hole = [50, 50, 50];
all_colours = cat(3, [green+lightener; green; hole], ...
                       [orange+lightener; orange; hole], ...
                       [purple+lightener; purple; hole], ...
                       [pink+lightener; pink; hole]);
prac_world   = [160 160 160; 96 96 96; 224 224 224];

% get the paticipant colour mappings
load('col_assigns.mat');
sub_cols = reshape(col_assigns(sub.num,:), 2, 2)';
sub_cols = sub_cols(sub.sess, :);
world_colours = cat(3, all_colours(:,:,sub_cols(1)), all_colours(:,:,sub_cols(2)), prac_world);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% other considerations
breaks = 20; % how many trials inbetween breaks?
count_blocks = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% SET UP PSYCHTOOLBOX THINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up screens and mex
KbCheck;
KbName('UnifyKeyNames');
GetSecs;
AssertOpenGL
Screen('Preference', 'SkipSyncTests', 0);
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
base_pix   = 180*pix_per_mm*display_scale; % KG: MFORAGE: May want to change now not eyetracking
backRect   = [0 0 base_pix base_pix];
% and door pixels for door rects (which are defined in draw_doors.m
nDoors     = 16;
doorPix    = 26.4*pix_per_mm*display_scale; % KG: MFORAGE: May want to change now not eyetracking
[doorRects, xPos, yPos]  = define_door_rects_v2(backRect, xCenter, yCenter, doorPix);
% define arrays for later comparison
xPos = repmat(xPos, 4, 1);
yPos = repmat(yPos', 1, 4);
r = doorPix/2; % radius is the distance from center to the edge of the door
col = [176, 112, 218]; % KG: MFORAGE: check if can delete this

% fixation
%nFixLoc  = 9;
fixPix   = 5*pix_per_mm*display_scale;
fixBase  = [0, 0, fixPix, fixPix];
%fixRects = CenterRectOnPointd(fixBase, xCenter-.5*fixPix, yCenter-.5*fixPix);
fixRects = CenterRectOnPointd(fixBase, xCenter, yCenter);
fixCol   = white;

% timing % KG: MFORAGE: THIS WILL PROBABLY CHANGE
time.ifi = Screen('GetFlipInterval', window);
time.frames_per_sec = round(1/time.ifi);
time.door_cycle_frames = time.frames_per_sec*.75; % rate at which door should oscillate when selected
time.door_cycle_time = time.door_cycle_frames * time.ifi;
time.tgt_on = .75;
time.find_to_tgt = .4;
time.fix_on = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% DONE SETTING UP PSYCHTOOLBOX THINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now we're ready to run through the experiment


SetMouse(xCenter, yCenter, window);

for count_trials = 1:length(trials(:,1))

 
    if count_trials == 1
        run_instructions(window, screenYpixels);
        KbWait;
        WaitSecs(1);
    end

    %%%%%%% trial start settings
    idxs = 0; % refresh 'door selected' idx
    % assign tgt loc and onset time
    tgt_loc = trials(count_trials, 3);
    tgt_flag = tgt_loc; %%%% where is the target
    
    % set colours according to condition
    col = world_colours(1, :, trials(count_trials, 2)); % background colours
    doors_closed_cols = repmat(world_colours(2, :, trials(count_trials, 2))', 1, nDoors); % door colours
    door_open_col = world_colours(3, :, trials(count_trials, 2)); % door colours
    
    % initial fixation
    draw_background(window, backRect, xCenter, yCenter, back_grey);
    %     fix_idx = randperm(nFixLoc, 1);
    tmpfixRect = fixRects;
    maxFixDiam = max(tmpfixRect) * 1.01;
    Screen('FillOval', window, fixCol, tmpfixRect, maxFixDiam);
    start_fix = Screen('Flip',window);
    % KG: MFORAGE: need to remove the above or set a time to keep it on

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% run trial
    %start = Screen('Flip', window); % will save this output
    tgt_found = 0;
    % initial onset and fixation
    draw_background(window, backRect, xCenter, yCenter, col);
    Screen('FillOval', window, fixCol, tmpfixRect, maxFixDiam);
    fix_start = Screen('Flip', window); % KG: MFORAGE: WILL CHANGE
   
    % draw doors and start
    draw_background(window, backRect, xCenter, yCenter, col);
    draw_doors(window, doorRects, doors_closed_cols);
    Screen('FillOval', window, fixCol, tmpfixRect, maxFixDiam);
    trial_start = Screen('Flip', window); % use this time to determine the time of target onset
    
    while ~any(tgt_found)

        door_on_flag = 0; % poll until a door has been selected
        while ~any(door_on_flag)
            
            % poll what the mouse is doing, until a door is opened
            [didx, door_on_flag] = query_door_select(door_on_flag, doors_closed_cols, window, ...
                                                                backRect,  xCenter, ...
                                                                yCenter, col, doorRects, ...
                                                                beh_fid, beh_form, ...
                                                                sub.num, sub.sess,...
                                                                count_trials, trials(count_trials,2), ...
                                                                tgt_flag, ...
                                                                xPos, yPos, ...
                                                                r, door_ps(trials(count_trials,2), :), trial_start);

        end
        
        % door has been selected, so open it
        while any(door_on_flag)
           % insert a function here that opens the door to reveal the
           % answer and then changes it back
           
        end
    end
    
    % KG: MFORAGE: May want to adjust this
    draw_target_v2(window, backRect, col, doorRects, doors_closed_cols, door_open_col, didx, trials(count_trials,5), xCenter, yCenter, time.door_cycle_time, fixCol, tmpfixRect, maxFixDiam);
    WaitSecs(time.tgt_on);
    
    if count_trials == n_practice_trials
        
        end_practice(window, screenYpixels);
        KbWait;
        WaitSecs(1);
    end
    
    
    if any(mod(count_trials-n_practice_trials, breaks))
    else
        if count_trials == n_practice_trials
        else
            take_a_break(window, count_trials-n_practice_trials, ntrials*2, breaks, backRect, xCenter, yCenter, screenYpixels);
            KbWait;
        end
        WaitSecs(1);
    end
    
end

sca;
Priority(0);
Screen('CloseAll');
ShowCursor
