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

where = 0; % office
%where = 1; % lab
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
sub.stage = input('stage? 1 for learning, 2 for training, 3 for test ');
if sub.stage == 3
    sub.transfer_block = input('transfer block? 1, 2, or 3...');
else
    sub.transfer_block = 0;
end
sub.tpoints = 0; % enter points scored so far
sub.experiment = 'circ';

experiment = sub.experiment;
exp_code = sub.experiment;

sub_dir = make_sub_folders(sub.num, sub.stage, exp_code);

% get sub info for setting up counterbalancing etc
load('sub_info.mat')
sub_config = sub_info(sub.num);
clear('sub_info');

version   = 1; % change to update output files with new versions
stage = sub.stage;
% set randomisation seed based on sub/sess number
r_num = [num2str(sub.num) num2str(sub.stage) num2str(sub.transfer_block)];
r_num = str2double(r_num);
rand('state',r_num);
randstate = rand('state');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% generate trial structure for participants and setup log files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% CIRC - this will change

if stage == 1
    sub.house = input('house number? 1 or 2 or 9 '); % 1 for the first house, 2 for house 2, 9 to go through both
    house = sub.house;
else
    house = 0; % not relevant because we are mixing up the houses, so set to zero
end
[beh_form, beh_fid] = initiate_sub_beh_file(sub.num, sub.stage, ...
    sub.transfer_block, sub_dir, exp_code, house); % this is the behaviour and the events log

% % probabilities of target location and number of doors
% this is to future proof against when we want to vary probabilities
ndoors_w_tgt = 6; % 6 doors per task in this iteration
ndoors_wo_tgt = 24-ndoors_w_tgt;
door_probs = [repmat(1/ndoors_w_tgt, 1, ndoors_w_tgt), ...
              repmat(0, 1, ndoors_wo_tgt)];
ndoors = length(door_probs);

%%%%%%%%% CIRC - need to change
if stage == 1 && house < 9% if its initial learning

    n_practice_trials = 5;
    ntrials = 300; % allows 50 exposures to each target location
    trials = generate_trial_structure_learn(ntrials, sub_config, ...
        door_probs, house);    

elseif stage == 1 && house == 9

    n_practice_trials = 0;
    ntrials = 120; 
    trials = generate_trial_structure_learn(ntrials, sub_config, ...
        door_probs, house); 

% elseif stage == 2

%     n_practice_trials = 0;
%     ntrials = 4*40; % must have whole integers for p=.7/.3 or .95/.05
%     lo_switch = .05;
%     hi_switch = .3;
%     if sub_config(2) == 1
%         switch_prob = lo_switch;
%     elseif sub_config(2) == 2
%         switch_prob = hi_switch;
%     end
%     max_reward_trials = ntrials - (ntrials*hi_switch); % 
%     [trials, ca_ps, cb_ps] = generate_trial_structure_train(ntrials, sub_config, door_probs, switch_prob);
% 
%     % now allocate 50 % of the switch trials to be reward available trials
%     reward_trials = find(~diff(trials(:,2)))+1;
%     n_reward_trials = min(max_reward_trials, round(length(reward_trials)/2));
%     reward_trials = datasample(reward_trials, n_reward_trials, 'Replace',false);
%     reward_trials = sort(reward_trials, 'ascend');
% elseif stage == 3
%     n_practice_trials = 0;
%     if experiment == 1
%         ntrials = 4*20;
%         switch_prob = .5;
%         [trials, ca_ps, cb_ps] = generate_trial_structure_tstest(ntrials, sub_config, door_probs, switch_prob);
%     elseif experiment == 2
%         ntrials = 4*10;
%         n_trials_per_transfer_type = ntrials;
%         [trials, ca_ps, cb_ps] = generate_trial_structure_lttest(ntrials, sub_config, door_probs);
%     end
end

% now for each stage, form a matrix of the door probabilities, relevant to
% that session
door_ps = zeros(3, ndoors);

if stage == 1
    
    task_a_doors = unique(trials(trials(:,2) == 1,3));
    task_b_doors = unique(trials(trials(:,2) == 2,3));
    if house == 1

        door_ps(1,task_a_doors) = max(door_probs);
    elseif house == 2

        door_ps(2, task_b_doors) = max(door_probs);
    else

        door_ps(1,task_a_doors) = max(door_probs);
        door_ps(2, task_b_doors) = max(door_probs);
    end
else
      %  door_ps = [ca_ps; cb_ps; repmat(1/length(ca_ps), 1, length(ca_ps))]; % create a tt x door matrix for display referencing later
end

% add the 5 practice trials to the start of the matrix
if stage == 1 && house == 1
    practice = [ repmat(999, n_practice_trials, 1), ...
        repmat(3, n_practice_trials, 1), ...
        datasample(1:ndoors, n_practice_trials)', ...
        repmat(999, n_practice_trials, 1), ...
        repmat(NaN, n_practice_trials, 1)];
    trials   = [practice; trials];
end

write_trials_and_params_file(sub.num, stage, exp_code, ...
    sub.transfer_block, house, ...
    trials, ...
    door_probs, sub_config, sub_dir);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% define colour settings for worlds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Notes - changes = defining one set of greys for all door displays
% Context cue goes around the edge and will need something defined

% first put the colours in order of the counterbalancing
green = [127, 201, 127]; 
purple = [190, 174, 212];
orange = [253, 192, 134];
yellow = [255, 255, 153];
pink = [240, 2, 127]; 

colour_options = {green, purple, orange, yellow, pink};
sub_colours = colour_options(sub_config.col_assign); % this means
% that the sub_colours go [house1, house2, transfer1, transfer2, transfer3]

base_context_learn = [sub_colours{1}; ... % KG: CHANGE THIS IF CHANGING SUB_CONFIG STRUCTURE
                      sub_colours{2}];
transfer_context_learn = [sub_colours{3}; ... % KG: CHANGE THIS IF CHANGING SUB_CONFIG STRUCTURE
                          sub_colours{4};
                          sub_colours{5}];
if stage == 1
    
    context_cols =  [base_context_learn(1, :); 
                     base_context_learn(2, :); 
                     [0, 0, 0]]; % finish with practice context cols
elseif stage == 2

    neutral_col = [0, 0, 0];
    context_cols = [neutral_col; neutral_col; neutral_col];

elseif stage == 3

    context_cols =  transfer_context_learn;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% other considerations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

breaks = 30; % how many trials inbetween breaks?
count_blocks = 0;
button_idx = 1; % which mouse button do you wish to poll? 1 = left mouse button

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% SET UP PSYCHTOOLBOX THINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up screens and mex
KbCheck;
KbName('UnifyKeyNames');
GetSecs;
AssertOpenGL
if ~where
    Screen('Preference', 'SkipSyncTests', 1);
    PsychDebugWindowConfiguration;
end
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
% will use Screen( DrawDots[, windowPtr, xy [,size] [,color] [,center] [,dot_type]);
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
inner_r_mm = 30;
n_inner = 8; % 8 doors on the inner ring
outer_r_mm = 70;
n_outer = 16; % 16 doors on the outer ring
ndoors = n_inner + n_outer;
[door_xys, door_size] = door_setup(pix_per_mm, display_scale, ...
    n_inner, inner_r_mm, n_outer, outer_r_mm, ...
    xCenter, yCenter);

%%% door colours
hole = [20, 20, 20];
door_closed_cols = repmat([96, 96, 96]', 1, ndoors); 
door_open_col = hole;

%door_cols = rep
% note that door_xys will be used later for comparison to the position of
% the mouse cursor
r = door_size/2; % radius is the distance from center to the edge of the door

% and finally, the details for the fixation point
fix_r_mm = 5*pix_per_mm*display_scale;
d_fix = fix_r_mm*2;
fix_col = [0, 0, 0];

% make all target categories available for the task
srch_tgts = 1:4;

% and make a rect for presenting the break images
base_pix   = 180*pix_per_mm*display_scale; 
backRect   = [0 0 base_pix base_pix];

% timing 
time.ifi = Screen('GetFlipInterval', window);
time.frames_per_sec = round(1/time.ifi);
time.context_cue_on = round(1000/time.ifi); % made arbitrarily long so it won't turn off
time.wait_after_fix = 0.4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% setting up sound for feedback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if where
    InitializePsychSound; % in case PC doesn't have .dll file
    % coin sound
    win_sounds = dir('win');
    % remove hidden files
    win_sounds = win_sounds(arrayfun(@(x) x.name(1) ~= '.',...
        win_sounds));
    % now read in mp3 files
    coin_handles = cell(1, numel(length(win_sounds)));
    for imp3 = 1:length(win_sounds)
        mp3fname = fullfile(win_sounds(imp3).folder, win_sounds(imp3).name);
        [y, freq] = audioread(mp3fname);
        coin_handles{imp3} = PsychPortAudio('Open', [], [], 0, freq, size(y, 2)); % get handle
        PsychPortAudio('FillBuffer', coin_handles{imp3}, y'); % fill buffer with sound
    end
    % Playback once at start
    PsychPortAudio('Start', coin_handles{1}, 1, 0, 1);
else
    coin_handles = 0;
end
feedback_goal = 6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% now we're ready to run through the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetMouse(xCenter, yCenter, window);

% things to collect during the experiment
if stage == 1 
    moves_record = [];
    moves_goal = 6;
end
tpoints = sub.tpoints;
trial_start = Screen('Flip', window); % use this to record relative timings 
% throughout experiment

for count_trials = 1:length(trials(:,1))

 
    if count_trials == 1
        run_instructions(window, screenYpixels, stage, experiment, house);
        KbWait;
        WaitSecs(1); 
    end

    %%%%%%% trial start settings
    idxs = 0; % refresh 'door selected' idx
    % assign tgt loc and onset time
    tgt_loc = trials(count_trials, 3);
    tgt_flag = tgt_loc; %%%% where is the target
    door_select_count = 0; % track how many they got it in
    % draw the target texture for the current trial
    if count_trials > 1
        Screen('Close', srch_tex);
    end
    [srch_tex, ~] = make_search_texture(srch_tgts, window);
    
    % set context colours according to condition
    edge_col = context_cols(trials(count_trials, 2), :); % select colour for 
    % context 1 or context 2
           
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% run trial
    tgt_found = 0;
   
    draw_fix(window, xCenter, yCenter, d_cent, main_col, d_fix, fix_col)
    vbl = Screen('Flip', window);
    fix_hit = 0;

    while ~any(fix_hit)
        draw_fix(window, xCenter, yCenter, d_cent, main_col, d_fix, fix_col);
        Screen('DrawingFinished', window);
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi); % limit samples to flip rate

        [x,y,buttons] = GetMouse(window);
        if buttons(button_idx)
            fix_check = doorSample(xCenter, yCenter, x, y); % if clicked, are they at fixation?
            if fix_check < fix_r_mm
                fix_hit = 1;
            end
        end
    end
    WaitSecs(time.wait_after_fix);

    % now start the trial!
    % Screen(‘DrawDots’, windowPtr, xy [,size] [,color]);
    draw_back_doors(window, e_cent, edge_col, ...
        d_cent, main_col, door_xys, door_size, door_closed_cols);
 
    while ~any(tgt_found)
        
        door_on_flag = 0; % poll until a door has been selected
        while ~any(door_on_flag) 
            
            % poll what the mouse is doing, until a door is opened
            [didx, door_on_flag, x, y] = query_door_select(door_on_flag, window, ...
                e_cent, edge_col, ...
                d_cent, main_col, ...
                door_xys, door_size, door_closed_cols, ...
                beh_fid, beh_form, ...
                sub.num, sub.stage,...
                count_trials, trials(count_trials,2), ...
                tgt_flag, ...
                r, door_ps(trials(count_trials,2), :), trial_start, ...
                button_idx);

        end

        door_select_count = door_select_count + 1;
        
        % door has been selected, so open it
        while any(door_on_flag) 
           % insert a function here that opens the door (if there is no
           % target), or that breaks and moves to the draw_target_v2
           % function, if the target is at the location of the selected
           % door
            
            % didx & tgt_flag info are getting here
            [tgt_found, didx, door_on_flag] = query_open_door(trial_start, ...
                sub.num, sub.stage, ...
                count_trials, trials(count_trials,2), ...
                door_ps(trials(count_trials,2), :), ...
                tgt_flag, ...
                window, ...
                e_cent, edge_col, ...
                d_cent, main_col, ...
                door_xys, door_size, door_closed_cols, ...
                door_open_col, didx, ...
                x, y, button_idx, ...
                beh_fid, beh_form);

        end
    end % end of trial
    
    % KG: MFORAGE: this feedback code may move dependening on other learning stages
    if stage < 3
        if stage == 1 
            feedback_on = 1;
        elseif stage == 2 && sum(reward_trials == count_trials)
            % is this a reward trial (i.e. find if count_trials exists in
            % reward_trials
            feedback_on = 1;
        else
            feedback_on = 0;
        end
    else 
        feedback_on = 0;
    end

    [points, tgt_on] = draw_target_v2(window, ...
                        e_cent, edge_col, ...
                        d_cent, main_col, ...
                        door_xys, door_size, door_closed_cols, ...
                        didx, srch_tex, ...
                        door_select_count, feedback_goal, feedback_on, ...
                        coin_handles, where);
        [~,~,buttons] = GetMouse(window);
    while buttons(button_idx)
        [~,~,buttons] = GetMouse(window);
    end



    if stage == 3 && experiment == 1
    else
       wait_on = GetSecs;
       WaitSecs(0.5-(wait_on - tgt_on)); % just create a small gap between target offset and onset, but not on the proactive switching task 
        % stop sound
    end
    % of next door
    tpoints = tpoints + points;

    if stage == 1 && house == 1 && count_trials == n_practice_trials

        end_practice(window, screenYpixels);
        KbWait;
        WaitSecs(1);
    end
    
    if any(mod(count_trials-n_practice_trials, breaks))
    else
        if count_trials == n_practice_trials
        else
            take_a_break(window, count_trials-n_practice_trials, ntrials*2, ...
                breaks, backRect, xCenter, yCenter, screenYpixels, tpoints, stage);
            KbWait;
        end
        WaitSecs(1);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% if in stage 1, tally up how many doors they got it in and see
%%%%%%%%%%%% if you can switch them to the next phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if stage == 1 && house < 9

    n_correct_required = 60; % 60, to give a greater probability of each door type appearing a good
    % number of times
    moves_record = [moves_record, door_select_count];

    if count_trials > n_practice_trials + n_correct_required
        go = tally_moves(moves_record, moves_goal, count_trials, n_correct_required); % returns a true if we should proceed as normal

        if ~go
            break
        end
    end
elseif stage == 1 && house == 9

    moves_record = [moves_record, door_select_count];
end % end stage 1 response tally

if stage == 3 && experiment == 2 && count_trials == n_trials_per_transfer_type
    run_house_change(window, screenYpixels); % let participants know they are changing house
end
    
end

sca;
Priority(0);
PsychPortAudio('Close');
Screen('CloseAll');

sprintf('total points = %d', tpoints)
if stage == 1 && house < 9 &&  ~go
    sprintf('achievement unlocked! proceed to next level')
elseif stage == 1 && house < 9 && count_trials == length(trials(:,1))
    sprintf('accuracy criterion wasn`t reached this time, check next stage :(')
elseif stage == 1 && house == 9
    acc_house_1 = mean(moves_record(trials(:,2) == 1) <= moves_goal);
    acc_house_2 = mean(moves_record(trials(:,2) == 2) <= moves_goal);
    sprintf('house 1 acc: %.2f, house 2 acc: %.2f', acc_house_1, acc_house_2)
end
