function [trial_struct, ca_ps, cb_ps] = generate_trial_structure_train(ntrials, sub_config, door_probs, p)
%%%%%
% GENERATE_TRIAL_STRUCTURE_TRAIN
% generate the trial structure for the training stage
% ntrials for each context
% single switch group == context 1 and then context 2
% multi-switch group == switch contexts with switch p of p 
%
% inputs - ntrials = number of trials in each condition 
% sub_config [1, n] = subject counterbalancing info loaded from
% 'sub_infos.mat'
% door_probs [1, ndoors] = set of target probabilities to be distributed
% among the doors
%
% 
% RETURNS:
% [trial_struct] = 5 x ntrials matrix
% col 1 = trial number
% col 2 = context - 1 or 2
% col 3 = target door for that trial
% col 4 = a priori p(tgt door)
% col 5 = target for that trial
% ca_ps = 1,ndoor vector of which p goes with which door for context a
% cb_ps = as above, but for context b

ndoors = length(door_probs);
ntargets = 100; % total number of targets to choose from

% get locations for this stage % WARNING - HARD CODED
ca_idxs = sub_config(3:6); 
cb_idxs = sub_config(7:10);

tntrials = ntrials*2;% this assumes only 2 contexts, the
% hardcoded 2 would need to change for experiments involving more than 2.
trial_struct = zeros(tntrials, 4); 

trial_struct(:,1) = 1:length(trial_struct(:,1)); % allocate trial number

% set up single switch as in learning stage
[ttrials, ~] = size(trial_struct);
trial_struct(1:(ttrials/2),2) = datasample(1:2,1); % randomise which context comes first
trial_struct((ttrials/2)+1:ttrials,2) = 3-trial_struct(1,2);

% get target locations for each context
ca_ps = zeros(1,ndoors);
ca_ps(ca_idxs) = door_probs(door_probs > 0);
cb_ps = zeros(1,ndoors);
cb_ps(cb_idxs) = door_probs(door_probs > 0);
% now generate the tgt locs for each trial in each context
ca_locs = get_locs_given_probs_v2(ntrials, ca_ps);
cb_locs = get_locs_given_probs_v2(ntrials, cb_ps);

% allocate a target door to each trial
trial_struct(trial_struct(:,2) == 1, 3) = ca_locs;
trial_struct(trial_struct(:,2) == 1, 4) = max(ca_ps); % this needs to change if you ever have varying probabilities of the target doors
trial_struct(trial_struct(:,2) == 2, 3) = cb_locs;
trial_struct(trial_struct(:,2) == 2, 4) = max(cb_ps);

% now add which target will be presented on that trial
trial_struct(:,5) = 0;
trial_struct(trial_struct(:,2) == 1, 5) = randi(ntargets, 1, ntrials);
trial_struct(trial_struct(:,2) == 2, 5) = randi(ntargets, 1, ntrials);

% now create switching conditions   
trial_struct = create_switch_conditions(trial_struct, ntrials, p);

end