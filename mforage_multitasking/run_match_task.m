% Variability and flexibility: mouse foraging task
% K. Garner 2018/2023/2025
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
sub.stage = 4; % match to sample stage (4 does not mean it was administered 4th)
sub.tpoints = 0; % enter points scored so far
sub.experiment = 'mt';
exp_code = sub.experiment;
sub_dir = make_sub_folders(sub.num, sub.stage, exp_code);
ses_str = 'mts';

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

[mts_form, mts_fid, mts_tgts] = initiate_sub_beh_mts_file(sub.num, sub_dir, ...
                                                stage, exp_code);

% set up some other params for running the task
tgt_loc_idx = 4:7; % for calling the trial matrix during the task
prb_loc_idx = 8:11;
ntrials = 12; % per context, note that neither context trials are double 
n_tgts_per_cat_per_trial = 2; % draw 2 from each category, on each trial
% this number
trials = generate_trial_structure_mts(ntrials, sub_config);
write_trials_and_params_MTS(sub.num, stage, exp_code, sub_dir, ...
    trials);
all_im_fnames = cell(size(trials,1), ...
    n_tgts_per_cat_per_trial*2); % for collecting during the experiment
% and saving at the end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% define colour settings 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
memory_colour = [247, 247, 247]; % border colour for now
ndoors = 16;
hole = [20, 20, 20];
col   = [160 160 160]; % set up the colours of the doors
doors_closed_cols = repmat([96, 96, 96]', 1, ndoors); 
door_open_col = hole;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% SET UP PSYCHTOOLBOX THINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up screens and mex

%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------
KbCheck;
KbName('UnifyKeyNames');
% setup to collect keyboard responses 
resp.same = KbName('s');
resp.diff = KbName('d');

%----------------------------------------------------------------------
%                       screen/stimuli etc
%----------------------------------------------------------------------
GetSecs;
AssertOpenGL
if where == 1 || where == 2
    Screen('Preference', 'SkipSyncTests', 1); %%%% only for debug mode!
    Screen('Preference', 'ConserveVRAM', 64); %%%% only for debug mode!
    %PsychDebugWindowConfiguration;
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
time.tgts_on = 2; % how long we'll keep the target stimuli on
time.mem_period = 2;
%time.probes_time_out = 2; % how many seconds until time out on the working memory task
time.feedback_on = 1;
frames.tgt_on_frames = round(time.tgts_on/time.ifi); % how many frames to keep tgts on for
frames.mem_period = round(time.mem_period/time.ifi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% now we're ready to run through the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run_mts_instructions(window,screenYpixels);
KbWait;
WaitSecs(1);

SetMouse(xCenter, yCenter, window);
trial_start = GetSecs; % legacy
for count_trials = 1:length(trials(:,1))

    % get target and probe locations for this trial
    tgt_locs = trials(count_trials,tgt_loc_idx);
    prb_locs = trials(count_trials,prb_loc_idx);
    % get some target identities

    [mem_tex, mem_im_fnames] = draw_memory_textures_for_trial(window, ...
        mts_tgts, n_tgts_per_cat_per_trial);
    all_im_fnames(count_trials, :) = mem_im_fnames;

    % set context colours according to condition
    edge_col = memory_colour; 
    % draw targets and start
    draw_mts_tgts(window, edgeRect, backRect, ...
                    edge_col, col, doorRects, doors_closed_cols,...
                    xCenter, yCenter, tgt_locs, mem_tex, trial_start);
    tgts_on = Screen('Flip', window);

    % draw doors closed and present at the end of the memory delay period
    draw_edge(window, edgeRect, xCenter, yCenter, edge_col, 0, time.context_cue_on); 
    draw_background(window, backRect, xCenter, yCenter, col);
    draw_doors(window, doorRects, doors_closed_cols);
    mem_delay_on = Screen('Flip', window, tgts_on + (frames.tgt_on_frames - 0.5) * time.ifi);
    
    % now present the targets at the probe locations at the end of the
    % period
    draw_mts_tgts(window, edgeRect, backRect, ...
                    edge_col, col, doorRects, doors_closed_cols,...
                    xCenter, yCenter, prb_locs, mem_tex, trial_start);
    prbs_on = Screen('Flip', window, mem_delay_on + (frames.mem_period - 0.5) * time.ifi);

    % now poll for the response
    waiting_for_resp = 1;
    vbl = prbs_on;
    resp_waitframes = 1;
    while waiting_for_resp

        draw_mts_tgts(window, edgeRect, backRect, ...
            edge_col, col, doorRects, doors_closed_cols,...
            xCenter, yCenter, prb_locs, mem_tex, trial_start);

        [key_down,secs, key_code] = KbCheck;
        if key_code(resp.same)
            
            sub_resp = 0;
            waiting_for_resp = 0;
        elseif key_code(resp.diff)

            sub_resp = 1;
            waiting_for_resp = 0;
        end
        vbl = Screen('Flip', window, vbl + (resp_waitframes - 0.5) * time.ifi);
    end
    rt = secs - prbs_on;

    memory_feedback(window, sub_resp, trials(count_trials, 3), screenYpixels);
    feedback_on = Screen('Flip', window);
    WaitSecs(time.feedback_on);

    % update trial info into log file
    fprintf(mts_fid, mts_form, sub.num, stage, count_trials, ...
              trials(count_trials,2), tgts_on, prbs_on, sub_resp, ...
              trials(count_trials, 3), rt);

end

% save image filenames, in case we need in the future
if sub < 10
    save([sprintf('exp_%s', exp_code) '/' sub_dir '/' 'ses-mts/' ...
        sprintf('sub-0%d_tgt_ids.mat', sub.num)], 'all_im_fnames', '-mat');

else
    save([sprintf('exp_%s', exp_code) '/' sub_dir '/' 'ses-mts/' ...
        sprintf('sub-%d_tgt_ids.mat', sub.num)], 'all_im_fnames', '-mat');
end

fclose(mts_fid);

end_text = 'This is the end! Press any key to continue...';
Screen('TextStyle', window, 1);
Screen('TextSize', window, 30);
DrawFormattedText(window, end_text, 'Center', screenYpixels*.1, [0 0 255]);
Screen('Flip', window);

waiting = 1;
while waiting
    [key_down, ~, ~] = KbCheck;
    if key_down
        waiting = 0;
    end
end

sca