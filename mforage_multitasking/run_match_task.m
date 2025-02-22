% Variability and flexibility: mouse foraging task
% K. Garner 2018/2023
% NOTES:
%
% Dimensions calibrated for 530 mm x 300 mm ASUS VG248 monitor 
% (with viewing distance of 570 mm) and refresh rate of 100 Hz
%
% If running on a different monitor, remember to set the monitor
% dimensions, eye to monitor distances, and refresh rate (lines 169-178)!!!!
%
% Psychtoolbox XXXX - Flavor: 
% Matlab XXXX
%
% Task is a delayed match to sample task. Participants see 3 targets for 1
% second, then the closed doors for 5 seconds. They are then represented 
% with the same targets which are either in the same location, or two have
% been swapped. Participant says whether the items are in the same place
% or a different place.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear all the things
sca
clear all
clear mex

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
where = 1; % if 0, in lab, if 1, in office, if 2, at home

% make .json files functions to be written
%%%%%% across participants
% http://bids.neuroimaging.io/bids_spec.pdf
% 2. metadata file for the experiment - to go in the highest level, include
% task, pc, matlab and psychtoolbox version, eeg system (amplifier, hardware filter, cap, placement scheme, sample
% rate), red smi system, description of file structure
% manual things
sub.num = input('sub number? ');
sub.stage = 4; % match to sample stage
sub.tpoints = 0; % enter points scored so far
sub.experiment = 'mt';
exp_code = sub.experiment;
sub_dir = make_sub_folders(sub.num, sub.stage, exp_code);

% get sub info for setting up counterbalancing etc
% sub infos is a matrix with the key info for locations for running the 
% task
version = 1; % change to update output files with new versions
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
% see generate_sub_info_mat for details
sub_config = sub_infos(sub.num, :);

%%%%%%%%%%%%%% K.G. add code for collecting behavioural data
ntrials = 4; % per context, note that neither context trials are double 
% this number
trials = generate_trial_structure_mts(ntrials, sub_config);
write_trials_and_params_MTS(sub.num, stage, exp_code, sub_dir, ...
    trials);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% define colour settings 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
green = [27, 158, 119]; 
purple = [117, 112, 179];
colour_options = {green, purple};

base_context_learn = [colour_options{sub_config(11)}; ... % KG: CHANGE THIS IF CHANGING SUB_CONFIG STRUCTURE
                      colour_options{3-sub_config(11)}];
ndoors = 16;
hole = [20, 20, 20];
col   = [160 160 160]; % set up the colours of the doors
doors_closed_cols = repmat([96, 96, 96]', 1, ndoors); 
door_open_col = hole;
context_cols = [90, 90, 90; ... % for now
                90, 90, 90];
nmts_tgts = 100; % how many to choose from overall

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% SET UP PSYCHTOOLBOX THINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up screens and mex
KbCheck;
KbName('UnifyKeyNames');
% setup to collect keyboard responses 
mt.resp_key_idx = KbName({'z','x'}); % also use this to score whether
% the mt resp was correct or incorrect - (using col 10 of the trials
% matrix)
key_flags = zeros(1,256); % an array of zeros
key_flags(mt.resp_key_idx)=1; % monitor only spaces
KbQueueCreate([],key_flags);

GetSecs;
AssertOpenGL
if where == 1 || where == 2
    Screen('Preference', 'SkipSyncTests', 1); %%%% only for debug mode!
    Screen('Preference', 'ConserveVRAM', 64); %%%% only for debug mode!
    PsychDebugWindowConfiguration;
end
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

% timing % KG: MFORAGE: timing is largely governed by participant's button
% presses, not much needs to be defined here
time.ifi = Screen('GetFlipInterval', window);
time.frames_per_sec = round(1/time.ifi);
time.context_cue_on = round(1000/time.ifi); % made arbitrarily long so it won't turn off
time.tgts_on = .5; % how long we'll keep the target stimuli on
time.mem_period = 2;
time.probes_time_out = 2; % how many seconds until time out on the working memory task

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% now we're ready to run through the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetMouse(xCenter, yCenter, window);
trial_start = GetSecs; % legacy
for count_trials = 1:length(trials(:,1))

    if count_trials == 1
        %run_instructions(window, screenYpixels, stage, 1);
        KbWait;
        WaitSecs(1);  
    end

    % get target and probe locations for this trial
    tgt_locs = trials(count_trials,4:6);
    prb_locs = trials(count_trials,7:9);
    % get some target identities
    tgt_ids = datasample(1:nmts_tgts,length(tgt_locs));
    % set context colours according to condition
    edge_col = context_cols(1,:); 

    % draw targets and start
    tgts_on = draw_mts_tgts(window, edgeRect, backRect, ...
                    edge_col, col, doorRects, doors_closed_cols,...
                    xCenter, yCenter, tgt_locs, tgt_ids, trial_start);
    while (GetSecs - tgts_on) < time.tgts_on
    end

    % draw doors closed
    draw_edge(window, edgeRect, xCenter, yCenter, edge_col, 0, time.context_cue_on); 
    draw_background(window, backRect, xCenter, yCenter, col);
    draw_doors(window, doorRects, doors_closed_cols);
    

end

    
